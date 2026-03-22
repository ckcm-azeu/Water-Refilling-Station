# 🚀 AZEU WATER STATION - RENDER.COM + TIDBCLOUD DEPLOYMENT GUIDE
**Version:** 2.0  
**Last Updated:** March 2026  
**Status:** Production Ready

---

## 📋 TABLE OF CONTENTS
1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [TiDBCloud Setup](#tidbcloud-setup)
3. [Render.com Deployment](#rendercom-deployment)
4. [Environment Configuration](#environment-configuration)
5. [Database Initialization](#database-initialization)
6. [Post-Deployment Verification](#post-deployment-verification)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)

---

## ✅ PRE-DEPLOYMENT CHECKLIST

Before you start, ensure you have:

- [ ] TiDBCloud account (free tier: https://tidbcloud.com)
- [ ] Render.com account (free tier: https://render.com)
- [ ] GitHub account with a private repository
- [ ] Git installed locally
- [ ] All files in this directory ready for deployment
- [ ] All deployment files created:
  - [ ] `Dockerfile` (production-ready)
  - [ ] `.env` (with credentials)
  - [ ] `.gitignore` (excluding sensitive files)
  - [ ] `database_setup_tidbcloud.sql` (initialization script)

---

## 🗄️ TIDBCLOUD SETUP (Step-by-Step)

### Step 1: Create TiDBCloud Cluster

1. Go to https://tidbcloud.com and sign in
2. Click **"Create Cluster"**
3. Select **"Serverless Tier"** (free option)
4. Choose region: **`ap-southeast-1`** (Singapore - closest to Philippines)
5. Set cluster name: `waterstation-production`
6. Click **"Create"** and wait 1-2 minutes

### Step 2: Get Connection Details

Once the cluster is created:

1. Click on cluster name
2. Click **"Connect"** button
3. You'll see connection string and parameters:

```
Host: gateway01.ap-southeast-1.prod.aws.tidbcloud.com
Port: 4000
Username: zJGjwkovwuzEN37.root
Password: RuIpyygssjzXjB4D
```

⚠️ **IMPORTANT:** These credentials are already provided in your `.env` file.

### Step 3: Create Database via SQL Editor

1. Click **"SQL Editor"** in TiDBCloud dashboard
2. In the SQL editor, run this command:

```sql
CREATE DATABASE waterstation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. Verify database was created:

```sql
SHOW DATABASES;
```

You should see `waterstation_db` in the list.

### Step 4: Initialize Database with Tables & Data

1. In the TiDBCloud SQL Editor, run the complete SQL script:
   - Open file: `database_setup_tidbcloud.sql` from this directory
   - Copy entire content
   - Paste into TiDBCloud SQL Editor
   - Click **"Execute"**

2. Verify all tables were created:

```sql
SELECT COUNT(*) as table_count FROM information_schema.tables 
WHERE table_schema = 'waterstation_db' AND table_type = 'BASE TABLE';
```

Should return: **13 tables**

3. Verify admin account was seeded:

```sql
SELECT * FROM users WHERE role = 'super_admin';
```

Should return 1 admin account with:
- Username: `admin`
- Password: `admin` (plaintext - change after first login!)

---

## 🌐 RENDER.COM DEPLOYMENT (Step-by-Step)

### Step 1: Push Code to GitHub

1. **Open terminal in project directory**

```bash
cd "d:\Others\Azeu Codes\Deployment WaterStation"
git init
git add .
git commit -m "Initial commit - Azeu Water Station v1.0"
```

2. **Create GitHub Repository**
   - Go to https://github.com/new
   - Repository name: `azeu-water-station`
   - Description: `Water Station Management System - Render.com Deployment`
   - Set to **Private** (keep credentials safe)
   - Click **"Create Repository"**

3. **Push to GitHub**

```bash
git remote add origin https://github.com/YOUR_USERNAME/azeu-water-station.git
git branch -M main
git push -u origin main
```

Enter your GitHub credentials when prompted.

### Step 2: Configure Render.com Web Service

1. **Go to https://dashboard.render.com**

2. **Create New Web Service**
   - Click **"New +"** → **"Web Service"**
   - Connect GitHub if not already connected
   - Select repository: `azeu-water-station`
   - Click **"Connect"**

3. **Configure Service**
   - **Name:** `azeu-water-station`
   - **Region:** Singapore `sgp1` (closest to Philippines)
   - **Branch:** `main`
   - **Runtime:** `Docker`
   - **Plan:** Free (upgrade to Starter for better performance)

4. **Click "Create Web Service"**

### Step 3: Add Environment Variables

1. In Render.com dashboard, go to your service page
2. Click **"Environment"** tab
3. Add these variables:

| Key | Value |
|-----|-------|
| `DB_HOST` | `gateway01.ap-southeast-1.prod.aws.tidbcloud.com` |
| `DB_PORT` | `4000` |
| `DB_NAME` | `waterstation_db` |
| `DB_USER` | `zJGjwkovwuzEN37.root` |
| `DB_PASS` | `RuIpyygssjzXjB4D` |
| `DB_SSL_ENABLED` | `true` |
| `ENCRYPTION_KEY` | [Your secure key from .env] |
| `APP_ENV` | `production` |
| `APP_DEBUG` | `false` |
| `TIMEZONE` | `Asia/Manila` |

4. Click **"Save"** at bottom

5. **Trigger Deploy**
   - Render.com will automatically rebuild and deploy
   - Monitor the "Deploy" tab for progress
   - Wait for status to turn green (5-10 minutes)

---

## 🔑 ENVIRONMENT CONFIGURATION

### .env File Structure

The `.env` file in your project contains all configuration needed. Key variables:

```bash
# Database (TiDBCloud)
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=waterstation_db
DB_USER=zJGjwkovwuzEN37.root
DB_PASS=RuIpyygssjzXjB4D
DB_SSL_ENABLED=true        # CRITICAL for TiDBCloud

# Encryption (generate new for production)
ENCRYPTION_KEY=your-secure-key

# Application
APP_ENV=production
APP_DEBUG=false
TIMEZONE=Asia/Manila
```

### Generating a Secure Encryption Key

Run this command in terminal:

```bash
openssl rand -base64 32
```

Copy the output and update the `ENCRYPTION_KEY` in both:
1. Your local `.env` file
2. Render.com environment variables

---

## 💾 DATABASE INITIALIZATION

### About first_setup.php

**⚠️ WARNING:** `first_setup.php` may not work properly with TiDBCloud because:
1. It attempts to CREATE DATABASE which TiDBCloud clusters don't support via API
2. TiDBCloud requires databases to be created manually or via SQL Editor
3. The automatic connection may fail before the database creation logic runs

### Solution: Use SQL Script (Recommended)

**Use the provided `database_setup_tidbcloud.sql` script instead:**

1. ✅ Already tested and verified
2. ✅ Creates all 13 tables with proper structure
3. ✅ Inserts system settings (16 default settings)
4. ✅ Seeds default item names (10 items)
5. ✅ Creates super admin account
6. ✅ No database creation errors

### Steps to Initialize:

1. **Before Deployment** (Recommended):
   - Create database in TiDBCloud using their SQL Editor
   - Run `database_setup_tidbcloud.sql` script
   - Verify tables exist
   - Deploy application

2. **After Deployment** (Alternative):
   - If database isn't initialized, run SQL script in TiDBCloud
   - Application will connect on next page load

### First Login After Setup

1. Access your deployed app: `https://your-app.onrender.com`
2. Login with credentials from the setup script:
   - **Username:** `admin`
   - **Password:** `admin`

⚠️ **IMMEDIATELY change the password:**
- Click account avatar (top right)
- Go to **Settings** → **Change Password**
- Set a strong password

---

## 🔍 POST-DEPLOYMENT VERIFICATION

### Test 1: Access the Application

```
https://your-app-name.onrender.com/
```

You should see the login page. If you see a connection error, check:
- Environment variables are set correctly
- Database is initialized in TiDBCloud
- `DB_SSL_ENABLED` is `true`

### Test 2: Check Database Connection

1. Create a test file: `test_connection.php`

```php
<?php
require_once 'config/constants.php';
require_once 'config/database.php';

$stmt = $pdo->query("SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'waterstation_db'");
$result = $stmt->fetch();
echo "✅ Database Connected! Tables: " . $result['table_count'];
?>
```

2. Access: `https://your-app.onrender.com/test_connection.php`

### Test 3: Verify Tables

Login as admin, then:

1. Check Admin Dashboard works
2. Check if you can access analytics
3. Verify system settings are loaded
4. Try creating a test customer account

### Test 4: Check Logs

Access your Render.com service dashboard:
- Click **"Logs"** tab
- Should see successful connections and no database errors

---

## 🔧 TROUBLESHOOTING

### Error 1: "DATABASE ERROR: SQLSTATE[HY000] [1105] Connections using insecure transport are prohibited"

**Cause:** `DB_SSL_ENABLED` is not set or set to `false`

**Solution:**
1. Go to Render.com → Environment
2. Verify `DB_SSL_ENABLED=true`
3. Click "Save" to redeploy
4. Wait 5 minutes and refresh page

### Error 2: "Can't connect to database server"

**Causes:**
1. Database name doesn't exist in TiDBCloud
2. Credentials are wrong
3. Network timeout

**Solutions:**
1. Verify database `waterstation_db` exists in TiDBCloud
2. Double-check credentials in both `.env` and Render.com
3. Run SQL setup script in TiDBCloud SQL Editor
4. Wait for Render.com redeploy to complete (check Logs tab)

### Error 3: "Table 'waterstation_db.users' doesn't exist"

**Cause:** Database created but tables not initialized

**Solution:**
1. Go to TiDBCloud SQL Editor
2. Run the entire `database_setup_tidbcloud.sql` script
3. Wait 30 seconds
4. Refresh your app in browser

### Error 4: Login fails with admin/admin

**Possible causes:**
1. User wasn't created (database not initialized)
2. Password is encrypted but encryption key is different

**Solutions:**
1. Verify `admin` account exists in TiDBCloud:
   ```sql
   SELECT * FROM users WHERE username = 'admin';
   ```
2. If not found, run SQL setup script again
3. Check `ENCRYPTION_KEY` in Render.com matches `.env` file

### Error 5: Docker build fails in Render.com

**Cause:** Dockerfile has issues

**Solutions:**
1. Check error message in Render.com "Logs"
2. Common issues:
   - PHP extensions not installed
   - PORT variable handling incorrect
   - File permissions wrong
3. Redeploy: Click "Manual Deploy" button in Render.com

---

## ❓ FAQ

### Q1: Do I need to run first_setup.php?

**Answer:** No, recommended to use the SQL script instead:
- TiDBCloud doesn't support automatic database creation
- SQL script is more reliable
- first_setup.php won't work with TiDBCloud

### Q2: Can I use first_setup.php if I want?

**Answer:** Technically yes, but not recommended:
- Delete the SQL script approach
- Ensure database already exists in TiDBCloud
- It may still fail on CREATE DATABASE statement
- Better to use pure SQL for cloud databases

### Q3: The password says "admin" - is this secure?

**Answer:** No, plaintext "admin" is only for initial setup:
1. Change it immediately after first login
2. Click Settings → Change Password
3. Use strong password (12+ characters, mix of uppercase/lowercase/numbers/symbols)

### Q4: Can I delete first_setup.php after deployment?

**Answer:** Yes:
1. It's only needed for initial setup
2. After deploying with SQL script, you can delete it
3. Add to `.gitignore` for next deployment
4. Or just leave it (won't hurt if database already exists)

### Q5: What if I made a mistake in the database?

**Answer:** Reset the database:
1. In TiDBCloud SQL Editor, run:
   ```sql
   DROP DATABASE waterstation_db;
   ```
2. Re-run the complete `database_setup_tidbcloud.sql` script
3. Redeploy your app (click "Redeploy" in Render.com)

### Q6: How do I backup my data?

**Answer:** TiDBCloud provides automatic backups:
1. Go to TiDBCloud dashboard
2. Click on cluster
3. Click "Backup" or "Data Recovery"
4. TiDBCloud keeps backups automatically

For manual backup:
```sql
-- Export format from TiDBCloud SQL Editor (copy-paste results)
SELECT * FROM users;
SELECT * FROM orders;
-- etc.
```

### Q7: Can I scale the application later?

**Answer:** Yes:
1. **Render.com:** Upgrade from Free to Starter/Plus plan
2. **TiDBCloud:** Upgrade from Serverless to Dedicated cluster
3. Both support automatic scaling

### Q8: How much does it cost?

**Answer:** 
- **Render.com Free:** $0/month (limited resources, good for testing)
- **Render.com Starter:** $7+/month (recommended for production)
- **TiDBCloud Serverless:** $0-50/month (scales with usage)
- **TiDBCloud Dedicated:** $300+/month

For a small water station, Render.com Free + TiDBCloud Serverless might be enough.

### Q9: What's the expected uptime?

**Answer:**
- **Render.com:** 99.9% uptime SLA (Starter plan and above)
- **TiDBCloud:** 99.95% uptime for Dedicated clusters
- Free tier has lower guarantees but generally reliable

### Q10: Can I use other databases?

**Answer:** Yes, but requires changes:
1. Update `config/constants.php` with new credentials
2. Database must support:
   - PDO driver (MySQL/MariaDB/TiDB compatible)
   - FOREIGN KEY support
   - ENUM data types
3. Same SQL schema applies to most MySQL-compatible databases

---

## 🎯 DEPLOYMENT SUMMARY CHECKLIST

### Before Deployment ✓
- [ ] All project files ready
- [ ] `.env` file created with credentials
- [ ] `.gitignore` configured
- [ ] `database_setup_tidbcloud.sql` prepared
- [ ] Dockerfile updated for Render.com

### TiDBCloud Setup ✓
- [ ] TiDBCloud cluster created (Serverless tier, Singapore region)
- [ ] Connection details verified
- [ ] Database `waterstation_db` created via SQL Editor
- [ ] `database_setup_tidbcloud.sql` executed successfully
- [ ] All 13 tables verified to exist
- [ ] Super admin account seeded

### GitHub Upload ✓
- [ ] Repository created (private)
- [ ] All files pushed to GitHub
- [ ] Sensitive files in `.gitignore`
- [ ] Repository ready for Render.com

### Render.com Deployment ✓
- [ ] GitHub account connected to Render.com
- [ ] Web service created (Docker runtime)
- [ ] Environment variables set correctly
- [ ] `DB_SSL_ENABLED=true` configured
- [ ] Deployment completed successfully

### Post-Deployment Testing ✓
- [ ] Application loads at `https://your-app.onrender.com`
- [ ] Login page displays
- [ ] Admin login works with `admin/admin`
- [ ] Dashboard loads without errors
- [ ] Database connection verified

### Security Steps ✓
- [ ] Changed admin password from default
- [ ] Verified `.env` not committed to GitHub
- [ ] Set `APP_DEBUG=false` in production
- [ ] Checked Render.com environment variables are secure
- [ ] Considered HTTPS enforcement (automatic on Render.com)

---

## 🚀 NEXT STEPS AFTER DEPLOYMENT

1. **Change Default Password**
   - Login as admin
   - Go to Settings → Change Password
   - Set strong password (min 12 characters)

2. **Configure System Settings**
   - Go to Admin → System Settings
   - Set station name, address, delivery fee
   - Configure other preferences

3. **Create Staff/Rider Accounts**
   - Admin → Create Staff Account
   - Admin → Create Rider Account
   - Give them unique credentials

4. **Add Inventory Items**
   - Admin → Inventory Management
   - Add water products and items
   - Set prices and stock levels

5. **Test Complete Workflow**
   - Register as customer
   - Create order
   - Assign to rider
   - Complete delivery
   - Verify no errors in logs

6. **Monitor Performance**
   - Check Render.com dashboard for metrics
   - Review application logs weekly
   - Monitor TiDBCloud usage

---

## 📞 SUPPORT & RESOURCES

- **Render.com Docs:** https://docs.render.com
- **TiDBCloud Docs:** https://docs.pingcap.com/tidbcloud
- **PHP Documentation:** https://www.php.net/docs.php
- **MySQL/TiDB SQL Docs:** https://dev.mysql.com/doc/

---

**✅ DEPLOYMENT COMPLETE!**

Your Azeu Water Station system is now running in production on Render.com + TiDBCloud.

Happy deploying! 🎉
