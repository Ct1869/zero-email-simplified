# Zero Email - Simplified Deployment Guide

## What Changed?

This is a **simplified version** of Zero that removes all the complex AI/SMS/Voice features and focuses on being a clean, reliable email client.

### Removed Features
- ❌ All AI features (OpenAI, Perplexity, Vectorize)
- ❌ SMS/Voice (Twilio, ElevenLabs)
- ❌ Complex Cloudflare Workers/Durable Objects
- ❌ Workflows and agent systems
- ❌ Experimental features

### What's Included
- ✅ Beautiful React UI (unchanged)
- ✅ Gmail integration (full API access)
- ✅ Outlook integration (full API access)
- ✅ Proton Mail integration (NEW!)
- ✅ Email reading/sending/organizing
- ✅ Labels and categories
- ✅ Search functionality
- ✅ Simple Node.js backend
- ✅ PostgreSQL database
- ✅ Redis caching
- ✅ One-command Docker deployment

---

## Quick Start (Docker)

### Prerequisites
- Docker and Docker Compose installed
- Google OAuth credentials (for Gmail)
- Microsoft OAuth credentials (for Outlook - optional)

### 1. Clone and Configure

```bash
# Copy environment file
cp .env.example .env

# Edit .env and add your credentials
nano .env
```

**Required variables:**
```bash
BETTER_AUTH_SECRET=<generate with: openssl rand -hex 32>
GOOGLE_CLIENT_ID=<from Google Cloud Console>
GOOGLE_CLIENT_SECRET=<from Google Cloud Console>
```

### 2. Deploy

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

That's it! The application will be available at:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8787

### 3. Initialize Database

```bash
# Run migrations
docker-compose exec backend pnpm db:push
```

---

## Manual Setup (Without Docker)

### Prerequisites
- Node.js 22+
- PostgreSQL 14+
- Redis 6+
- pnpm 10+

### 1. Install Dependencies

```bash
pnpm install
```

### 2. Setup Database

```bash
# Start PostgreSQL and create database
createdb zerodotemail

# Run migrations
pnpm db:push
```

### 3. Setup Redis

```bash
# Start Redis
redis-server

# In another terminal, start Redis HTTP proxy
cd /path/to/redis-proxy
node redis-http-proxy.js
```

### 4. Configure Environment

```bash
cp .env.example .env
# Edit .env with your credentials
```

### 5. Start Development

```bash
# Start backend
cd apps/server
pnpm dev

# In another terminal, start frontend
cd apps/mail
pnpm dev
```

---

## OAuth Setup

### Google OAuth (Gmail)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable APIs:
   - Gmail API
   - People API
4. Create OAuth 2.0 credentials:
   - Application type: Web application
   - Authorized redirect URIs:
     - `http://localhost:8787/api/auth/callback/google` (development)
     - `https://yourdomain.com/api/auth/callback/google` (production)
5. Copy Client ID and Client Secret to `.env`

### Microsoft OAuth (Outlook)

1. Go to [Azure Portal](https://portal.azure.com/)
2. Navigate to "App registrations"
3. Create new registration:
   - Name: Zero Email
   - Supported account types: Personal Microsoft accounts
   - Redirect URI: `http://localhost:8787/api/auth/callback/microsoft`
4. Create client secret in "Certificates & secrets"
5. Add API permissions:
   - Microsoft Graph > Delegated permissions
   - Mail.Read, Mail.ReadWrite, Mail.Send, User.Read
6. Copy Application (client) ID and secret to `.env`

### Proton Mail

1. Log in to Proton Mail
2. Go to Settings > Security
3. Generate an app-specific password
4. Add to `.env` as `PROTON_APP_PASSWORD`

---

## Deployment to Hetzner/Coolify

### Using Coolify

1. **Create New Resource**
   - Type: Docker Compose
   - Repository: Your Git repository
   - Branch: main

2. **Environment Variables**
   - Add all variables from `.env.example`
   - Set production URLs

3. **Deploy**
   - Coolify will automatically build and deploy
   - SSL certificates are handled automatically

### Manual Hetzner Deployment

```bash
# SSH into your Hetzner server
ssh root@your-server-ip

# Install Docker
curl -fsSL https://get.docker.com | sh

# Clone repository
git clone https://github.com/yourusername/zero-simplified.git
cd zero-simplified

# Configure environment
cp .env.example .env
nano .env  # Add production credentials

# Start services
docker-compose up -d

# Setup Nginx reverse proxy (optional)
docker-compose --profile production up -d
```

---

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `VITE_PUBLIC_APP_URL` | Yes | Frontend URL (e.g., https://mail.yourdomain.com) |
| `VITE_PUBLIC_BACKEND_URL` | Yes | Backend API URL (e.g., https://api.yourdomain.com) |
| `DATABASE_URL` | Yes | PostgreSQL connection string |
| `BETTER_AUTH_SECRET` | Yes | Random 32-char string for auth |
| `GOOGLE_CLIENT_ID` | Yes | Google OAuth client ID |
| `GOOGLE_CLIENT_SECRET` | Yes | Google OAuth secret |
| `MICROSOFT_CLIENT_ID` | No | Microsoft OAuth client ID |
| `MICROSOFT_CLIENT_SECRET` | No | Microsoft OAuth secret |
| `PROTON_APP_PASSWORD` | No | Proton Mail app password |
| `REDIS_URL` | Yes | Redis connection URL |
| `REDIS_TOKEN` | Yes | Redis auth token |
| `RESEND_API_KEY` | No | For sending transactional emails |
| `AUTUMN_SECRET_KEY` | No | For additional encryption |

---

## Troubleshooting

### Database Connection Issues

```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# View PostgreSQL logs
docker-compose logs postgres

# Manually connect to database
docker-compose exec postgres psql -U postgres -d zerodotemail
```

### Redis Connection Issues

```bash
# Check if Redis is running
docker-compose ps redis

# Test Redis connection
docker-compose exec redis redis-cli ping
```

### OAuth Redirect Issues

Make sure your OAuth redirect URIs match exactly:
- Development: `http://localhost:8787/api/auth/callback/google`
- Production: `https://yourdomain.com/api/auth/callback/google`

### Port Conflicts

If ports 3000, 8787, 5432, or 6379 are already in use, edit `docker-compose.yml` to use different ports.

---

## Performance Optimization

### For 300-400 Emails

The application is optimized for handling hundreds of emails efficiently:

1. **Virtual Scrolling**: Only renders visible emails
2. **Database Indexing**: Proper indexes on email tables
3. **Redis Caching**: Frequently accessed data is cached
4. **Lazy Loading**: Images and attachments load on demand
5. **Debounced Search**: Search queries are optimized

### Scaling Beyond

For thousands of emails:
- Enable PostgreSQL connection pooling
- Increase Redis memory allocation
- Use CDN for static assets
- Consider horizontal scaling with load balancer

---

## Security Best Practices

1. **Always use HTTPS in production**
2. **Rotate `BETTER_AUTH_SECRET` regularly**
3. **Keep OAuth secrets secure**
4. **Enable database backups**
5. **Use strong PostgreSQL passwords**
6. **Limit Redis access to localhost**
7. **Keep dependencies updated**

---

## Backup and Restore

### Backup Database

```bash
docker-compose exec postgres pg_dump -U postgres zerodotemail > backup.sql
```

### Restore Database

```bash
docker-compose exec -T postgres psql -U postgres zerodotemail < backup.sql
```

---

## Monitoring

### Health Checks

```bash
# Backend health
curl http://localhost:8787/health

# Check all services
docker-compose ps
```

### Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
```

---

## Support

For issues or questions:
- Check logs: `docker-compose logs`
- Verify environment variables
- Ensure OAuth credentials are correct
- Check database connectivity

---

## What's Next?

This simplified version focuses on core email functionality. Future improvements could include:
- Email templates
- Advanced filtering
- Bulk operations
- Email scheduling
- Custom themes
- Mobile app

But for now, it's clean, simple, and actually works! 🎉

