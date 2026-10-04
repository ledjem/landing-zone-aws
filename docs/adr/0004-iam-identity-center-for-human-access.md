# ADR-0004: IAM Identity Center for human access

- **Status:** Proposed
- **Date:** 2026-10-03

## Context
Landing zone of 4 to 5 accounts, administered by one person today, more users expected later. Possible future connection to an on-premises Active Directory.

## Options considered
1. **IAM users in each account**: one user per person per account.
2. **Role assumption from the Management account**: log in once, then switch to a role in each member account.
3. **IAM Identity Center**: single sign-on portal, permission sets assigned to users or groups per account.

## Decision
We chose **IAM Identity Center** because:
- Temporary credentials only: no long-lived passwords or access keys spread across accounts.
- One place to manage users, groups, MFA and offboarding.
- Permission sets (Admin, ReadOnly...) are reusable across accounts and manageable in Terraform.
- Can connect to an external identity provider or Active Directory (AD Connector).
- No extra cost.

## Consequences
**Positive**
- Centralized, auditable access aligned with AWS best practices.
- Daily work no longer happens in the Management account (administration delegated to a dedicated account).

**Negative / trade-offs**
- Initial setup effort (permission sets, groups, assignments).
- Dependency on Identity Center: break-glass access (root or emergency IAM user, MFA-protected, unused day to day) must be kept for outages.

## When to revisit
- Large organization with an existing corporate IdP (Entra ID, Okta): use it as the identity source instead of the Identity Center directory.
- On-premises AD required: add AD Connector, with Identity Center administration delegated to a dedicated Identity account.
