# ADR-0003: Security and Log Archive accounts in a single Security OU

- **Status:** Accepted
- **Date:** 2026-10-03

## Context
Landing zone run by one person, no dedicated security team. Two security-related accounts: Security (delegated admin for GuardDuty, Security Hub, Config) and Log Archive (central CloudTrail logs).

## Options considered
1. **One Security OU** containing both accounts, with shared SCPs.
2. **Two separate OUs**, one per account, each with its own SCPs.

## Decision
We chose **one Security OU** because:
- It follows the AWS recommended multi-account structure (Security OU with Log Archive and Security Tooling accounts).
- Both accounts need the same guardrails: deny disabling CloudTrail, GuardDuty or Config, deny deleting log buckets, deny leaving the organization.
- Access isolation is handled by the account boundary (separate accounts, separate permissions), not by the OU. An OU only groups accounts for policies.
- Simpler SCP management for a single administrator.

## Consequences
**Positive**
- One place to manage security guardrails.
- Aligned with AWS best practices, easy to explain and audit.

**Negative / trade-offs**
- Rules specific to one account (e.g. stricter immutability on Log Archive) must be attached directly to that account, which is less visible than OU-level policies.

## When to revisit
- Many security accounts (forensics, audit, per-region tooling) with very different guardrails → sub-OUs under Security.
- Strong separation of duties required by audit or regulation → stricter account-level SCPs, S3 Object Lock on the log bucket, and separate permission sets per team.
