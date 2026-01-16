# 🏗 Technical Presentation: BillingHub Architecture

This document serves as a technical roadmap to present the BillingHub architecture, design decisions, and flows.

## 1. Overview & Objective
BillingHub is a **Centralized Financial Orchestration API**.
The goal is to decouple billing logic from products (PMS, Booking Engine) and centralize integration with Payment Gateways.

**Stack:** Ruby on Rails 8 (API Mode), PostgreSQL, Redis/Sidekiq.

---

## 2. Software Architecture (Design Patterns)
We adopted a clean architecture focused on **Encapsulation** and **Commands**.

### A) REST Pattern (External Interface)
- Versioned public interface: `namespace :api, module: :v1`.
- Skinny controllers (`InvoicesController`), responsible only for:
  1. Receiving input (JSON).
  2. Instantiating a Service (Command).
  3. Rendering Success (200) or Error (422).

### B) Service Command Pattern (Business Logic)
- All services include `SimpleCommand`.
- Single interface: `Service.call(args)`.
- Standardized return: `command.success?` and `command.result`.
- **Example:** `Billing::ProcessInvoiceService` encapsulates all billing rules, idempotency, and error handling.

### C) Gateway Layer (Clean Adapter/Command)
- We avoid "Mega Adapters" with dozens of methods.
- We use **Granular Commands** per action:
  - `Gateways::Pagarme::Charge`
  - `Gateways::Fake::Charge`
- **Dynamic Switch:** An initializer defines `CURRENT_GATEWAY` based on the environment (Prod vs Dev), allowing transparent dependency injection.
- **Complexity Absorption:** Commands convert Pagar.me SDK responses to pure Ruby `Hash`, isolating the rest of the system from external objects.

---

## 3. Data Modeling (Core Domain)
The database was designed for **Financial Immutability**:

*   **SUBSCRIPTION & INVOICE:** Control the contract and the invoice.
*   **TRANSACTION (Immutable Log):** Records every billing attempt. We never edit a transaction; we create a new one in case of retry.
*   **PAYMENT_METHOD (Security):** We store only the `gateway_id` (Token). No sensitive card data touches our database (PCI Compliance).
*   **GATEWAY_EVENT (Audit Log):** Disconnected "Black Box" table. Stores raw payload of all received webhooks for audit and replayability.

---

## 4. Critical Flows

### A) Billing Flow (Idempotent)
1. `ProcessInvoiceService` is called.
2. Opens a **Database Lock** on the Invoice (`with_lock`) to avoid race conditions.
3. Checks preconditions (pending status, default payment method).
4. Calls `CURRENT_GATEWAY::Charge.call`.
5. **If Success:** Creates Transaction(paid), updates Invoice status(paid).
6. **If Failure:** Creates Transaction(refused), returns error.

### B) Webhook Pipeline (Asynchronous)
1. **Ingestion:** `WebhooksController` receives POST from Pagar.me.
2. **Immediate Persistence:** Saves JSON to `GatewayEvent` table and responds 200 OK immediately.
3. **Processing:** Enqueues `ProcessWebhookJob`.
4. **Execution:** The Job reads the event and updates relevant invoices/transactions.

---

## 5. Migration Strategy (Asaas -> Pagar.me)
How to migrate thousands of cards without asking the customer to re-type (Churn Reduction)?

### A) Data Portability (PCI)
BillingHub does not touch sensitive data.
1. We request secure export (PGP Key) from Asaas.
2. Asaas sends encrypted data directly to Pagar.me.
3. Pagar.me imports and generates new Tokens (`gateway_id`).
4. **BillingHub:** Receives "De-Para" file and runs a script (`Customers::MigrateFromAsaasService`) to update `PaymentMethods` table with new tokens.

### B) Shadow Billing (Shadow Phase)
During transition, we operate in hybrid mode:
- **New Customers:** Go directly to Pagar.me.
- **Old Customers:** Stay on Asaas until "Key Turn" (Flag on Tenant/Customer).
- This ensures stability and safe rollback if necessary.

---

## 6. Development Environment (Simulation)
We implemented a `Gateways::Fake` for DX (Developer Experience).
It simulates scenarios based on value cents:
- Ending `00`: Approved.
- Ending `01`: Refused (Insufficient Funds).
- Ending `02`: Timeout.

This allows testing error and success flows without needing an external sandbox.
