# Quake 3 Arena - Browser Edition

Play Quake 3 in the browser with friends. Optimized for deployment on Oracle Cloud free tier in São Paulo for low-latency play from Argentina.

## Architecture

```
Browser (QuakeJS WASM client)
    ↕ WSS (WebSocket Secure via Caddy)
Caddy reverse proxy (auto HTTPS)
    ↕ HTTP + WS
QuakeJS container (web client + game server)
```

## Quick Start

### 1. Create an Oracle Cloud free tier instance

- Sign up at [cloud.oracle.com](https://cloud.oracle.com)
- Create an **Ampere A1** (ARM) instance in **São Paulo** region
- Shape: VM.Standard.A1.Flex, 1 OCPU, 6GB RAM (free tier)
- OS: Ubuntu 22.04 or 24.04 (aarch64)
- Download your SSH key during creation

### 2. Open firewall ports in OCI Console

Go to **Networking > Virtual Cloud Networks > your VCN > Security Lists > Default Security List** and add these ingress rules:

| Port | Protocol | Source |
|------|----------|--------|
| 80 | TCP | 0.0.0.0/0 |
| 443 | TCP | 0.0.0.0/0 |
| 27960 | TCP | 0.0.0.0/0 |

### 3. SSH into the instance and run setup

```bash
ssh -i your-key.pem ubuntu@<instance-public-ip>

# Download and run the setup script
git clone https://github.com/YOUR_USER/quake3.git
cd quake3
bash setup-oracle.sh

# Log out and back in (for docker group)
exit
ssh -i your-key.pem ubuntu@<instance-public-ip>
```

### 4. Configure and launch

```bash
cd quake3

# Option A: If you have a domain, point it to your instance IP, then:
sed -i 's/YOUR_DOMAIN/quake.yourdomain.com/' Caddyfile

# Option B: No domain, just use the IP (HTTP only):
echo ':80 { reverse_proxy quakejs:80 }' > Caddyfile

# Launch
docker compose up -d
```

### 5. Play

Share the URL with your friends. They just open it in a browser — no install needed.

## Server Configuration

Edit `server.cfg` to customize:

- `sv_hostname` — server name
- `sv_maxclients` — max players (default 12)
- `g_gametype` — 0=FFA, 1=Tournament, 3=TDM, 4=CTF
- `fraglimit` / `timelimit` — match rules
- Map rotation — edit the `set d1/d2/d3` lines

Available maps (free demo): **q3dm1**, **q3dm7**, **q3dm17**, **q3tourney2**

After editing, restart: `docker compose restart quakejs`

## Troubleshooting

- **Container crashes on start**: Check logs with `docker compose logs quakejs`
- **Can't connect from browser**: Make sure both OCI security list AND iptables have the ports open
- **HTTPS not working**: Make sure your domain's DNS A record points to the instance IP. Caddy handles certificates automatically
- **High latency**: Verify your instance is in the São Paulo region (`sa-saopaulo-1`)
