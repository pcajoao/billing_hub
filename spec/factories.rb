FactoryBot.define do
  factory :product do
    name { "PMS Hotel System" }
    code { "pms_#{SecureRandom.hex(4)}" }
    api_key { "ak_#{SecureRandom.hex(16)}" }
    webhook_url { "https://pms.com/hooks" }
  end

  factory :tenant do
    name { "Hotel Transylvania" }
    external_id { "hotel_#{SecureRandom.hex(4)}" }
    product
  end

  factory :customer do
    name { "Dracula" }
    email { "dracula@hotel.com" }
    doc_type { "CPF" }
    doc_number { "12345678900" }
    external_id { "customer_#{SecureRandom.hex(4)}" }
    association :tenant
  end

  factory :payment_method do
    gateway_id { "tok_#{SecureRandom.hex(8)}" }
    brand { "visa" }
    last4 { "1234" }
    association :customer
  end

  factory :subscription do
    plan_id { "plan_basic" }
    amount_cents { 10000 }
    status { "active" }
    cron_expression { "0 0 1 * *" }
    association :customer
    association :product
  end

  factory :invoice do
    total_amount_cents { 5000 }
    status { "pending" }
    association :customer
    association :product
  end
end
