#!/bin/bash

# Zero Email - Hetzner Deployment Script
# This script will deploy the Zero email application on your Hetzner server

set -e  # Exit on error

echo "🚀 Zero Email - Hetzner Deployment"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Step 1: Installing dependencies...${NC}"

# Update system
apt-get update -qq

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
else
    echo "✅ Docker already installed"
fi

# Install Docker Compose plugin if not installed
if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose..."
    apt-get install -y docker-compose-plugin
else
    echo "✅ Docker Compose already installed"
fi

# Install Caddy if not installed
if ! command -v caddy &> /dev/null; then
    echo "Installing Caddy..."
    apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt-get update -qq
    apt-get install -y caddy
else
    echo "✅ Caddy already installed"
fi

echo ""
echo -e "${YELLOW}📥 Step 2: Cloning repository...${NC}"

# Clone or update repository
if [ -d "/opt/zero-email" ]; then
    echo "Repository exists, pulling latest changes..."
    cd /opt/zero-email
    git pull
else
    echo "Cloning repository..."
    git clone https://github.com/Ct1869/zero-email-simplified.git /opt/zero-email
    cd /opt/zero-email
fi

echo ""
echo -e "${YELLOW}⚙️  Step 3: Setting up environment...${NC}"

# Copy production env if .env doesn't exist
if [ ! -f ".env" ]; then
    cp .env.production .env
    echo -e "${YELLOW}⚠️  Created .env file from template${NC}"
    echo -e "${YELLOW}⚠️  Please edit /opt/zero-email/.env and update:${NC}"
    echo "   - BETTER_AUTH_SECRET (run: openssl rand -hex 32)"
    echo "   - GOOGLE_CLIENT_ID"
    echo "   - GOOGLE_CLIENT_SECRET"
    echo ""
    read -p "Press Enter after you've updated the .env file..."
else
    echo "✅ .env file already exists"
fi

echo ""
echo -e "${YELLOW}🔧 Step 4: Setting up Caddy...${NC}"

# Copy Caddyfile
cp Caddyfile /etc/caddy/Caddyfile

# Create log directory
mkdir -p /var/log/caddy
chown caddy:caddy /var/log/caddy

# Reload Caddy
systemctl reload caddy
echo "✅ Caddy configured and reloaded"

echo ""
echo -e "${YELLOW}🐳 Step 5: Starting Docker containers...${NC}"

# Stop existing containers if any
docker compose -f docker-compose.production.yml down 2>/dev/null || true

# Start containers
docker compose -f docker-compose.production.yml up -d

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose.production.yml ps

echo ""
echo -e "${GREEN}🎉 Your Zero Email application is now running!${NC}"
echo ""
echo "Frontend: https://mail.jmcworld.xyz"
echo "Backend:  https://api.jmcworld.xyz"
echo ""
echo "📝 Next steps:"
echo "1. Make sure your DNS records are pointing to this server (91.99.141.143)"
echo "2. Update Google OAuth redirect URI to: https://api.jmcworld.xyz/api/auth/callback/google"
echo "3. Wait 2-3 minutes for SSL certificates to be issued"
echo "4. Visit https://mail.jmcworld.xyz and sign in!"
echo ""
echo "📋 Useful commands:"
echo "  View logs:    docker compose -f /opt/zero-email/docker-compose.production.yml logs -f"
echo "  Restart:      docker compose -f /opt/zero-email/docker-compose.production.yml restart"
echo "  Stop:         docker compose -f /opt/zero-email/docker-compose.production.yml down"
echo "  Update:       cd /opt/zero-email && git pull && docker compose -f docker-compose.production.yml up -d"
echo ""

