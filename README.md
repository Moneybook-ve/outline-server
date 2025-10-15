# Outline Server

A production-ready deployment of Outline wiki using Docker Compose with PostgreSQL, Redis, and Caddy for HTTPS.

## 🚀 Production URL

**<https://outline.milagros.me/>**

## 📋 Features

- **Email-based authentication** with magic links (SendGrid)
- **Automatic HTTPS** with SSL certificates (Caddy)
- **PostgreSQL database** with persistent storage
- **Redis caching** for performance
- **File storage** with configurable limits
- **Rate limiting** for security
- **GitHub Actions deployment** to Hetzner server

## 🛠 Prerequisites

- Docker and Docker Compose
- GitHub repository with Actions enabled
- Hetzner server (or similar hosting)
- SendGrid account for email delivery

## 🔧 Local Development

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Moneybook-ve/outline-server.git
   cd outline-server
   ```

2. **Configure environment:**
   - Copy `.env` and update values as needed
   - For local development, keep `FORCE_HTTPS=false`

3. **Start services:**

   ```bash
   docker compose up -d --build
   ```

4. **Access Outline:**
   - Open <http://localhost:3000>
   - Create your first account via email magic link

## 🚀 Production Deployment

### Initial Setup

1. **Upload secrets to GitHub:**

   ```bash
   .\upload-outline-secrets.ps1
   ```

2. **Commit and push configuration:**

   ```bash
   git add .
   git commit -m "Add Outline deployment configuration"
   git push origin main
   ```

### Automated Deployment

The deployment is handled automatically via GitHub Actions:

1. Go to **Actions** tab in your GitHub repository
2. Select **"Deploy Outline to Hetzner (Production)"** workflow
3. Click **"Run workflow"** to trigger deployment

The workflow will:

- Create `.env` file from GitHub secrets
- Copy files to your Hetzner server via rsync
- Run `docker compose pull && docker compose up -d --build`

### Manual Deployment (if needed)

If you need to deploy manually:

```bash
# On your Hetzner server
cd /path/to/outline-server
docker compose pull
docker compose up -d --build
```

**Note:** This preserves existing volumes and data. No database migrations are needed as Outline handles them automatically.

## ⚙️ Configuration

### Environment Variables

Key configuration in `.env`:

```bash
# Application
URL=https://outline.milagros.me/
SECRET_KEY=your-secret-key
UTILS_SECRET=your-utils-secret

# Database
POSTGRES_USER=outline_user
POSTGRES_PASSWORD=secure-password
POSTGRES_DB=outline
DATABASE_URL=postgres://outline_user:password@postgres:5432/outline?sslmode=disable

# Redis
REDIS_URL=redis://redis:6379

# Email (SendGrid)
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your-sendgrid-api-key
SMTP_FROM_EMAIL=admin@milagros.me
SMTP_SECURE=false

# HTTPS
FORCE_HTTPS=true
```

### File Structure

```text
outline-server/
├── docker-compose.yml    # Service definitions
├── Caddyfile            # Reverse proxy configuration
├── redis.conf           # Redis configuration
├── .env                 # Environment variables (gitignored)
├── .github/
│   └── workflows/
│       └── deploy-production.yml  # GitHub Actions deployment
└── upload-outline-secrets.ps1     # Secret upload script
```

## 🔍 Troubleshooting

### Common Issues

**Email not sending:**

- Verify SendGrid API key and SMTP settings
- Check `SMTP_SECURE=false` for STARTTLS

**Database connection failed:**

- Ensure PostgreSQL container is healthy
- Check `DATABASE_URL` format

**HTTPS not working:**

- Verify domain DNS points to server
- Check Caddy logs: `docker compose logs caddy`

### Logs

View service logs:

```bash
# All services
docker compose logs

# Specific service
docker compose logs outline
docker compose logs postgres
docker compose logs redis
docker compose logs caddy
```

### Database

Access PostgreSQL directly:

```bash
docker compose exec postgres psql -U outline_user -d outline
```

## 🔒 Security Notes

- All secrets are stored in GitHub repository environment
- Database passwords are auto-generated
- SSL certificates are managed automatically by Caddy
- Rate limiting is enabled by default

## 📝 Notes

- First user to sign up becomes the admin
- Data persists in Docker volumes
- Automatic updates are enabled in production
- Email magic links are used instead of OAuth for simplicity
