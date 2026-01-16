module Billing
  class ProcessInvoiceService
    prepend SimpleCommand

    def initialize(invoice)
      @invoice = invoice
    end

    def call
      return unless valid_to_process?

      @invoice.with_lock do
        process_payment
      end
    end

    private

    def valid_to_process?
      return true if @invoice.pending?
      
      errors.add(:base, "Invoice is not pending") unless @invoice.pending?
      false
    end

    def process_payment
      return unless ensure_payment_method

      gateway_module = defined?(CURRENT_GATEWAY) ? CURRENT_GATEWAY : Gateways::Pagarme
      
      command = gateway_module::Charge.call(
        amount_cents: amount,
        token: payment_method.gateway_id,
        customer: customer,
        description: "Invoice ##{@invoice.id}"
      )

      if command.success?
        handle_response(command.result) 
      else
        errors.add(:base, command.errors.full_messages.join(", "))
      end
    end

    def handle_response(response)
      if response[:success]
        record_transaction(response, true)
        @invoice.pay!
        @invoice
      else
        record_transaction(response, false)
        errors.add(:base, "Payment failed: #{response[:error_message]}")
        nil
      end
    end

    def record_transaction(response, success)
      @invoice.transactions.create!(
        gateway_id: response[:tid],
        status: response[:status],
        amount_cents: amount,
        gateway_response_message: response[:error_message]
      )
    end

    def handle_exception(exception)
      Rails.logger.error("Invoice processing failed: #{exception.message}")
      errors.add(:base, "System error: #{exception.message}")
    end

    def ensure_payment_method
      return true if payment_method.present?

      errors.add(:base, "No default payment method found")
      false
    end

    def payment_method
      @payment_method ||= customer.default_payment_method
    end

    def customer
      @customer ||= @invoice.customer
    end

    def amount
      @invoice.calculate_total_cents
    end
  end
end
