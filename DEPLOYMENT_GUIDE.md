# 🚀 Azeu Water Station - Deployment Guide for Render.com + TiDBCloud

This guide walks you through deploying the Azeu Water Station Management System to Render.com using Docker with TiDBCloud as the database.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [TiDBCloud Setup](#tidbcloud-setup)
3. [Render.com Deployment](#rendercom-deployment)
4. [Environment Variables](#environment-variables)
5. [First-Time Setup](#first-time-setup)
6. [Post-Deployment](#post-deployment)
7. [Troubleshooting](#troubleshooting)

---

## 🔧 Prerequisites

Before starting, ensure you have:

- [ ] GitHub account (to host your repository)
- [ ] TiDBCloud account (free tier available at https://tidbcloud.com)
- [ ] Render.com account (free tier available at https://render.com)
- [ ] Git installed on your local machine

---

## 🗄️ TiDBCloud Setup

### Step 1: Create a TiDB Cluster

1. **Sign up/Login** to TiDBCloud: https://tidbcloud.com
2. **Create a new cluster:**
   - Click "Create Cluster"
   - Select "Serverless Tier" (free)
   - Choose region: `ap-southeast-1` (Singapore - closest to Philippines)
   - Cluster name: `waterstation-production`
   - Click "Create"

3. **Wait for cluster creation** (takes 1-2 minutes)

### Step 2: Create Database

✅ **Your TiDBCloud Connection Details:**
- **Host:** `gateway01.ap-southeast-1.prod.aws.tidbcloud.com`
- **Port:** `4000`
- **Username:** `zJGjwkovwuzEN37.root`
- **Password:** `RuIpyygssjzXjB4D`

1. Click on your cluster name
2. Go to **"SQL Editor"** or **"Connect"** tab
3. Click **"Open SQL Editor"**
4. **IMPORTANT:** Run this SQL command to create your database:
   ```sql
   CREATE DATABASE waterstation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
5. Verify database was created:
   ```sql
   SHOW DATABASES;
   ```
   You should see `waterstation_db` in the list.

⚠️ **CRITICAL:** TiDBCloud requires SSL/TLS connections by default. The application is already configured for this.

---

## 🌐 Render.com Deployment

### Step 1: Push Code to GitHub

1. **Initialize Git** (if not already done):
   ```bash
   cd "d:\Others\Azeu Codes\Deployment WaterStation"
   git init
   git add .
   git commit -m "Initial commit - Water Station System"
   ```

2. **Create GitHub repository:**
   - Go to https://github.com/new
   - Repository name: `azeu-water-station`
   - Set to **Private** (recommended)
   - Click "Create repository"

3. **Push to GitHub:**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/azeu-water-station.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Create Web Service on Render.com

1. **Login to Render.com:** https://dashboard.render.com

2. **Create New Web Service:**
   - Click "New +" → "Web Service"
   - Connect your GitHub account if not connected
   - Select repository: `azeu-water-station`

3. **Configure Build Settings:**
   - **Name:** `azeu-water-station`
   - **Region:** Singapore (or closest to your users)
   - **Branch:** `main`
   - **Runtime:** Docker
   - **Instance Type:** Free (or starter for better performance)

4. **Add Environment Variables** (see next section)

5. Click **"Create Web Service"**

### Step 3: Configure Environment Variables

In Render.com dashboard, go to **Environment** tab and add these variables:

#### ✅ Your Actual Configuration:

| Variable | Value |
|----------|-------|
| `DB_HOST` | `gateway01.ap-southeast-1.prod.aws.tidbcloud.com` |
| `DB_PORT` | `4000` |
| `DB_NAME` | `waterstation_db` |
| `DB_USER` | `zJGjwkovwuzEN37.root` |
| `DB_PASS` | `RuIpyygssjzXjB4D` |
| `DB_SSL_ENABLED` | `true` |
| `ENCRYPTION_KEY` | Generate with: `openssl rand -base64 32` |
| `DEBUG_MODE` | `false` |

#### Optional Variables:

| Variable | Value | Notes |
|----------|-------|-------|
| `APP_URL` | Your app URL | Auto-set by Render |
| `TIMEZONE` | Timezone | `Asia/Manila` |
| `LOG_LEVEL` | Log level | `ERROR` for production |

⚠️ **Generate a strong ENCRYPTION_KEY:**
```bash
openssl rand -base64 32
```

---

## 🎯 First-Time Setup

After deployment, you need to create the admin account:

### Option 1: Using first_setup.php (Recommended)

1. **Access setup page:**
   ```
   https://your-app-name.onrender.com/first_setup.php
   ```

2. **Fill in credentials:**
   - Super Admin username: `superadmin`
   - Super Admin password: (Choose a strong password!)
   - Admin username: `admin`
   - Admin password: (Choose a strong password!)

3. **Click "Run Initial Setup"**

4. **Delete or disable first_setup.php** after setup for security

### Option 2: Manual Setup via TiDBCloud SQL Editor

If first_setup.php doesn't work, manually run the SQL:

1. Go to TiDBCloud SQL Editor
2. Run the table creation SQL (find in `first_setup.php`)
3. Insert super admin manually:
   ```sql
   INSERT INTO users (username, password, full_name, email, phone, role, status)
   VALUES ('admin', 'admin', 'System Administrator', 'admin@azeu.com', '09123456789', 'super_admin', 'active');
   ```

---

## ✅ Post-Deployment

### 1. Test the Application

1. **Access your app:**
   ```
   https://your-app-name.onrender.com
   ```

2. **Login with admin credentials**

3. **Test key features:**
   - [ ] Create a customer account
   - [ ] Add inventory items
   - [ ] Create a test order
   - [ ] Check notifications
   - [ ] Test dark mode

### 2. Configure System Settings

1. Login as admin
2. Go to **System Settings**
3. Update:
   - Station Name
   - Station Address
   - Delivery Fee
   - Other settings as needed

### 3. Security Checklist

- [ ] Changed default admin password
- [ ] Set strong ENCRYPTION_KEY
- [ ] Disabled DEBUG_MODE in production
- [ ] Removed/disabled first_setup.php
- [ ] Configured HTTPS (Render provides this automatically)
- [ ] Set up regular database backups (TiDBCloud settings)

---

## 🐛 Troubleshooting

### Issue: "Connections using insecure transport are prohibited"

**Solution:** Ensure `DB_SSL_ENABLED=true` in environment variables.

**Verify in code:**
```php
// In config/database.php - SSL should be enabled
$db_ssl_enabled = getenv('DB_SSL_ENABLED') === 'true';
```

### Issue: "Database connection failed"

**Check:**
1. TiDBCloud cluster is running (not paused)
2. Database `waterstation_db` exists
3. Credentials are correct in Render environment variables
4. Port is `4000` (not 3306)
5. Host includes full TiDBCloud domain

### Issue: "Database does not exist"

**Solution:**
TiDBCloud doesn't allow automatic database creation. Create it manually:
```sql
CREATE DATABASE waterstation_db;
```

### Issue: "Tables not created"

**Check:**
1. Database.php runs successfully (check logs in Render)
2. PDO connection has proper permissions
3. Run first_setup.php manually

### Issue: "Page not found" or "404 errors"

**Check:**
1. `.htaccess` file exists in root
2. Apache mod_rewrite is enabled (Dockerfile includes this)
3. Dockerfile is configured correctly

### Issue: "Images/uploads not working"

**Solution:** Render uses ephemeral storage. For production:
1. Use cloud storage (AWS S3, Cloudinary, etc.)
2. Or use Render disks (paid feature)

---

## 📊 Monitoring & Logs

### View Application Logs:

1. Go to Render.com dashboard
2. Click on your service
3. Go to **"Logs"** tab
4. View real-time logs

### Monitor Database:

1. Go to TiDBCloud dashboard
2. Click on your cluster
3. View **"Monitoring"** tab for metrics

---

## 🔄 Updating the Application

### Deploy New Changes:

1. **Local changes:**
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin main
   ```

2. **Render auto-deploys** from GitHub on push

3. **Manual deploy:** In Render dashboard → "Manual Deploy" → "Deploy latest commit"

---

## 💾 Database Backups

### TiDBCloud Automatic Backups:

- **Serverless Tier:** Automatic daily backups (7-day retention)
- **Dedicated Tier:** Configurable backup schedules

### Manual Backup:

1. Go to TiDBCloud SQL Editor
2. Export database:
   ```bash
   mysqldump -h gateway01.ap-southeast-1.prod.aws.tidbcloud.com \
             -P 4000 \
             -u your_username \
             -p \
             --ssl-mode=REQUIRED \
             waterstation_db > backup.sql
   ```

---

## 🔐 Security Best Practices

1. **Never commit `.env` file** - It's in `.gitignore`
2. **Use strong passwords** - Minimum 12 characters
3. **Enable 2FA** on GitHub, Render, and TiDBCloud accounts
4. **Regular updates** - Keep dependencies updated
5. **Monitor logs** - Check for suspicious activity
6. **Limit admin access** - Only create admin accounts for trusted users
7. **SSL/TLS only** - TiDBCloud enforces this automatically

---

## 📞 Support & Resources

- **Render Documentation:** https://render.com/docs
- **TiDBCloud Documentation:** https://docs.pingcap.com/tidbcloud
- **Docker Documentation:** https://docs.docker.com

---

## 📝 Notes

### About first_setup.php:

**Will it work with TiDBCloud?**

**Partially.** The script will:
- ✅ Create all tables successfully
- ✅ Insert default data
- ✅ Create admin accounts
- ❌ **CANNOT** create the database itself

**Why?** TiDBCloud's Serverless tier doesn't allow `CREATE DATABASE` from application code. You must create the database manually in the TiDBCloud console first.

### Database Differences:

| Feature | Local MySQL | TiDBCloud |
|---------|-------------|-----------|
| Database creation | Auto via PHP | Manual via console |
| SSL/TLS | Optional | Required |
| Port | 3306 | 4000 |
| Charset | utf8mb4 | utf8mb4 ✓ |
| All SQL features | Full support | MySQL 5.7 compatible |

---

## ✨ Success!

If everything is configured correctly:

1. Your app is live at `https://your-app-name.onrender.com`
2. Database is hosted on TiDBCloud (secure, scalable)
3. SSL/TLS encryption enabled
4. Automatic deployments on Git push
5. Production-ready environment

**Default Login:**
- Username: `admin` (or what you set in first_setup.php)
- Password: (what you set in first_setup.php)

Remember to:
- Change default passwords immediately
- Configure system settings
- Add inventory items
- Test all features

---

**Need help?** Check the troubleshooting section or review Render/TiDBCloud logs for detailed error messages.

**Happy Deploying! 🎉**
