#!/usr/bin/env bash
set -euo pipefail

STELLAR_SOURCE="${STELLAR_SOURCE:?set STELLAR_SOURCE}"
NETWORK="${NETWORK:-testnet}"
WASM="contracts/escrow/target/wasm32v1-none/release/stellar_escrow.wasm"

echo "[deploy] building..."
(cd contracts/escrow && stellar contract build)

if [[ ! -f "$WASM" ]]; then
  echo "ERROR: wasm not found at $WASM" >&2
  exit 1
fi

echo "[deploy] deploying to $NETWORK..."
stellar contract deploy --wasm "$WASM" --source "$STELLAR_SOURCE" --network "$NETWORK"
