#!/bin/bash

# Zero Email - Quick Start Script
# This script helps you get Zero up and running quickly

set -e

echo "🚀 Zero Email - Simplified Edition"
echo "=================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker is installed"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: You need to configure your .env file!"
    echo ""
    echo "Required steps:"
    echo "1. Generate BETTER_AUTH_SECRET:"
    echo "   openssl rand -hex 32"
    echo ""
    echo "2. Add Google OAuth credentials:"
    echo "   - Go to: https://console.cloud.google.com/"
    echo "   - Create OAuth 2.0 credentials"
    echo "   - Add to .env: GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET"
    echo ""
    echo "3. (Optional) Add Microsoft OAuth for Outlook"
    echo ""
    read -p "Press Enter to edit .env now, or Ctrl+C to exit and edit manually..."
    ${EDITOR:-nano} .env
fi

echo "🐳 Starting Docker containers..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if backend is healthy
echo "🔍 Checking backend health..."
max_retries=30
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if curl -f http://localhost:8787/health &> /dev/null; then
        echo "✅ Backend is healthy!"
        break
    fi
    retry_count=$((retry_count + 1))
    echo "   Waiting for backend... ($retry_count/$max_retries)"
    sleep 2
done

if [ $retry_count -eq $max_retries ]; then
    echo "❌ Backend failed to start"
    echo "Check logs with: docker-compose logs backend"
    exit 1
fi

# Initialize database
echo ""
echo "📊 Initializing database..."
docker-compose exec -T backend pnpm db:push || {
    echo "⚠️  Database initialization failed, but continuing..."
    echo "You may need to run: docker-compose exec backend pnpm db:push"
}

echo ""
echo "=================================="
echo "✅ Zero Email is running!"
echo "=================================="
echo ""
echo "🌐 Frontend: http://localhost:3000"
echo "🔌 Backend:  http://localhost:8787"
echo ""
echo "📝 Useful commands:"
echo "   View logs:        docker-compose logs -f"
echo "   Stop services:    docker-compose down"
echo "   Restart:          docker-compose restart"
echo "   Database studio:  docker-compose exec backend pnpm db:studio"
echo ""
echo "📖 Read DEPLOYMENT.md for more information"
echo ""
echo "🎉 Happy emailing!"

