# Bifrost Manual Deployment

This repository deploys the Bifrost stack with Ansible.

## 1. Set required inventory values

Before deployment, update these files:

- `inventory/group_vars/all.yml`
  - Set `domain_name` (required for sing-box handshake validation; it can be a non-real domain).
- `inventory/hosts.yml`
  - Set `ansible_host` for both hosts:
    - `asgard` (server)
    - `midgard` (client)

## 2. Generate secrets

Run:

```bash
just run gen-secrets asgard
```

Take values from command output and create `.env` in project root with:

- From `item=generate reality-keypair`:
  - `REALITY_PRIVATE_KEY=<PrivateKey>`
  - `REALITY_PUBLIC_KEY=<PublicKey>`
- From `item=generate rand 8 --hex`:
  - `REALITY_SHORT_ID=<value>`
- From `item=generate uuid`:
  - `VLESS_UUID=<value>`

Example `.env`:

```env
REALITY_PRIVATE_KEY=...
REALITY_PUBLIC_KEY=...
REALITY_SHORT_ID=...
VLESS_UUID=...
```

## 3. Add WG admin password

Ensure `.env` contains:

```env
WG_ADMIN_PASSWORD=<value>
```

If missing, generate it:

```bash
openssl rand -base64 8
```

Then append it to `.env` as `WG_ADMIN_PASSWORD=<generated_value>`.

## 4. Deploy stack

Run:

```bash
just run setup-bifrost
```

## 5. Essential post-deployment steps (required)

These steps are mandatory for the tunnel to work. If hooks are not replaced, traffic will not be routed through the tunnel.

- Open WireGuard admin panel:
  - `http://<midgard ip>:51821`
- Log in with:
  - Username: `admin`
  - Password: `<WG_ADMIN_PASSWORD>` from `.env`
- Navigate to:
  - `Administrator -> Admin Panel -> Hooks`
- Replace hooks:
  - `PostUp`: `/etc/wireguard/hooks.sh up`
  - `PostDown`: `/etc/wireguard/hooks.sh down`

## 6. Security hardening (recommended)

The WireGuard admin panel is world-accessible over plain HTTP by default. For better security, place it behind a reverse proxy with a real TLS certificate and, ideally, enforce mTLS for user authentication.
