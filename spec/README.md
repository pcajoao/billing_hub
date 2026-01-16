# 🧪 Specifications (Spec)

This directory contains the **Automated Test Suite**. We use **RSpec** for behavior-driven development.

## 📂 Structure

| Directory | Description |
| :--- | :--- |
| **services/** | **Core of our testing strategy.** Tests complex business logic (e.g., `process_invoice_service_spec.rb`). Focuses on scenarios like Success, Refusal, and Timeout. |
| **factories.rb** | **FactoryBot** definitions. Defines blueprints for creating test data (`invoice`, `customer`, `tenant`) validly and easily. |
| **rails_helper.rb** | RSpec configuration. Includes `DatabaseCleaner` and `Apartment` setup to handle multi-tenancy in tests. |
| **spec_helper.rb** | General RSpec configuration (random order, mock framework). |

## 🚀 Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific file
bundle exec rspec spec/services/billing/process_invoice_service_spec.rb
```
