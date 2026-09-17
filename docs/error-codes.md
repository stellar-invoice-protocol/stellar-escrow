# Error Codes

| Variant | Code | Meaning |
|---|---:|---|
| EscrowNotFound | 1 | The requested escrow ID is not stored. |
| InvalidAmount | 2 | The escrow amount must be greater than zero. |
| InvalidDeadline | 3 | The deadline must be later than the current ledger timestamp. |
| InvalidStatus | 4 | The requested operation is not valid for the escrow state or caller. |
| DeadlineNotPassed | 5 | A refund was requested before the deadline elapsed. |
# Contract Error Reference

This document provides a comprehensive reference for all public smart contract error codes, root causes, lifecycle contexts, and recommended client remediation.

---

## 1. Error Code Summary Table

| Code | Variant | HTTP / SDK Status | Description |
| :---: | :--- | :--- | :--- |
| **`1`** | `EscrowNotFound` | `404 Not Found` | The requested `escrow_id` does not exist in persistent storage. |
| **`2`** | `InvalidAmount` | `400 Bad Request` | Escrow amount is `<= 0`, or partial release split amounts do not sum to total escrow amount. |
| **`3`** | `InvalidDeadline` | `400 Bad Request` | The provided deadline timestamp is `<= current ledger timestamp`. |
| **`4`** | `NotClient` | `403 Forbidden` | Caller is not the authorized `client` for this escrow. |
| **`5`** | `NotFreelancer` | `403 Forbidden` | Caller is not the designated `freelancer`. |
| **`6`** | `NotArbiter` | `403 Forbidden` | Caller is not the assigned neutral `arbiter`. |
| **`7`** | `InvalidStatus` | `409 Conflict` | The operation is invalid for the escrow's current lifecycle state (e.g. attempting to fund an already released escrow). |
| **`8`** | `DeadlineNotPassed`| `400 Bad Request` | Attempting to execute `refund` before the deadline has elapsed (`ledger.timestamp <= deadline`). |
| **`9`** | `TransferFailed` | `500 Server Error` | Token balance or allowance is insufficient to complete the required asset transfer. |
| **`10`**| `Paused` | `503 Unavailable` | Contract operations are temporarily paused by the administrator. |
| **`11`**| `NotAdmin` | `403 Forbidden` | Caller is not the contract administrator authorized to toggle paused state. |
| **`12`**| `AdminAlreadySet` | `409 Conflict` | Attempted to initialize admin when admin is already configured. |

---

## 2. Method-by-Method Error Matrix

| Public Method | Possible Error Codes | Trigger Conditions |
| :--- | :--- | :--- |
| `create_escrow` | `Paused (10)`, `InvalidAmount (2)`, `InvalidDeadline (3)` | Paused contract, amount `<= 0`, or deadline in the past. |
| `fund_escrow` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)`, `TransferFailed (9)` | Not found, status != `Created`, insufficient client token balance/allowance. |
| `cancel_escrow` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)` | Not found, or status != `Created`. |
| `update_arbiter` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)` | Not found, or status != `Created` (funded escrows cannot change arbiter). |
| `release` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)` | Not found, or status != `Funded`. |
| `partial_release`| `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)`, `InvalidAmount (2)` | Not found, status != `Funded`, negative amounts, or split sum != escrow amount. |
| `refund` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)`, `DeadlineNotPassed (8)` | Not found, status != `Funded`, or ledger timestamp `<= deadline`. |
| `raise_dispute` | `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)` | Not found, status != `Funded`, or raised by an unauthorized party. |
| `resolve_dispute`| `Paused (10)`, `EscrowNotFound (1)`, `InvalidStatus (7)` | Not found, status != `Disputed`, or chosen winner is not client/freelancer. |
| `get_escrow` | `EscrowNotFound (1)` | Non-existent escrow ID query. |
| `set_paused` | `NotAdmin (11)` | Caller lacks admin signature. |
| `init_admin` | `AdminAlreadySet (12)` | Admin is already initialized. |

---

## 3. Caller Remediation Guide

### `EscrowNotFound (1)`
- **Remediation**: Check that the `escrow_id` was returned by a previous `create_escrow` invocation or queried from the indexer database. Verify network environment (e.g. Testnet vs Mainnet).

### `InvalidAmount (2)`
- **Remediation**: Ensure `amount > 0` in base units (stroops). For `partial_release`, ensure `freelancer_amount + client_amount == escrow.amount` and both are `>= 0`.

### `InvalidDeadline (3)`
- **Remediation**: Retrieve current ledger time via Horizon/RPC before constructing transaction. Pass a unix timestamp at least several minutes in the future.

### `InvalidStatus (7)`
- **Remediation**: Query `get_escrow(id)` to inspect current status before invoking operations. For example, wait for client funding before raising disputes or calling release.

### `DeadlineNotPassed (8)`
- **Remediation**: Wait until `ledger.timestamp() > deadline` before triggering auto-refund.

### `Paused (10)`
- **Remediation**: Operational pause is active. Wait for administrative unpause or contact protocol operators.

---

## 4. TypeScript SDK Error Handling Example

```typescript
import { StellarEscrowClient } from "@stellar-escrow/sdk";

const client = new StellarEscrowClient({
  contractId: "CDLZFC3SYJYDZT7K67VZ75HPJVIEUVNIXF47ZG2FB2RMQQVU2HHGCYSC",
});

try {
  await client.fundEscrow({ escrowId: 42n, client: "GBBD..." });
} catch (error: any) {
  if (error.message.includes("InvalidStatus")) {
    console.error("Escrow is not in 'Created' status. It may already be funded or cancelled.");
  } else if (error.message.includes("EscrowNotFound")) {
    console.error("Escrow #42 does not exist on-chain.");
  } else {
    console.error("Transaction failed:", error);
  }
}
```
