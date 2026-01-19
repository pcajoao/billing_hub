# Main Flows

Here we explain how things happen "behind the scenes".

## 1. Billing Flow

How does it work when we need to charge a customer?

```mermaid
sequenceDiagram
    participant PMS as Product (PMS)
    participant BH as BillingHub (Us)
    participant W as Processor (Queue)
    participant GW as Pagar.me

    PMS->>BH: 1. Send charge! (Customer + Items)
    activate BH
    BH->>BH: 2. Creates "Pending" Invoice
    BH->>W: 3. Sends to Queue (to not block PMS)
    BH-->>PMS: 4. Responds: "Received, will process!"
    deactivate BH

    activate W
    W->>BH: 5. Picks Invoice from queue
    BH->>GW: 6. Tries to charge Card
    activate GW
    GW-->>BH: 7. Responds: "Success!" or "Denied"
    deactivate GW
    
    BH->>BH: 8. Saves result (Transaction)
    BH->>BH: 9. Updates Invoice to "Paid" (or keeps Pending)
    deactivate W

    Note over GW, BH: -- Later (Webhook) --
    GW->>BH: 10. Notifies: "Money actually received!"
    activate BH
    BH->>BH: 11. Confirms everything and archives.
    deactivate BH
```

---

## 2. Migration Plan (Asaas -> Pagar.me)

How we change gateways without stopping billing and without bothering the customer to ask for the card again.

```mermaid
flowchart TD
    classDef default fill:#fff,stroke:#333,stroke-width:1px,color:#000;
    classDef phase fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#000;
    classDef decision fill:#fff9c4,stroke:#fbc02d,stroke-width:2px,color:#000;
    classDef action fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,color:#000;

    Start([Start Migration]):::phase --> Export[Get data from Asaas]:::action
    Export --> Import["Save in BillingHub (mark as 'Source: Asaas')"]:::action
    
    Import --> HasCard{Has card saved?}:::decision
    
    HasCard -- Yes --> MigrateToken[Ask Asaas to send Tokens to Pagar.me]:::action
    MigrateToken --> SaveToken["Save new Tokens in BillingHub"]:::action
    SaveToken --> ShadowPhase[Shadow Phase]:::phase
    
    HasCard -- No --> RequestCard["Send email asking for new card"]:::action
    
    ShadowPhase -->|New Subscriptions| PagarMe[Charge in Pagar.me]:::action
    ShadowPhase -->|Old Subscriptions| Asaas[Continue charging in Asaas]:::action
    
    Asaas --> SwitchoverDate{Is it Key Turn Day?}:::decision
    SwitchoverDate -- Yes --> DisableAsaas[Stop charging in Asaas]:::action
    DisableAsaas --> EnablePagarMe[Start charging old ones in Pagar.me]:::action
    
    EnablePagarMe --> End([End! All unified]):::phase
```

### The Strategy

1.  **Transparent Migration:** We will use data portability (PCI) to migrate cards directly between Asaas and Pagar.me. The customer won't even notice the processor change.
2.  **Shadow Phase (Shadow Billing):**
    *   New customer? Goes directly to Pagar.me.
    *   Old customer? Stays on Asaas for a while, to ensure the new system is stable.
3.  **Key Turn Day:** When we are confident, we "turn off" charges in Asaas and activate in Pagar.me for old customers.
