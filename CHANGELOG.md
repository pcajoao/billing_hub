# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-16

### Added
- **Architecture**: Implemented Clean Architecture with Service Command Pattern (`Billing::ProcessInvoiceService`).
- **Gateways**: Added Adapter Pattern for Payment Gateways.
  - `Gateways::Pagarme`: Production implementation.
  - `Gateways::Fake`: Development/Test simulation.
- **Multi-tenancy**: Integrated `ros-apartment` for tenant data isolation.
- **Testing**:
  - Configured RSpec with `FactoryBot` and `Faker`.
  - Added `DatabaseCleaner` to handle SQLite3 + Apartment locking issues.
  - Real-life billing scenarios specs (Success, Refusal, Timeout).
- **Documentation**:
  - Comprehensive `README.md` with Architecture Diagrams (Mermaid).
  - "Micro-docs" added: `app/README.md`, `config/README.md`, `db/README.md`, `spec/README.md`.
  - Detailed architectural guides: `docs/PROJECT_RESUME.md`, `docs/DOMAINS_AND_ERD.md`, `docs/FLOWS.md`.
- **Async Processing**: Added `ProcessWebhookJob` for background webhook handling.

### Changed
- **Internationalization**: All documentation translated to English.
- **Database**: Switched to SQLite3 for Development/Test environments to simplify setup (Zero-config).
- **Configuration**:
  - `gateway.rb` initializer now dynamically switches between Fake/Real gateways.
  - `apartment.rb` configured to exclude global models (`Tenant`, `Product`, `GatewayEvent`).

### Fixed
- **RSpec/Apartment Conflict**: Resolved `SQLite3::BusyException` by switching to `truncation` strategy and disabling transactional fixtures.
- **Docs Consistency**: Aligned `PROJECT_RESUME.md` flow description with the actual Asynchronous Architecture (Queue -> Job).
