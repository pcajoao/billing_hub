module Customers
  class MigrateFromAsaasService
    prepend SimpleCommand

    # This service receives the "De-Para" mapping and updates the local tokens
    def initialize(old_token:, new_token:, extra_data: {})
      @old_token = old_token
      @new_token = new_token
      @extra_data = extra_data
    end

    def call
      payment_method = PaymentMethod.find_by(gateway_id: @old_token)
      
      return errors.add(:base, "PaymentMethod not found for token #{@old_token}") unless payment_method

      # Update to new Pagar.me token
      payment_method.update!(
        gateway_id: @new_token,
        brand: @extra_data[:brand] || payment_method.brand,
        last4: @extra_data[:last4] || payment_method.last4
        # We can also log this migration event if needed
      )
      
      payment_method
    end
  end
end
