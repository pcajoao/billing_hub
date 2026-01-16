MoneyRails.configure do |config|
  config.default_currency = :brl
  
  # To handle the inclusion of validations for monetized fields
  # The default value is true, so this is optional
  # config.include_validations = true
end
