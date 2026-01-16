require 'apartment'

# You can have Apartment route to the appropriate Tenant by adding some Rack middleware.
# Apartment can support many different "Elevators" that can take care of this routing to your various tenants.
# Require any elevators you need here if they are not already required.
#
# require 'apartment/elevators/generic'
# require 'apartment/elevators/domain'
# require 'apartment/elevators/subdomain'
# require 'apartment/elevators/first_subdomain'
# require 'apartment/elevators/host'

Apartment.configure do |config|
  # Add any models that you do not want to be multi-tenanted, but remain in the global (public) namespace.
  # A typical example would be a Customer or Tenant model that stores each Tenant's information.
  #
  config.excluded_models = %w{ Tenant Product GatewayEvent }

  # In order to migrate all of your Tenants you need to provide a list of Tenant names to Apartment.
  # You can make this dynamic by providing a Proc object to be called on migrations.
  # This object should yield an array of strings representing each Tenant name.
  #
  config.tenant_names = lambda { Tenant.pluck(:external_id) }

  # PostgreSQL:
  #   Specifies whether to use PostgreSQL schemas or a full database for each tenant.
  #
  #   The default behavior is true.
  #
  #   config.use_schemas = true
  #
  #   Schema name for persistence (Global)
  #   config.default_schema = "public"
end
