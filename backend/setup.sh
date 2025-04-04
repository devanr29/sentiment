#!/bin/bash
set -e  # Exit immediately if any command fails

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg \
    curl \
    xvfb

# Install Google Chrome
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update && apt-get install -y google-chrome-stable

# Get Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
MAJOR_VERSION=$(echo $CHROME_VERSION | cut -d'.' -f1)

# Download matching ChromeDriver
mkdir -p /tmp/chromedriver
CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$MAJOR_VERSION"
CHROMEDRIVER_VERSION=$(curl -fsSL $CHROMEDRIVER_URL)
DOWNLOAD_URL="https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"

# Install ChromeDriver
curl -fsSL $DOWNLOAD_URL -o /tmp/chromedriver/chromedriver.zip
unzip -q /tmp/chromedriver/chromedriver.zip -d /tmp/chromedriver
install -o root -g root -m 0755 /tmp/chromedriver/chromedriver /usr/local/bin/chromedriver

# Verify installation
echo "Chrome version: $(google-chrome --version)"
echo "ChromeDriver path: $(which chromedriver)"
echo "ChromeDriver version: $(chromedriver --version)"