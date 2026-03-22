# 🎯 Pre-Deployment Checklist

Use this checklist to ensure everything is configured correctly before deploying to production.

---

## □ 1. TiDBCloud Setup

- [ ] TiDBCloud account created
- [ ] Serverless cluster created (region: ap-southeast-1 recommended)
- [ ] Database created manually via SQL Editor:
      ```sql
      CREATE DATABASE waterstation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
      ```
- [ ] Connection details noted:
  - [ ] Host (e.g., gateway01.ap-southeast-1.prod.aws.tidbcloud.com)
  - [ ] Port (4000)
  - [ ] Username
  - [ ] Password

---

## □ 2. Environment Configuration

- [ ] Copied `.env.example` to `.env`
- [ ] Updated `.env` with TiDBCloud credentials:
  - [ ] `DB_HOST`
  - [ ] `DB_PORT=4000`
  - [ ] `DB_NAME=waterstation_db`
  - [ ] `DB_USER`
  - [ ] `DB_PASS`
  - [ ] `DB_SSL_ENABLED=true`
- [ ] Generated strong ENCRYPTION_KEY:
      ```bash
      openssl rand -base64 32
      ```
- [ ] Set `DEBUG_MODE=false` for production
- [ ] Verified `.env` is in `.gitignore` (should be by default)

---

## □ 3. Code Repository

- [ ] Git initialized: `git init`
- [ ] GitHub repository created
- [ ] All files added: `git add .`
- [ ] Initial commit: `git commit -m "Initial commit - Water Station System"`
- [ ] Remote added: `git remote add origin <repo-url>`
- [ ] Code pushed: `git push -u origin main`
- [ ] Verified `.env` NOT pushed to GitHub

---

## □ 4. Render.com Setup

- [ ] Render.com account created
- [ ] New Web Service created
- [ ] GitHub repository connected
- [ ] Build settings configured:
  - [ ] Runtime: **Docker**
  - [ ] Branch: **main**
  - [ ] Region: Singapore or nearest
- [ ] Environment variables added in Render dashboard:
  - [ ] `DB_HOST`
  - [ ] `DB_PORT`
  - [ ] `DB_NAME`
  - [ ] `DB_USER`
  - [ ] `DB_PASS`
  - [ ] `DB_SSL_ENABLED`
  - [ ] `ENCRYPTION_KEY`
  - [ ] `DEBUG_MODE`
- [ ] Web service created and deployed

---

## □ 5. First-Time Setup

- [ ] Deployment completed successfully (check Render logs)
- [ ] Application accessible at: `https://your-app.onrender.com`
- [ ] Navigated to: `https://your-app.onrender.com/first_setup.php`
- [ ] Set Super Admin credentials
- [ ] Set Admin credentials
- [ ] Setup completed successfully
- [ ] Verified tables created (check TiDBCloud SQL Editor):
      ```sql
      SHOW TABLES;
      ```

---

## □ 6. Post-Deployment Verification

- [ ] Login successful with admin account
- [ ] Dashboard loads correctly
- [ ] No SSL/TLS connection errors
- [ ] Created test customer account (status: pending)
- [ ] Approved test customer account (status: active)
- [ ] Added test inventory item
- [ ] Placed test order as customer
- [ ] Confirmed test order as admin
- [ ] Checked notifications working
- [ ] Tested dark mode toggle
- [ ] Verified mobile responsiveness

---

## □ 7. Security Hardening

- [ ] Changed default admin password (if used 'admin')
- [ ] Disabled `first_setup.php` (rename or delete after initial setup)
- [ ] Verified `DEBUG_MODE=false` in Render environment
- [ ] Confirmed SSL/TLS enabled (check Render URL uses https://)
- [ ] Tested login lockout (10 failed attempts → locked 15 minutes)
- [ ] Verified logs directory not publicly accessible

---

## □ 8. System Configuration

- [ ] Logged in as admin
- [ ] Navigated to **System Settings**
- [ ] Updated:
  - [ ] Station Name
  - [ ] Station Address
  - [ ] Delivery Fee (default: ₱50.00)
  - [ ] Max Cancellation Limit (default: 5)
  - [ ] Low Stock Threshold (default: 10)
- [ ] Saved settings successfully

---

## □ 9. Inventory Setup

- [ ] Added actual inventory items with:
  - [ ] Item name
  - [ ] Price
  - [ ] Stock count
  - [ ] Status (active)
- [ ] Verified items appear on customer order page
- [ ] Tested restock functionality

---

## □ 10. User Management

- [ ] Created additional admin account (if needed)
- [ ] Created staff accounts
- [ ] Created rider accounts (set as available)
- [ ] Tested account approval workflow
- [ ] Tested account flagging/unflagging

---

## □ 11. Testing Workflows

### Order Workflow (Delivery):
- [ ] Customer places delivery order
- [ ] Staff confirms order (stock decremented)
- [ ] Staff assigns rider
- [ ] Rider marks "On Delivery"
- [ ] Rider marks "Delivered"
- [ ] Customer marks "Accepted/Received"

### Order Workflow (Pickup):
- [ ] Customer places pickup order
- [ ] Staff confirms order
- [ ] Staff marks "Ready for Pickup"
- [ ] Staff marks "Picked Up"

### Cancellation Workflow:
- [ ] Customer cancels pending order
- [ ] Staff cancels confirmed order (stock restored)
- [ ] Rider cancels assigned order (reverts to confirmed)
- [ ] Verified cancellation count increments
- [ ] Tested flagging at max cancellations

### Appeal Workflow:
- [ ] Flagged customer submits appeal
- [ ] Staff/Admin reviews appeal
- [ ] Appeal approved (account unflagged)

---

## □ 12. Monitoring Setup

- [ ] Confirmed Render logs accessible
- [ ] Checked TiDBCloud monitoring dashboard
- [ ] Noted application URL for monitoring
- [ ] Tested email notifications (if configured)

---

## □ 13. Backup Strategy

- [ ] Verified TiDBCloud automatic backups enabled
- [ ] Noted backup retention period (7 days for serverless)
- [ ] Documented manual backup procedure:
      ```bash
      mysqldump -h <host> -P 4000 -u <user> -p --ssl-mode=REQUIRED waterstation_db > backup.sql
      ```

---

## □ 14. Documentation

- [ ] Documented admin login credentials (secure location)
- [ ] Documented database credentials (secure location)
- [ ] Documented Render service URL
- [ ] Saved TiDBCloud cluster connection details
- [ ] Created operations manual for staff (optional)

---

## □ 15. Final Cleanup

- [ ] Removed or renamed `first_setup.php` from production
- [ ] Removed `test_*.php` files from production (if any)
- [ ] Removed `full-setup.php` from production
- [ ] Removed `setup_db_test.php` from production
- [ ] Verified no debug/test code in production build

---

## 🎉 Deployment Complete!

If all checkboxes are checked, your Water Station System is:
- ✅ Securely deployed on Render.com
- ✅ Connected to TiDBCloud with SSL/TLS
- ✅ Fully configured and tested
- ✅ Ready for production use

---

## 📝 Important URLs to Save

```
Application URL: https://_____________________.onrender.com
Admin Login:     https://_____________________.onrender.com/
TiDBCloud:       https://tidbcloud.com
Render Dashboard: https://dashboard.render.com
GitHub Repo:     https://github.com/___________________
```

---

## 🔧 Troubleshooting References

If issues arise:
1. Check Render logs: Dashboard → Service → Logs
2. Check TiDBCloud monitoring: Dashboard → Cluster → Monitoring
3. Review `DEPLOYMENT_GUIDE.md` section on troubleshooting
4. Verify environment variables in Render dashboard
5. Test database connection from TiDBCloud SQL Editor

---

**Keep this checklist for future reference and updates! ✅**
