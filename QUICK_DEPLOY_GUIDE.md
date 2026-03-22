# 🚀 Quick Deployment Guide - Azeu Water Station

## ✅ Prerequisites Checklist

You have all the necessary information already! Here's what you provided:

### TiDBCloud Credentials:
- ✅ Host: `gateway01.ap-southeast-1.prod.aws.tidbcloud.com`
- ✅ Port: `4000`
- ✅ Username: `zJGjwkovwuzEN37.root`
- ✅ Password: `RuIpyygssjzXjB4D`
- ⚠️ Database: **Needs to be created manually** (see step 1)

---

## 📝 5-Step Deployment Process

### Step 1: Create Database in TiDBCloud (2 minutes)

1. Go to https://tidbcloud.com
2. Click on your cluster → SQL Editor
3. Run this command:
   ```sql
   CREATE DATABASE waterstation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. Verify:
   ```sql
   SHOW DATABASES;
   ```

✅ **Done!** Database `waterstation_db` is ready.

---

### Step 2: Push Code to GitHub (3 minutes)

```bash
cd "d:/Others/Azeu Codes/Deployment WaterStation"
git init
git add .
git commit -m "Initial deployment setup"

# Create a new repository on GitHub, then:
git remote add origin https://github.com/YOUR_USERNAME/azeu-water-station.git
git branch -M main
git push -u origin main
```

---

### Step 3: Deploy to Render.com (5 minutes)

1. Go to https://dashboard.render.com
2. Click **"New +" → "Web Service"**
3. Connect your GitHub repository
4. Configure:
   - **Name:** `azeu-water-station`
   - **Region:** Singapore
   - **Branch:** `main`
   - **Runtime:** Docker
   - **Instance Type:** Free (or Starter)

---

### Step 4: Set Environment Variables in Render

Go to **Environment** tab and add these:

```env
DB_HOST=gateway01.ap-southeast-1.prod.aws.tidbcloud.com
DB_PORT=4000
DB_NAME=waterstation_db
DB_USER=zJGjwkovwuzEN37.root
DB_PASS=RuIpyygssjzXjB4D
DB_SSL_ENABLED=true
ENCRYPTION_KEY=<generate_with_command_below>
DEBUG_MODE=false
```

**Generate ENCRYPTION_KEY:**

PowerShell (Windows):
```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
```

Or use this online: https://generate-random.org/api-key-generator (32 characters)

Click **"Save Changes"**

---

### Step 5: Initial Setup (2 minutes)

After deployment completes:

1. Visit: `https://your-app-name.onrender.com/first_setup.php`
2. Fill in credentials for admin account:
   - Super Admin username: `superadmin`
   - Super Admin password: (choose a strong one!)
   - Admin username: `admin`
   - Admin password: (choose a strong one!)
3. Click **"Run Initial Setup"**
4. Wait for "Setup completed successfully!"

✅ **DONE!** Your water station system is live!

---

## 🔒 Post-Deployment Security

### 1. Disable first_setup.php

After successful setup, remove the file from your repository:

```bash
git rm first_setup.php
git commit -m "Remove setup file after deployment"
git push
```

Or set environment variable in Render:
```env
DISABLE_SETUP=true
```

### 2. Change Default Password

1. Login with your admin account
2. Go to **Settings** → **Change Password**
3. Set a strong password (minimum 12 characters)

### 3. Configure System Settings

1. Login as admin
2. Navigate to **System Settings**
3. Update:
   - Station Name
   - Station Address
   - Delivery Fee
   - Other preferences

---

## ⚠️ Important Notes

### About first_setup.php and TiDBCloud:

**Q: Will first_setup.php work with TiDBCloud?**

**A:** ✅ **Yes, but with one requirement:**

- ✅ **Will create all tables** (13 tables)
- ✅ **Will seed initial data** (settings, default items, admin account)
- ✅ **Will work perfectly** with SSL connections
- ❌ **CANNOT create the database** (must be done manually in TiDBCloud console)

**Solution:** Just create the database manually in TiDBCloud first (Step 1 above), then run first_setup.php.

### SSL Connection Error Prevention:

The error you mentioned:
```
DATABASE ERROR: SQLSTATE[HY000] [1105] Connections using insecure transport are prohibited
```

**Is prevented by:**
1. ✅ Setting `DB_SSL_ENABLED=true` in environment variables
2. ✅ Database.php already configured to use PDO SSL options (lines 36-45)
3. ✅ TiDBCloud requires SSL - we're using it!

The application automatically:
- Detects `DB_SSL_ENABLED=true`
- Enables PDO SSL options
- Connects securely to TiDBCloud

---

## 🧪 Testing After Deployment

### 1. Test Database Connection

Visit: `https://your-app-name.onrender.com/test_db.php`

Should show: ✅ "Database connection successful"

### 2. Test Login

1. Go to: `https://your-app-name.onrender.com`
2. Login with admin credentials
3. Should redirect to admin dashboard

### 3. Create Test Data

1. Go to **Inventory** → Add a test item
2. Go to **Accounts** → Create a test customer
3. Place a test order as customer

---

## 📊 Monitoring

### View Application Logs:

1. Go to Render dashboard
2. Click on your service
3. Click **"Logs"** tab
4. Monitor real-time logs

### Monitor Database:

1. Go to TiDBCloud dashboard
2. Click on your cluster
3. View **"Monitoring"** tab

---

## 🐛 Troubleshooting

### Issue: "Database connection failed"

**Check:**
1. ✅ Database `waterstation_db` exists in TiDBCloud
2. ✅ Environment variables are correct
3. ✅ `DB_SSL_ENABLED=true` is set
4. ✅ TiDBCloud cluster is running (not paused)

**Fix:** Verify all environment variables in Render match the credentials above.

### Issue: "Tables not found"

**Fix:** Run `first_setup.php` or manually run the table creation SQL from the file.

### Issue: "SSL connection error"

**Fix:** Ensure `DB_SSL_ENABLED=true` in Render environment variables.

---

## 🎯 Quick Commands Reference

### Deploy Updates:

```bash
git add .
git commit -m "Your changes"
git push origin main
```

Render auto-deploys from GitHub!

### Manual Deploy:

In Render dashboard → **"Manual Deploy"** → **"Deploy latest commit"**

### View Logs:

Render dashboard → Your service → **"Logs"**

---

## 📞 Summary

### What You Have:

✅ All necessary TiDBCloud credentials  
✅ Database SSL connection configured  
✅ Docker setup ready  
✅ Deployment files created  
✅ Environment variables template  

### What You Need to Do:

1. ✅ Create database in TiDBCloud (1 SQL command)
2. ✅ Push code to GitHub
3. ✅ Deploy to Render.com
4. ✅ Set environment variables
5. ✅ Run first_setup.php
6. ✅ Change admin password

**Total Time:** ~15 minutes

---

## ✨ You're All Set!

All deployment files have been created:

- ✅ `Dockerfile` - Production-ready PHP/Apache container
- ✅ `.dockerignore` - Optimized Docker builds
- ✅ `docker-compose.yml` - Local testing (optional)
- ✅ `.gitignore` - Proper Git exclusions
- ✅ `.env.example` - Environment variables template
- ✅ `DEPLOYMENT_GUIDE.md` - Detailed deployment guide
- ✅ `ENV_SETUP.md` - Environment setup guide

**Your credentials are ready. Your system is configured. Just follow the 5 steps above!**

**Good luck with your deployment! 🚀**
