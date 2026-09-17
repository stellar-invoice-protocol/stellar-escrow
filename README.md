# Stellar Escrow

A Soroban escrow protocol for freelance and cross-border payments on Stellar.

Clients lock funds, freelancers deliver, arbiters resolve disputes — all on-chain.

## Overview

Stellar Escrow is a decentralized escrow protocol built on the Stellar network using Soroban smart contracts. It enables secure, trustless payments for freelance work and cross-border transactions without intermediaries.

## Why This Exists

Freelance and cross-border payments still rely on middlemen who take 5–15% and hold funds for days. This protocol replaces the middleman with a Soroban contract: funds are locked in escrow, released on delivery, and disputes are resolved by a mutually agreed arbiter. No custodian. No wire delays. Auditable on-chain.

## Features

- **Trustless Escrow**: Funds are locked in smart contracts until conditions are met
- **Multi-party Support**: Client, freelancer, and arbiter roles with clear permissions
- **Dispute Resolution**: Built-in arbitration mechanism for conflict resolution
- **On-chain Transparency**: All transactions and state changes are publicly verifiable
- **Cross-border**: Built on Stellar for fast, low-cost international payments

## Repository Structure

- `contracts/escrow/` — Soroban escrow contract (Rust)
- `sdk-ts/` — TypeScript SDK for frontend/backend integrators
- `frontend/` — Next.js demo dashboard (client, freelancer, arbiter views)
- `indexer/` — Event indexer that watches escrow events into Postgres
- `docs/` — Architecture, access control, error codes, and specifications
- `scripts/` — Deploy and verify scripts

## Status

Early development. The contract is the priority; SDK, frontend, and indexer components are scaffolds.

The contract is the only component with implemented on-chain behavior today. The SDK currently exports
package metadata, the indexer only provides a buildable event-indexer entry point, and the frontend is a
static dashboard placeholder. Treat these integrations as development surfaces rather than production-ready
clients.

## Quick Start

### Prerequisites

- Rust and Cargo (latest stable)
- Soroban CLI (`cargo install --locked soroban-cli`)
- Node.js 18+ and npm/yarn/pnpm

### Build Contract

```bash
cd contracts/escrow
cargo test
cargo build --target wasm32v1-none --release
```

### Build SDK

```bash
cd sdk-ts
npm install
npm run build
```

### Run Frontend

```bash
cd frontend
npm install
npm run dev
```

## Deploy

```bash
# Copy the example environment file
cp deploy-testnet.env.example deploy-testnet.env

# Edit the environment file with your configuration
# edit deploy-testnet.env

# Deploy to testnet
source deploy-testnet.env && ./scripts/deploy-testnet.sh
```

For detailed deployment instructions, see the [scripts documentation](scripts/README.md).

## Documentation

- [Architecture](docs/architecture.md) — System design and component interactions
- [Access Control](docs/access-control.md) — Permissions and role-based access
- [Error Codes](docs/error-codes.md) — Error definitions and handling

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

MIT License

Copyright (c) 2026 Stellar Escrow contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.