#!/bin/bash
set -e  # Exit immediately if any command fails

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    jq \
    --no-install-recommends

# Install Chrome via direct download
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
curl -fSLO "$CHROME_DEB_URL"
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Get Chrome version (e.g., 137.0.7107.0)
FULL_VERSION=$(google-chrome --version | awk '{print $3}')
echo "Installed Chrome version: $FULL_VERSION"

# Get latest stable ChromeDriver URL
CHROMEDRIVER_JSON="https://googlechromelabs.github.io/chrome-for-testing/latest-patch-versions-per-build-with-downloads.json"
DOWNLOAD_DATA=$(curl -fsSL "$CHROMEDRIVER_JSON")
CHROMEDRIVER_URL=$(echo "$DOWNLOAD_DATA" | jq -r '.builds[].downloads.chromedriver[] | select(.platform == "linux64") | .url')

echo "Downloading ChromeDriver from: $CHROMEDRIVER_URL"
curl -fSLO "$CHROMEDRIVER_URL"
unzip -q chromedriver-linux64.zip
chmod +x chromedriver-linux64/chromedriver
mv chromedriver-linux64/chromedriver /usr/local/bin/
rm -rf chromedriver-linux64*

# Verify installation
echo "ChromeDriver installed at: $(which chromedriver)"
echo "ChromeDriver version: $(chromedriver --version)"