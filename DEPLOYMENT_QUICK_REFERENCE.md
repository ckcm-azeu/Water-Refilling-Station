# 📚 DEPLOYMENT FILES QUICK REFERENCE

**Project:** Azeu Water Station  
**Deployment Target:** Render.com + TiDBCloud  
**Date Created:** March 22, 2026

---

## 📁 FILES CREATED FOR DEPLOYMENT

### 1. **Dockerfile** (Updated)
**Purpose:** Docker container configuration for Render.com  
**Location:** `/Dockerfile`  
**Key Features:**
- PHP 8.1 with Apache
- MySQL PDO support
- TiDBCloud SSL/TLS ready
- Render.com PORT environment variable support
- Production-optimized configuration
- Health checks enabled
- Log rotation configured

**Use:** Docker automatically reads this for deployment

---

### 2. **.env** (Updated)
**Purpose:** Environment variables with TiDBCloud credentials  
**Location:** `/.env`  
**Contents:**
```
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=waterstation_db
DB_USER=zJGjwkovwuzEN37.root
DB_PASS=RuIpyygssjzXjB4D
DB_SSL_ENABLED=true
ENCRYPTION_KEY=[generate new one]
APP_ENV=production
APP_DEBUG=false
TIMEZONE=Asia/Manila
```

**Important:**
- ⚠️ Never commit this to Git
- Already in `.gitignore`
- Keep credentials safe

---

### 3. **.gitignore** (Updated)
**Purpose:** Exclude sensitive files from Git  
**Location:** `/.gitignore`  
**Excludes:**
- `.env` files (credentials safe)
- `logs/` directory
- `assets/uploads/` (user uploads)
- `vendor/` (dependencies)
- IDE files
- OS files
- `ignore/` folder (notes, prompts)

**Use:** Automatically applied when you push to GitHub

---

### 4. **database_setup_tidbcloud.sql** (New)
**Purpose:** Complete database initialization for TiDBCloud  
**Location:** `/database_setup_tidbcloud.sql`  
**Creates:**
- ✅ Database `waterstation_db`
- ✅ All 13 tables with proper structure:
  ```
  1. users
  2. user_preferences
  3. customer_addresses
  4. inventory
  5. orders
  6. order_items
  7. notifications
  8. session_logs
  9. settings
  10. default_items
  11. cancellation_appeals
  12. password_resets
  13. delivery_priority
  ```
- ✅ System settings (16 records)
- ✅ Default item names (10 records)
- ✅ Super admin account (admin/admin)
- ✅ Verification queries

**Use:**
1. Open TiDBCloud SQL Editor
2. Copy entire SQL script
3. Paste into editor
4. Click Execute
5. Done!

---

### 5. **DEPLOYMENT_TIDBCLOUD_RENDER.md** (New)
**Purpose:** Step-by-step deployment guide  
**Location:** `/DEPLOYMENT_TIDBCLOUD_RENDER.md`  
**Sections:**
1. Pre-deployment checklist
2. TiDBCloud setup (complete)
3. Render.com deployment (complete)
4. Environment configuration
5. Database initialization
6. Post-deployment verification
7. Troubleshooting (10+ scenarios)
8. FAQ (10 questions answered)
9. Summary checklist

**Use:** Follow this guide for complete deployment

---

### 6. **DEPLOYMENT_ANSWERS.md** (New)
**Purpose:** Direct answers to your specific questions  
**Location:** `/DEPLOYMENT_ANSWERS.md`  
**Answers:**
1. ❌ first_setup.php will NOT work with TiDBCloud
2. ✅ How to create database manually
3. ✅ SQL script provided (database_setup_tidbcloud.sql)
4. ✅ How to prevent SSL error (DB_SSL_ENABLED=true)
5. ✅ All necessary files provided

**Use:** Reference for specific questions

---

## 🎯 DEPLOYMENT ORDER

### Step 1: TiDBCloud Setup (5 minutes)
```
1. Create cluster (Serverless, Singapore)
2. Open SQL Editor
3. Run: CREATE DATABASE waterstation_db CHARACTER SET utf8mb4;
4. Run: database_setup_tidbcloud.sql
5. Verify: 13 tables created
```

### Step 2: Local Git Setup (5 minutes)
```
1. Make sure you're in project directory
2. git add .
3. git commit -m "Azeu Water Station deployment"
4. Create GitHub repo (private)
5. git push to GitHub
```

### Step 3: Render.com Deployment (5 minutes)
```
1. Create Web Service (Docker)
2. Connect GitHub repo
3. Add environment variables (see below)
4. Click Create
5. Wait for deployment (5-10 min)
```

### Step 4: Environment Variables in Render.com
```
Set these in Render.com Dashboard → Environment:

DB_HOST = gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT = 4000
DB_NAME = waterstation_db
DB_USER = zJGjwkovwuzEN37.root
DB_PASS = RuIpyygssjzXjB4D
DB_SSL_ENABLED = true
ENCRYPTION_KEY = [generate with: openssl rand -base64 32]
APP_ENV = production
APP_DEBUG = false
TIMEZONE = Asia/Manila
```

---

## 🔑 CRITICAL CONFIGURATION

### TiDBCloud Connection String
```
mysql://zJGjwkovwuzEN37.root:RuIpyygssjzXjB4D@gateway01.ap-southeast-1.prod.aws.tidbcloud.com:4000/waterstation_db
```

### SSL/TLS Requirement
```
⚠️ CRITICAL: DB_SSL_ENABLED must be true
❌ Without: "Connections using insecure transport are prohibited"
✅ With: Secure connection established
```

### Initial Credentials
```
Username: admin
Password: admin
⚠️ Change immediately after first login!
```

---

## 📊 PROJECT STRUCTURE AFTER DEPLOYMENT

```
azeu-water-station/
├── Dockerfile ............................ Production Docker config
├── .env ................................. Environment variables (keep secret!)
├── .gitignore ........................... Git ignore rules
├── database_setup_tidbcloud.sql ........ SQL initialization
├── DEPLOYMENT_TIDBCLOUD_RENDER.md ..... Step-by-step guide
├── DEPLOYMENT_ANSWERS.md .............. Your questions answered
│
├── config/ ............................. Core configuration
│   ├── constants.php
│   ├── database.php ................... (reads from .env)
│   ├── session.php
│   ├── functions.php
│   ├── AESCrypt.php
│   └── logger.php
│
├── api/ ................................ REST API endpoints (45 files)
├── admin/ .............................. Admin portal
├── staff/ .............................. Staff portal
├── rider/ .............................. Rider portal
├── customer/ ........................... Customer portal
│
├── assets/
│   ├── css/ ........................... Stylesheets
│   ├── js/ ........................... JavaScript
│   ├── images/ ....................... Images
│   └── uploads/ ...................... User uploads
│
└── logs/ ............................... Application logs
```

---

## ✅ VERIFICATION CHECKLIST

### Before Deployment
- [ ] Read DEPLOYMENT_ANSWERS.md
- [ ] Read DEPLOYMENT_TIDBCLOUD_RENDER.md
- [ ] Understand database_setup_tidbcloud.sql
- [ ] Verify .env has correct credentials
- [ ] Verify .gitignore excludes .env

### After TiDBCloud Setup
- [ ] Database waterstation_db created
- [ ] 13 tables exist
- [ ] Admin account seeded
- [ ] System settings seeded

### After GitHub Push
- [ ] Files on GitHub (private repo)
- [ ] .env NOT visible on GitHub
- [ ] README files present
- [ ] SQL script visible

### After Render.com Deployment
- [ ] Web service created
- [ ] Environment variables set
- [ ] Deployment completed (green status)
- [ ] App accessible at https://your-app.onrender.com

### After Testing
- [ ] Login page loads
- [ ] Admin/admin login works
- [ ] Dashboard functions
- [ ] Database connected
- [ ] No errors in logs

---

## 🆘 COMMON ISSUES & SOLUTIONS

| Issue | Cause | Solution |
|-------|-------|----------|
| SSL error on login | DB_SSL_ENABLED not set | Set to `true` in env vars |
| Can't connect to database | DB already doesn't exist | Run SQL script in TiDBCloud |
| "Table doesn't exist" | SQL script wasn't run | Run database_setup_tidbcloud.sql |
| Admin/admin doesn't work | Admin not created | Verify admin record in database |
| Docker build fails | Dockerfile issue | Check Render.com logs |
| 502 Bad Gateway | Application error | Check Render.com Logs tab |

---

## 📞 NEED HELP?

### For Deployment Steps:
→ Read: **DEPLOYMENT_TIDBCLOUD_RENDER.md**

### For Your Specific Questions:
→ Read: **DEPLOYMENT_ANSWERS.md**

### For Database Issues:
→ Use: **database_setup_tidbcloud.sql**

### For Configuration:
→ Edit: **.env** file or Render.com Environment

---

## 🚀 YOU'RE READY!

All files created and configured. You have:

✅ Complete application code (118 files)  
✅ Production Dockerfile  
✅ Environment configuration (.env)  
✅ Git security (.gitignore)  
✅ Database initialization SQL  
✅ Step-by-step deployment guide  
✅ Q&A document for your questions  
✅ Troubleshooting guide  

**Start deploying now!** Good luck! 🎉
