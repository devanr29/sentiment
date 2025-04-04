#!/bin/bash
set -e  # Exit immediately if any command fails

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    --no-install-recommends

# Install Chrome
curl -fSLO "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Get Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
echo "Installed Chrome version: $CHROME_VERSION"

# Download and install ChromeDriver
mkdir -p chromedriver-tmp
curl -fSL "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VERSION/linux64/chromedriver-linux64.zip" -o chromedriver.zip
unzip -q -o chromedriver.zip -d chromedriver-tmp/

# The binary is named 'chromedriver' inside the directory
chmod +x chromedriver-tmp/chromedriver-linux64/chromedriver
mv chromedriver-tmp/chromedriver-linux64/chromedriver /usr/local/bin/

# Cleanup
rm -rf chromedriver.zip chromedriver-tmp

# Verify installation
echo "ChromeDriver installed: $(chromedriver --version)"