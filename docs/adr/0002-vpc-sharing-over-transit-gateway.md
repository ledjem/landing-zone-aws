# ADR-0002: VPC sharing with AWS RAM instead of Transit Gateway

- **Status:** Accepted
- **Date:** 2026-10-03

## Context
Landing zone of 4 to 5 accounts, a single VPC with 2 private subnets, one region, no on-premises connectivity yet. The whole infrastructure is managed by one person.

## Options considered
1. **VPC peering**: one VPC per account, connected one-to-one (non-transitive).
2. **VPC sharing with AWS RAM**: one VPC owned by a Network account, subnets shared with the Workloads OU.
3. **Transit Gateway**: one VPC per account, all attached to a central hub (transitive routing).

## Decision
We chose **VPC sharing with AWS RAM** because:
- With a single VPC, there is no inter-VPC connectivity to build: no peering mesh, no hub.
- The network is centralized in the Network account: workload accounts deploy resources but cannot change subnets, route tables or NACLs.
- Subnets are shared at OU level, so every new account in Workloads gets them automatically.
- No extra cost (Transit Gateway charges per attachment-hour and per GB processed).
- It matches the pattern used at the European Parliament.

## Consequences
**Positive**
- Simple, cheap, centrally controlled network.
- One IP range to plan.

**Negative / trade-offs**
- Weaker isolation: workloads from different accounts share the same network, and isolation relies only on security groups.
- A network mistake in the shared VPC affects every account using it (larger blast radius).
- A VPC lives in one region only.

## When to revisit
- Need for network segmentation (e.g. prod and non-prod in separate VPCs) → Transit Gateway, keeping RAM sharing inside each VPC.
- Multi-region or on-premises connectivity (VPN, Direct Connect) → Transit Gateway.
- Only 2 or 3 VPCs to connect, with no growth expected → VPC peering is enough.
