# Quick Start - Environment Setup

This file provides a quick template for setting up your environment variables for local development or production deployment.

## 1. Copy the template
```bash
cp .env.example .env
```

## 2. Edit `.env` with your values

For **Local Development** (XAMPP):
```env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=station_azeu
DB_USER=root
DB_PASS=
DB_SSL_ENABLED=false
ENCRYPTION_KEY=azeu_water_station_2025_key
DEBUG_MODE=true
```

For **Production** (TiDBCloud + Render.com):
```env
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=waterstation_db
DB_USER=3xxxxxx.root
DB_PASS=your_tidb_password_here
DB_SSL_ENABLED=true
ENCRYPTION_KEY=generate_random_32_char_string
DEBUG_MODE=false
```

## 3. Generate strong encryption key

**Linux/Mac:**
```bash
openssl rand -base64 32
```

**PowerShell (Windows):**
```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
```

## 4. Update other settings as needed

See `.env.example` for all available configuration options.

---

**Important:** Never commit `.env` file to version control!
