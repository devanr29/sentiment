#!/bin/bash
# Install dependencies
apt-get update && apt-get install -y wget unzip gnupg curl xvfb

# Install Google Chrome
curl -sSL https://dl.google.com/linux/linux_signing_key.pub -o /tmp/google-key.pub
cat /tmp/google-key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update && apt-get install -y google-chrome-stable

# Get exact Chrome version
FULL_VERSION=$(google-chrome --version | awk '{print $3}')
MAJOR_VERSION=$(echo $FULL_VERSION | cut -d'.' -f1)

# Download matching ChromeDriver
CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$MAJOR_VERSION"
CHROMEDRIVER_VERSION=$(curl -sSL $CHROMEDRIVER_URL)
DOWNLOAD_URL="https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"

# Install ChromeDriver
mkdir -p /tmp/chromedriver
curl -sSL $DOWNLOAD_URL -o /tmp/chromedriver/chromedriver.zip
unzip -o /tmp/chromedriver/chromedriver.zip -d /tmp/chromedriver
mv /tmp/chromedriver/chromedriver /usr/local/bin/
chmod +x /usr/local/bin/chromedriver

# Verify installations
echo "Chrome version: $(google-chrome --version)"
echo "ChromeDriver version: $(chromedriver --version)"