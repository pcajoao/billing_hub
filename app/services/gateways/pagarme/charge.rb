require 'pagarme'

module Gateways
  module Pagarme
    class Charge
      prepend SimpleCommand

      def initialize(amount_cents:, token:, customer:, description:)
        @amount_cents = amount_cents
        @token = token
        @customer = customer
        @description = description
        
        # Initialize API Key (could also be done in an initializer if global)
        PagarMe.api_key = ENV['PAGARME_API_KEY']
      end

      def call
        process_charge
      end

      private

      def process_charge
        transaction = create_transaction
        transaction.charge
        
        build_response(transaction)
      rescue PagarMe::PagarMeError => e
        handle_gateway_error(e)
      end

      def create_transaction
        PagarMe::Transaction.new(
          amount: @amount_cents,
          card_hash: @token,
          customer: map_customer,
          postback_url: ENV['PAGARME_WEBHOOK_URL'],
          metadata: { description: @description }
        )
      end

      def build_response(transaction)
        success = ['paid', 'authorized'].include?(transaction.status)

        {
          success: success,
          tid: transaction.id.to_s,
          status: transaction.status,
          error_message: success ? nil : transaction.status_reason
        }
      end

      def handle_gateway_error(exception)
        errors.add(:base, exception.message)
        nil
      end

      def map_customer
        {
          external_id: @customer.global_id,
          name: @customer.name,
          email: @customer.email,
          type: @customer.doc_type == 'CPF' ? 'individual' : 'corporation',
          country: 'br',
          documents: [
            {
              type: @customer.doc_type.downcase,
              number: @customer.doc_number
            }
          ]
        }
      end
    end
  end
end
