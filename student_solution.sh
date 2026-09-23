#!/bin/bash

# SELinux Access Denial Practical
# Student Name:
# Register Number:

echo "===== SELinux Status ====="
sestatus

echo "===== Creating Web Directory ====="
mkdir -p /var/www/html/testdir

echo "===== Creating HTML File ====="
echo "<h1>SELinux Practical Test</h1>" > /var/www/html/testdir/index.html

echo "===== Setting Linux Permissions ====="
chmod -R 755 /var/www/html/testdir

echo "===== Checking Initial Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Assigning Wrong SELinux Context ====="
# Assign user home content context to simulate an access denial for web server process
chcon -t user_home_t /var/www/html/testdir/index.html

echo "===== Checking Wrong Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Checking AVC Denials ====="
# Check for recent SELinux audit log denial entries related to httpd
ausearch -m avc -ts recent 2>/dev/null || grep "SELinux is preventing" /var/log/messages 2>/dev/null || echo "No recent AVC denials found."

echo "===== Correcting SELinux Context ====="
# Restore default SELinux context (httpd_sys_content_t)
restorecon -v /var/www/html/testdir/index.html

echo "===== Checking Correct Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Practical Completed ====="
