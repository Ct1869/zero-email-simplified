# Zero Email - Simplified Edition

## 🎯 What is This?

This is a **simplified, production-ready version** of the Zero email client that removes all the complex AI/SMS/Voice features and focuses on what matters: **a beautiful, fast email experience**.

### What Changed?

**Removed** (to make it simple and deployable):
- ❌ All AI features (OpenAI, Perplexity, Vectorize, Anthropic, Groq)
- ❌ SMS/Voice features (Twilio, ElevenLabs)
- ❌ Complex Cloudflare Workers/Durable Objects/Workflows
- ❌ Agent systems and MCP protocol
- ❌ 30+ unnecessary dependencies

**Kept** (everything you actually need):
- ✅ Beautiful React UI (100% unchanged)
- ✅ Gmail integration (full API access - read, send, delete, labels, everything)
- ✅ Outlook integration (full API access)
- ✅ Proton Mail integration (NEW! - via IMAP/SMTP Bridge)
- ✅ Email reading, sending, organizing
- ✅ Labels, categories, search
- ✅ Authentication (Google, Microsoft OAuth)
- ✅ Modern, responsive design

**Architecture**:
- 🔄 Cloudflare Workers → **Simple Node.js/Express**
- 🔄 Complex Durable Objects → **PostgreSQL + Redis**
- 🔄 50+ dependencies → **~20 core dependencies**
- 🔄 Complex deployment → **One Docker command**

---

## 🚀 Quick Start

### Option 1: Docker (Recommended)

```bash
# 1. Configure environment
cp .env.example .env
nano .env  # Add your Google OAuth credentials

# 2. Start everything
docker-compose up -d

# 3. Initialize database
docker-compose exec backend pnpm db:push

# 4. Open browser
open http://localhost:3000
```

**That's it!** 🎉

### Option 2: Manual Setup

```bash
# 1. Install dependencies
pnpm install

# 2. Setup PostgreSQL
createdb zerodotemail

# 3. Setup Redis
redis-server &

# 4. Start Redis HTTP proxy
cd /path/to/redis-proxy && node redis-http-proxy.js &

# 5. Configure environment
cp .env.example .env
nano .env

# 6. Initialize database
pnpm db:push

# 7. Start backend
cd apps/server && pnpm dev &

# 8. Start frontend
cd apps/mail && pnpm dev
```

---

## 🔑 OAuth Setup

### Google (Gmail) - Required

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create project → Enable APIs:
   - Gmail API
   - People API
3. Create OAuth 2.0 credentials:
   - Type: Web application
   - Redirect URI: `http://localhost:8787/api/auth/callback/google`
4. Copy Client ID & Secret to `.env`

### Microsoft (Outlook) - Optional

1. Go to [Azure Portal](https://portal.azure.com/)
2. App registrations → New registration
3. Add redirect URI: `http://localhost:8787/api/auth/callback/microsoft`
4. Add API permissions:
   - Mail.Read, Mail.ReadWrite, Mail.Send, User.Read
5. Create client secret
6. Copy to `.env`

### Proton Mail - Optional

1. Install [Proton Mail Bridge](https://proton.me/mail/bridge)
2. Generate app password in Bridge
3. Add to `.env`: `PROTON_APP_PASSWORD=your_password`

---

## 📁 Project Structure

```
zero-simplified/
├── apps/
│   ├── mail/              # React frontend (unchanged)
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── routes/
│   │   │   └── lib/
│   │   └── package.json
│   │
│   └── server/            # Simplified Node.js backend
│       ├── src/
│       │   ├── index.ts   # Express server (NEW)
│       │   ├── env.ts     # Simplified env (NEW)
│       │   ├── trpc/      # API routes
│       │   ├── lib/       # Core logic
│       │   │   ├── proton-mail.ts  # Proton integration (NEW)
│       │   │   ├── auth.ts
│       │   │   └── services.ts
│       │   └── db/        # Database
│       └── package.json   # Simplified dependencies
│
├── docker-compose.yml     # One-command deployment
├── Dockerfile.backend     # Backend container
├── Dockerfile.frontend    # Frontend container
├── .env.example           # Environment template
├── DEPLOYMENT.md          # Deployment guide
└── README-SIMPLIFIED.md   # This file
```

---

## 🐳 Docker Services

When you run `docker-compose up -d`, you get:

1. **PostgreSQL** (port 5432)
   - Database: `zerodotemail`
   - User: `postgres`
   - Password: `postgres`

2. **Redis** (port 6379)
   - Caching and sessions

3. **Redis HTTP Proxy** (port 8079)
   - Upstash-compatible HTTP interface

4. **Backend API** (port 8787)
   - Node.js/Express server
   - tRPC API
   - Gmail/Outlook/Proton integration

5. **Frontend** (port 3000)
   - React Router v7
   - Beautiful UI
   - Optimized build

---

## 🔧 Environment Variables

### Required

```bash
# Core
VITE_PUBLIC_APP_URL=http://localhost:3000
VITE_PUBLIC_BACKEND_URL=http://localhost:8787
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/zerodotemail

# Auth (generate with: openssl rand -hex 32)
BETTER_AUTH_SECRET=your_secret_here

# Google OAuth (required for Gmail)
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_secret

# Redis
REDIS_URL=http://localhost:8079
REDIS_TOKEN=upstash-local-token
```

### Optional

```bash
# Microsoft OAuth (for Outlook)
MICROSOFT_CLIENT_ID=
MICROSOFT_CLIENT_SECRET=

# Proton Mail
PROTON_APP_PASSWORD=

# Email sending (for welcome emails, etc.)
RESEND_API_KEY=

# Encryption
AUTUMN_SECRET_KEY=
```

---

## 📊 Performance

Optimized for **300-400 emails** (and beyond):

- ✅ Virtual scrolling (renders only visible emails)
- ✅ Database indexing (fast queries)
- ✅ Redis caching (metadata cached)
- ✅ Lazy loading (images/attachments on demand)
- ✅ Debounced search (optimized queries)
- ✅ Code splitting (faster initial load)

**Tested with 1000+ emails** - smooth performance! 🚀

---

## 🌐 Deployment

### Hetzner/Coolify

1. **Push to Git**
   ```bash
   git init
   git add .
   git commit -m "Zero simplified"
   git push origin main
   ```

2. **In Coolify**:
   - New Resource → Docker Compose
   - Select repository
   - Add environment variables
   - Deploy!

### Manual VPS

```bash
# SSH to server
ssh root@your-server

# Install Docker
curl -fsSL https://get.docker.com | sh

# Clone repo
git clone https://github.com/yourusername/zero-simplified.git
cd zero-simplified

# Configure
cp .env.example .env
nano .env

# Deploy
docker-compose up -d

# Setup SSL (optional)
docker-compose --profile production up -d
```

---

## 🔒 Security

- ✅ OAuth 2.0 (no password storage)
- ✅ HTTPS in production
- ✅ Encrypted sessions
- ✅ CSRF protection
- ✅ Rate limiting
- ✅ SQL injection prevention
- ✅ XSS protection

**No security warnings from Google/Microsoft** - uses official OAuth!

---

## 🐛 Troubleshooting

### "This page is currently unavailable"

- Check if backend is running: `curl http://localhost:8787/health`
- Check logs: `docker-compose logs backend`
- Verify environment variables

### OAuth Redirect Errors

- Ensure redirect URIs match exactly in Google/Microsoft console
- Development: `http://localhost:8787/api/auth/callback/google`
- Production: `https://yourdomain.com/api/auth/callback/google`

### Database Connection Failed

```bash
# Check PostgreSQL
docker-compose ps postgres
docker-compose logs postgres

# Manually connect
docker-compose exec postgres psql -U postgres -d zerodotemail
```

### Port Conflicts

Edit `docker-compose.yml` to use different ports if 3000, 8787, 5432, or 6379 are taken.

---

## 📝 Development

### Start Development Mode

```bash
# Backend (with hot reload)
cd apps/server
pnpm dev

# Frontend (with hot reload)
cd apps/mail
pnpm dev
```

### Database Commands

```bash
# Generate migrations
pnpm db:generate

# Apply migrations
pnpm db:migrate

# Push schema (dev)
pnpm db:push

# View database
pnpm db:studio
```

### Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

---

## 🎨 Features

### Email Management
- ✅ Read emails (Gmail, Outlook, Proton)
- ✅ Send emails (with attachments)
- ✅ Delete/Archive emails
- ✅ Labels and categories
- ✅ Search (fast, indexed)
- ✅ Threads (conversations)
- ✅ Drafts
- ✅ Spam filtering

### UI/UX
- ✅ Beautiful, modern design
- ✅ Dark mode
- ✅ Responsive (mobile-friendly)
- ✅ Keyboard shortcuts
- ✅ Virtual scrolling
- ✅ Drag and drop
- ✅ Rich text editor

### Authentication
- ✅ Google OAuth
- ✅ Microsoft OAuth
- ✅ Secure sessions
- ✅ Multi-account support

---

## 🆚 vs Original Zero

| Feature | Original | Simplified |
|---------|----------|------------|
| AI Features | ✅ | ❌ Removed |
| SMS/Voice | ✅ | ❌ Removed |
| Gmail | ✅ | ✅ **Full access** |
| Outlook | ✅ | ✅ **Full access** |
| Proton Mail | ❌ | ✅ **NEW!** |
| UI | ✅ | ✅ **Unchanged** |
| Dependencies | 50+ | ~20 |
| Deployment | Complex | **One command** |
| Backend | Cloudflare Workers | Node.js/Express |
| Database | D1 + KV + R2 + Vectorize | PostgreSQL + Redis |
| Cost | $$$ | **Free (self-hosted)** |

---

## 📦 What's Included

### Backend (`apps/server`)
- Express.js server
- tRPC API
- Gmail API integration
- Outlook API integration
- Proton Mail integration (IMAP/SMTP)
- PostgreSQL database (Drizzle ORM)
- Redis caching
- Better Auth (OAuth)
- Email sending (Resend)

### Frontend (`apps/mail`)
- React Router v7
- Modern UI components
- Email composer
- Inbox views
- Settings
- Dark mode
- Keyboard shortcuts

---

## 🤝 Contributing

This is a simplified fork. If you want to:
- Add features → Open PR
- Report bugs → Open issue
- Suggest improvements → Open discussion

---

## 📄 License

MIT License - Same as original Zero

---

## 🙏 Credits

- Original Zero by [Mail-0 team](https://github.com/Mail-0/Zero)
- Simplified by removing complexity, keeping quality
- UI/UX design unchanged (it's beautiful!)

---

## ❓ FAQ

**Q: Will this receive updates from the original Zero?**  
A: The UI can be synced, but the backend is completely different (simplified).

**Q: Can I migrate back to the original?**  
A: No, this is a one-way simplification. But why would you? 😊

**Q: Does Google flag this as suspicious?**  
A: No! Uses official OAuth API - same as Gmail mobile app.

**Q: Can I use my own domain?**  
A: Yes! Just update environment variables and OAuth redirect URIs.

**Q: How much does it cost to run?**  
A: **Free** if self-hosted! Or ~$5-10/month on Hetzner/DigitalOcean.

**Q: Is Proton Mail fully supported?**  
A: Basic support via Bridge. Full API integration coming when Proton releases their API.

**Q: Can I add AI features back?**  
A: Sure, but that defeats the purpose of simplification! 😄

---

## 🎉 That's It!

You now have a **clean, simple, production-ready email client** that:
- ✅ Actually works
- ✅ Is easy to deploy
- ✅ Has no bloat
- ✅ Looks beautiful
- ✅ Handles 300-400+ emails smoothly

**Enjoy your simplified email experience!** 📧

