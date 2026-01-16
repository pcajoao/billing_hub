# 📦 App Directory

This directory contains the core application code, following the **MVC** (Model-View-Controller) pattern, adapted for an API-first approach with Service Objects.

## 📂 Structure

| Directory | Description |
| :--- | :--- |
| **controllers/** | **Input/Output Layer.** Thin controllers that handle HTTP requests, authenticate users, and delegate business logic to Services. |
| **models/** | **Data Layer.** Active Record models representing database tables. Contains validations and associations. |
| **services/** | **Business Logic Layer.** Contains `Command` objects that encapsulate complex logic (e.g., Billing, Migration). |
| **jobs/** | **Async Layer.** Background jobs (Sidekiq) for processing webhooks and heavy tasks. |
| **gateways/** | **Adapter Layer.** (Located inside `services` or `gateways` usually, here likely `services/gateways` or top level). |
| **mailers/** | **Notification Layer.** Handles email sending. |

---

## 🌳 Component Relationship & Flow

The following diagram illustrates how Controllers delegate work to Services, which then interact with Models and Gateways.

```mermaid
graph TD
    classDef default fill:#fff,stroke:#333,stroke-width:1px,color:#000;
    classDef controller fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:#000;
    classDef service fill:#fff3e0,stroke:#e65100,stroke-width:2px,color:#000;
    classDef data fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px,color:#000;

    %% Controllers (Entry Points)
    subgraph Controllers
        IC[InvoicesController]:::controller
        WC[WebhooksController]:::controller
    end

    %% Services (Logic)
    subgraph Services
        PIS[Billing::ProcessInvoiceService]:::service
        MAS[Customers::MigrateFromAsaasService]:::service
        GW[Gateways::*]:::service
    end

    %% Jobs (Async)
    subgraph Jobs
        PWJ[ProcessWebhookJob]:::service
    end

    %% Models (Data)
    subgraph Models
        Inv[Invoice]:::data
        Tra[Transaction]:::data
        Cust[Customer]:::data
        GE[GatewayEvent]:::data
    end

    %% Relationships
    IC --> |POST /charge| PIS
    PIS --> |Finds| Inv
    PIS --> |Authorizes| GW
    GW --> |Updates| Inv
    GW --> |Creates| Tra

    WC --> |POST /webhook| GE
    WC --> |Enqueues| PWJ
    PWJ --> |Reads| GE
    PWJ --> |Updates| Inv

    MAS --> |Migration| Cust
```
