module Api
  module V1
    class WebhooksController < BaseController
      # Webhooks are global events, usually coming to a public endpoint.
      # We process them in the Public schema context (GatewayEvent is excluded/public).
      skip_around_action :switch_tenant

      # Pagar.me sends POST requests with payload
      def pagarme
        # We assume basic signature validation would happen in BaseController or via Middleware
        # For Pagar.me, we verify X-Hub-Signature usually.
        
        event = GatewayEvent.create!(
          gateway_id: params[:id], # Pagar.me event ID
          event_type: params[:event],    # Pagar.me event type (e.g., transaction_status_changed)
          payload: params.permit!.to_h # Save everything raw
        )

        # Enqueue for background processing
        ProcessWebhookJob.perform_later(event.id)

        head :ok
      end
    end
  end
end
