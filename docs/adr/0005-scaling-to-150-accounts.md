# ADR-0005: Scaling the landing zone to ~150 accounts

- **Status:** Proposed
- **Date:** 2026-10-04

## Context
The landing zone currently has 4 to 5 accounts in pure Terraform. Target: ~150 accounts, still with a very small team (one administrator).

## Options considered
1. **Manual Terraform**: one `aws_organizations_account` block per account, baseline configured account by account.
2. **Home-made account factory**: a Terraform module reads an account list (YAML) and creates each account with its baseline, triggered by a GitLab pipeline on merge request.
3. **Control Tower + Account Factory for Terraform (AFT)**: AWS-managed landing zone and account vending, customizations kept in Terraform.

## Decision
We choose **Control Tower + AFT** because:
- One administrator cannot build and maintain an account factory, guardrails and compliance reporting for 150 accounts.
- Account vending, baseline, guardrails and compliance dashboard are provided and maintained by AWS.
- AFT keeps Terraform for account requests and customizations, so existing modules are reused.

## Consequences
**Positive**
- Account creation in minutes, consistent baseline for every account.
- Less maintenance on the platform itself.

**Negative / trade-offs**
- Full migration of the existing landing zone: Control Tower brings its own Log Archive and Audit accounts, CloudTrail trail and Config recorders, which overlap with what already exists.
- Less control: AWS-managed stacks that must not be modified by hand (drift).

## When to revisit
- A dedicated platform team with strong Terraform skills, or a need for full control and heavy customization → home-made account factory (option 2).

## Related changes at 150 accounts
- **Terraform state**: split by account and by layer (organization, network, workloads) instead of one state, to limit blast radius and plan time.
- **OUs**: split Workloads into Prod, Non-Prod and Sandbox, plus a Suspended OU for closed accounts, each with its own SCPs.
- **Network**: one shared VPC per environment (prod, non-prod) via RAM, connected through a Transit Gateway (see ADR-0002, "When to revisit").
