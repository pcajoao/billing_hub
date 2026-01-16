# Entities and Database

This document explains how we organize data in BillingHub. The idea is to mirror the real world of payments.

## Visual Diagram (ERD)

```mermaid
erDiagram
    %% Main Entities
    PRODUCTS ||--|{ SUBSCRIPTIONS : offers
    PRODUCTS ||--|{ INVOICES : emits
    PRODUCTS {
        string name "ex: PMS, Booking Engine"
        string code "unique_identifier"
        string api_key "access_key"
        string webhook_url "notification_url"
        datetime created_at
        datetime updated_at
    }

    TENANTS ||--|{ CUSTOMERS : owns
    TENANTS {
        string product_id "FK"
        string name "Hotel/Account Name"
        string external_id "Original ID"
        datetime created_at
        datetime updated_at
    }

    CUSTOMERS ||--|{ PAYMENT_METHODS : has
    CUSTOMERS ||--|{ SUBSCRIPTIONS : subscribes
    CUSTOMERS ||--|{ INVOICES : pays
    CUSTOMERS {
        string tenant_id "FK"
        string external_id "ID in Product"
        string global_id "Unique ID (SSN/TaxID)"
        string name
        string email
        string doc_type
        string doc_number
        string gateway_id "ID in Pagar.me"
        datetime created_at
        datetime updated_at
    }

    PAYMENT_METHODS {
        string customer_id "FK"
        string gateway_id "Card Token"
        string brand "Card Brand"
        string last4 "Last 4 digits"
        string exp_month
        string exp_year
        string holder_name
        boolean is_default "Main?"
        datetime created_at
        datetime updated_at
    }

    SUBSCRIPTIONS ||--|{ INVOICES : generates
    SUBSCRIPTIONS {
        string customer_id "FK"
        string product_id "FK"
        string plan_id
        string status "active, canceled, past_due"
        datetime current_period_end "Due Date"
        string gateway_id
        integer amount_cents "Value"
        string cron_expression "Frequency"
        datetime created_at
        datetime updated_at
    }

    INVOICES ||--|{ INVOICE_ITEMS : contains
    INVOICES ||--|{ TRANSACTIONS : payment_attempts
    INVOICES {
        string customer_id "FK"
        string subscription_id "FK (Optional)"
        string product_id "FK"
        string status "pending, paid, overdue"
        datetime due_date "Due Date"
        integer total_amount_cents
        string gateway_id
        string checkout_url
        datetime created_at
        datetime updated_at
    }

    INVOICE_ITEMS {
        string invoice_id "FK"
        string description
        integer amount_cents
        integer quantity
        string item_type "subscription, addon"
        datetime created_at
        datetime updated_at
    }

    TRANSACTIONS {
        string invoice_id "FK"
        string gateway_id "Transaction ID"
        string status "authorized, paid, refused"
        string kind "credit_card, pix"
        integer amount_cents
        string gateway_response_code "Error code"
        text gateway_response_message "Error message"
        datetime created_at
        datetime updated_at
    }

    GATEWAY_EVENTS {
        string gateway_id
        string event_type "webhook_event"
        json payload "Raw Data"
        datetime processed_at
        datetime created_at
        datetime updated_at
    }

    %% Relationships
    PRODUCTS ||--o{ TENANTS : groups
```

### 1. Context (Who uses it?)
*   **Products:** Systems (PMS, Booking Engine, etc). Each has an `api_key` to send charges to BillingHub.
*   **Tenants:** Customers of the products (e.g., "Farm Hotel X").

### 2. Customers
*   The actual customer.
*   **Key Point:** We store `gateway_id` to know who this customer is in Pagar.me.

### 3. Payment Methods
*   **Security:** We do NOT store card information. We store only a **Token** provided by Pagar.me.
*   Maintains data security on both ends; token leaks do not compromise customer data.

### 4. Subscriptions
*   Recurring revenue guarantee. Controls how much to charge and when (cycle).
*   If the customer doesn't pay, status changes to `past_due` automatically.

### 5. Invoices and Items
*   The billing document.
*   It can have multiple **Items**: E.g., "September Fee" + "SMS Cost" + "Extra Fee". We sum everything and make a single charge.

### 6. Transactions
*   The real history.
*   If we try to charge the card and it returns "Insufficient Funds", we create a Failure transaction.
*   If we try again and it succeeds, we create a Success transaction.
*   We never delete this history.

### 7. Gateway Events (GatewayEvents)
*   The "Black Box". Everything Pagar.me sends us (via Webhook), we save here before processing.
*   If our code errors, the data is saved here for retry. Acts as a data entry log.
*   Initially, it doesn't matter what is saved in this model; date will be processed asynchronously.
