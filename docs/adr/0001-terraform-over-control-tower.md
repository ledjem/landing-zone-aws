# ADR-0001: Pure Terraform instead of AWS Control Tower

- **Status:** Accepted
- **Date:** 2026-10-03

## Context
Multi-account landing zone of 4 to 5 accounts (Management, Security, Log Archive, Network, Workloads), built and run by a single person. Goal: full understanding and control of every resource.

## Options considered
1. **AWS Control Tower** (optionally with Account Factory for Terraform, AFT): managed landing zone with built-in guardrails and account vending.
2. **Pure Terraform on AWS Organizations**: every resource (OUs, SCPs, delegated admins, CloudTrail, networking) defined in code.

## Decision
We chose **pure Terraform** because:
- Everything is in code, with no AWS-managed stacks running in the background and no drift warnings when resources are customized.
- Every change goes through `terraform plan` and a Git review.
- The same tool and workflow apply to other cloud providers.

## Consequences
**Positive**
- Full visibility and control over the landing zone.
- Reusable modules (SCP, CloudTrail, RAM share, S3 bucket policy...).

**Negative / trade-offs**
- No one-click account vending, no ready-made guardrail catalog, no compliance dashboard.
- Baseline updates must be built and maintained by us instead of AWS.

## When to revisit
- If accounts must be created frequently, the team is small, or a fast AWS-supported compliance baseline is required: move to Control Tower + AFT, keeping Terraform for customizations.
