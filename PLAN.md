# Quake 3 Browser Deployment - Plan

## Done

- [x] Project setup (docker-compose.yml, Caddyfile, server.cfg, setup-oracle.sh, README.md)

## To Do

### Oracle Cloud Setup
- [ ] Create Oracle Cloud free tier account at cloud.oracle.com
- [ ] Select **São Paulo** (`sa-saopaulo-1`) as home region during signup
- [ ] Create an Ampere A1 Flex instance (1 OCPU, 6GB RAM, Ubuntu 22.04 aarch64)
- [ ] Download the SSH private key during instance creation
- [ ] Note the public IP once the instance is running

### Firewall / Networking (OCI Console)
- [ ] Go to Networking > Virtual Cloud Networks > your VCN > Security Lists > Default
- [ ] Add ingress rule: TCP port 80 from 0.0.0.0/0
- [ ] Add ingress rule: TCP port 443 from 0.0.0.0/0
- [ ] Add ingress rule: TCP port 27960 from 0.0.0.0/0

### Domain (optional but recommended for HTTPS)
- [ ] Get a free domain (e.g., from freenom, duckdns.org, or use one you own)
- [ ] Point DNS A record to the Oracle instance public IP
- [ ] Update `Caddyfile` — replace `YOUR_DOMAIN` with your domain
- [ ] If skipping domain: replace Caddyfile content with `:80 { reverse_proxy quakejs:80 }`

### Deploy
- [ ] Push this repo to GitHub
- [ ] SSH into the Oracle instance: `ssh -i your-key.pem ubuntu@<IP>`
- [ ] Clone the repo: `git clone https://github.com/YOUR_USER/quake3.git`
- [ ] Run setup: `bash setup-oracle.sh`
- [ ] Log out and back in (for docker group permissions)
- [ ] `cd quake3 && docker compose up -d`
- [ ] Verify it's running: `docker compose logs -f`

### Test
- [ ] Open the URL in your browser and check the game loads
- [ ] Connect to the server from the in-game menu
- [ ] Have a friend connect to confirm multiplayer works
- [ ] Check ping is acceptable (~10-30ms from Argentina)

### Optional Tweaks
- [ ] Edit `server.cfg` to change game mode (TDM, CTF, etc.)
- [ ] Adjust `sv_maxclients` based on how many friends will play
- [ ] Add custom maps (requires repacking assets into the container)
