#!/bin/bash

# zowe_operations.sh

set -e

echo "Configuring Zowe..."

zowe config set defaults.host "$ZOS_HOST"
echo "host done"

zowe config set defaults.port 10443
echo "port done"

zowe config set defaults.user "$ZOWE_USERNAME"
echo "user done"

zowe config set defaults.rejectUnauthorized false
echo "ssl done"

echo "Zowe configuration complete"

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
echo "username to lowercase done"

# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
  echo "Directory already exists."
fi
echo "Check if directory exists done"

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.19.jar"
echo "Upload files done"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
