# Repository Guidelines

## Project Structure & Module Organization
This repository is an Ansible project for bootstrapping hosts and deploying the Bifrost stack.

## Required Input
Before deployment, validate `inventory/hosts.yml`:
- Check that `ansible_host` is set for both `asgard` and `midgard`.
- If either host is missing `ansible_host`, ask the user for the missing IP address(es).
  Explicitly mention that host's `bifrost_role` (from `inventory/host_vars/<host>.yml`) in the prompt
- Update `inventory/hosts.yml` so both hosts have `ansible_host` values.

Before deployment, validate `inventory/group_vars/all.yml`:
- If `domain_name` is missing or empty, ask the user for a domain name.
- Update `inventory/group_vars/all.yml` with the provided `domain_name` value.

## Deployment Guidelines
1. Bootstrap and provision servers:
   - `just run bootstrap,provision`
   - Wait for the command to finish before continuing.
   - Proceed only if it completes with no errors (`failed=0` and `unreachable=0` in play recap, and zero exit status).
2. Check whether `.env` exists in the project root.
3. If `.env` does not exist, generate secrets:
   - Run `just run gen-secrets asgard`.
   - Analyze command output and create `.env` using these mappings:
     - `item=generate reality-keypair` -> `REALITY_PRIVATE_KEY` and `REALITY_PUBLIC_KEY`
     - `item=generate rand 8 --hex` -> `REALITY_SHORT_ID`
     - `item=generate uuid` -> `VLESS_UUID`
4. When `.env` is present (created or pre-existing), check `WG_ADMIN_PASSWORD` in `.env`:
   - If it is missing, generate it with `openssl rand -base64 8`.
   - Add it to `.env` as `WG_ADMIN_PASSWORD=<generated_value>`.
5. Deploy the stack:
   - `just run setup-bifrost`
