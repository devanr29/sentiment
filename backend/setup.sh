#!/bin/bash
set -e  # Exit immediately if any command fails

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    --no-install-recommends

# Install Chrome via direct download
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
curl -fSLO "$CHROME_DEB_URL"
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Get exact Chrome version (e.g., 135.0.7049.52)
FULL_VERSION=$(google-chrome --version | awk '{print $3}')
MAJOR_VERSION=$(echo "$FULL_VERSION" | cut -d'.' -f1)

# New reliable method to get ChromeDriver
CHROMEDRIVER_URL="https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json"
VERSION_DATA=$(curl -fsSL "$CHROMEDRIVER_URL")
DOWNLOAD_URL=$(echo "$VERSION_DATA" | grep -A 5 "linux64" | grep "chromedriver" | grep -o 'https://[^"]*')

echo "Downloading ChromeDriver from: $DOWNLOAD_URL"
curl -fSLO "$DOWNLOAD_URL"
unzip -q chromedriver-linux64.zip
chmod +x chromedriver-linux64/chromedriver
mv chromedriver-linux64/chromedriver /usr/local/bin/
rm -rf chromedriver-linux64*

# Verify installation
echo "Chrome version: $(google-chrome --version)"
echo "ChromeDriver version: $(chromedriver --version)"