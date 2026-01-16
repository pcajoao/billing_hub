# Gateway Configuration
# Selects the appropriate adapter based on the environment

Rails.application.reloader.to_prepare do
  # In production, we use the real Pagar.me adapter.
  # In development/test, we default to the FakeAdapter to avoid external calls,
  # but allow override via ENV variable if we really want to test integration.
  
  if Rails.env.production?
    CURRENT_GATEWAY = Gateways::Pagarme
  else
    # Dev/Test: Use Fake module unless USE_REAL_GATEWAY is set
    CURRENT_GATEWAY = ENV['USE_REAL_GATEWAY'] == 'true' ? Gateways::Pagarme : Gateways::Fake
  end
end
