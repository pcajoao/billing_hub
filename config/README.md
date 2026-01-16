# ⚙️ Configuration (Config)

This directory controls how the application behaves in different environments and how it boots up.

## 📂 Structure

| File/Directory | Description |
| :--- | :--- |
| **routes.rb** | Defines the API endpoints (URLs) and maps them to Controllers. |
| **database.yml** | Configures database connections for Dev, Test, and Prod (PostgreSQL/SQLite). |
| **application.rb** | Main Rails configuration. |
| **environments/** | Environment-specific settings (`development.rb`, `production.rb`, `test.rb`). |
| **initializers/** | Scripts that run once on server startup. |

## 🗝️ Key Initializers

*   **`apartment.rb`**: Configures Multi-tenancy. Defines which models are global (excluded_models) and how schemas are created.
*   **`gateway.rb`**: **Critical logic.** Switches the Payment Gateway based on environment.
    *   `Prod` -> `Gateways::Pagarme`
    *   `Dev/Test` -> `Gateways::Fake` (unless ENV['USE_REAL_GATEWAY'] is set).
*   **`money.rb`**: Configures `MoneyRails` (BRL currency defaults).
