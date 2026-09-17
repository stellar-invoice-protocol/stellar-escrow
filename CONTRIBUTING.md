# Contributing

Thanks for helping build Stellar Escrow.

## Setup

1. Rust stable: https://rustup.rs/
2. `rustup target add wasm32v1-none`
3. Stellar CLI: `cargo install --locked stellar-cli --features opt`
4. Node 18+ (for SDK and frontend)

## Running tests

```bash
cd contracts/escrow && cargo test
cd sdk-ts && npm test
cd frontend && npm run lint
```

Picking an issue
Issues are labeled by complexity: complexity:trivial, complexity:medium, complexity:high. Read the acceptance criteria before starting. If anything is unclear, comment on the issue first — don't guess.

PR rules
One issue per PR.

Include tests for any behavior change.

cargo test and cargo clippy -- -D warnings must pass.

Link the PR to the issue (Closes #123).

Commit style
feat:, fix:, docs:, test:, refactor:, chore:


---

### `CHANGELOG.md`

```markdown
# Changelog

## [Unreleased]

### Added

- Initial escrow contract skeleton (create, fund, release, refund, dispute)
- TypeScript SDK scaffold
- Next.js dashboard scaffold
- Event indexer scaffold
- Docs: architecture, access control, storage, error codes

## [0.0.1] - 2026-09-16

- Initial scaffold
deploy-testnet.env.example
Code snippet
# Copy to deploy-testnet.env and fill in. Never commit deploy-testnet.env.
STELLAR_SOURCE=your-identity-name
NETWORK=testnet
```