class ProcessWebhookJob < ApplicationJob
  queue_as :default

  def perform(gateway_event_id)
    event = GatewayEvent.find_by(id: gateway_event_id)
    return unless event

    # Logic to process event based on 'type'
    # E.g., if event.event_type == 'transaction_paid', find Invoice and mark as paid.

    Rails.logger.info "Processing Webhook Event #{event.id} - Type: #{event.event_type}"
    
    event.update!(processed_at: Time.current)
  end
end
