module Gateways
  class AsaasAdapter < Base
    def initialize(api_key:)
      @api_key = api_key
      # Configure Asaas client
    end

    def charge_credit_card(amount_cents:, token:, customer:, description:)
      # Implementation for Asaas legacy calls (if needed during transitions)
      # Or just to read state
    end

    def create_subscription(plan_id:, payment_method_token:, customer:)
      # Support for migrating subscriptions FROM Asaas
    end

    def get_customer_token(asaas_customer_id)
      # Special method to help in retrieving tokens if Asaas allows PCI export
    end
  end
end
