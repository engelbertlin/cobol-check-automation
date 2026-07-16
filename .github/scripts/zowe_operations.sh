#!/bin/bash

# zowe_operations.sh

set -e

echo "Configuring Zowe..."

zowe config set defaults.host "$ZOS_HOST"
zowe config set defaults.port 10443
zowe config set defaults.user "$ZOWE_USERNAME"
zowe config set defaults.password "$ZOWE_PASSWORD"
zowe config set defaults.rejectUnauthorized false

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
  echo "Directory already exists."
fi

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.19.jar"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
