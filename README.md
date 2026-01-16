# 🏦 BillingHub - Central Financial API

**BillingHub** is the central infrastructure for payments and subscriptions within the company's product ecosystem (PMS, Booking Engine, etc.).

## 🎯 Objective
To centralize financial complexity by abstracting communication with payment gateways (Pagar.me, Asaas, etc.) and providing a unified interface for billing, subscription management, and financial reconciliation.

---

## 🛠 Tech Stack

- **Language:** Ruby 3.1.2
- **Framework:** Ruby on Rails 7.1 (API Mode)
- **Database:**
  - **Production:** PostgreSQL
  - **Dev/Test:** SQLite3 (to facilitate local simulations)
- **Background Jobs:** Sidekiq + Redis
- **Testing:** RSpec, FactoryBot, Faker
- **Pattern:** Service Objects, Adapters, Multi-tenancy (Apartment)

---

## 🚀 How to Run the Project

### 1. Prerequisites
Ensure you have installed:
- Ruby 3.1.2
- Bundler (`gem install bundler`)
- Redis (for Sidekiq)

### 2. Installation
Clone the repository and install dependencies:
```bash
git clone <repository>
cd billing-hub
bundle install
```

### 3. Database Configuration
The development and test environments are configured to use **SQLite3** to simplify setup.
```bash
# Database creation and migration execution
rails db:create db:migrate
rails db:migrate RAILS_ENV=test
```

### 4. Running Tests (RSpec)
The project uses **RSpec** for automated testing. To run the test suite (including real-life billing scenario simulations):
```bash
bundle exec rspec
```
*Tip: Check `spec/services/billing/process_invoice_service_spec.rb` to see Approval, Refusal, and Timeout scenarios.*

---

## 📚 Project Documentation

To understand the architecture, flows, and data models, consult the `docs/` folder. **It is essential to read the files in the following order:**

1.  **[docs/PROJECT_RESUME.md](docs/PROJECT_RESUME.md)**
    - Overview, glossary, and architectural principles.
2.  **[docs/DOMAINS_AND_ERD.md](docs/DOMAINS_AND_ERD.md)**
    - Definition of models (Tenant, Customer, Invoice, Transaction) and their relationships.
3.  **[docs/FLOWS.md](docs/FLOWS.md)** (⚡ **Important**)
    - Visual diagrams of billing flows and migration strategy (Asaas -> Pagar.me).

> [!IMPORTANT]
> **Diagram Visualization (Mermaid)**
> Documentation files (especially `FLOWS.md`) use **Mermaid** to generate flow diagrams.
> To view them correctly, your IDE must support Mermaid.
> - **VS Code / Windsurf:** Install the **"Markdown Preview Mermaid Support"** extension.
> - **GitHub/GitLab:** Render natively.

---

## 🏛 Architecture and Patterns

### Adapter Pattern
Translation layer between BillingHub and Gateways (Pagar.me, Asaas). Located in `app/gateways`. Allows switching providers without altering core business logic.

### Services (SimpleCommand)
All business logic resides in services (`app/services`). Controllers are thin and only delegate to services.
- Example: `Billing::ProcessInvoiceService.call(invoice)`

### Multi-tenancy
The system is prepared for multi-tenancy (data separation by client/hotel) using the `ros-apartment` gem.
*Note: Temporarily disabled in Dev/Test to simplify RSpec.*
