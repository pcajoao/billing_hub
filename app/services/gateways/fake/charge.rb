module Gateways
  module Fake
    class Charge
      prepend SimpleCommand
      
      def initialize(amount_cents:, token:, customer:, description:)
        @amount_cents = amount_cents
        @token = token
        @customer = customer
        @description = description
      end

      def call
        simulate_interaction
      end

      private

      def simulate_interaction
        case scenario_suffix
        when '00' then success_response
        when '01' then failure_response
        when '02' then simulate_timeout
        else success_response
        end
      end

      def scenario_suffix
        @amount_cents.to_s[-2..-1]
      end

      def success_response
        {
          success: true,
          tid: generated_tid,
          status: 'paid',
          error_message: nil
        }
      end

      def failure_response
        {
          success: false,
          tid: nil,
          status: 'refused',
          error_message: 'Insufficient Funds (Simulation)'
        }
      end

      def simulate_timeout
        raise StandardError, "Gateway Timeout (Simulation)"
      end

      def generated_tid
        "tid_fake_#{SecureRandom.hex(8)}"
      end
    end
  end
end
