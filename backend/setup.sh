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

# Get exact Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
echo "Installed Chrome version: $CHROME_VERSION"

# Install matching ChromeDriver
CHROME_MAJOR_VERSION=${CHROME_VERSION%%.*}
CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_MAJOR_VERSION"
CHROMEDRIVER_VERSION=$(curl -fsSL "$CHROMEDRIVER_URL")
echo "Downloading ChromeDriver version: $CHROMEDRIVER_VERSION"

curl -fSLO "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip -q chromedriver_linux64.zip
chmod +x chromedriver
mv chromedriver /usr/local/bin/
rm -f chromedriver_linux64.zip

# Verify installation
echo "ChromeDriver installed at: $(which chromedriver)"
echo "ChromeDriver version: $(chromedriver --version)"