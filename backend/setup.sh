#!/bin/bash
set -e  # Exit immediately if any command fails

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    --no-install-recommends

# Install Chrome via direct download (stable version)
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
curl -fSLO "$CHROME_DEB_URL"
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Get installed Chrome version (e.g. 137.0.7107.0)
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
MAJOR_VERSION=$(echo "$CHROME_VERSION" | cut -d'.' -f1)

# Download ChromeDriver using version-specific URL
CHROMEDRIVER_URL="https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VERSION/linux64/chromedriver-linux64.zip"
echo "Downloading ChromeDriver from: $CHROMEDRIVER_URL"

# Download and install ChromeDriver
curl -fSLO "$CHROMEDRIVER_URL"
unzip -q chromedriver-linux64.zip -d chromedriver
chmod +x chromedriver/chromedriver
mv chromedriver/chromedriver /usr/local/bin/
rm -rf chromedriver*

# Verify installation
echo "Chrome version: $(google-chrome --version)"
echo "ChromeDriver version: $(chromedriver --version)"