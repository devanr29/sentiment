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

# Download ChromeDriver (using -O to specify output filename)
mkdir -p chromedriver
curl -fSL "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VERSION/linux64/chromedriver-linux64.zip" -o chromedriver.zip

# Forcefully unzip without prompts
unzip -q -o chromedriver.zip -d chromedriver/
chmod +x chromedriver/chromedriver
mv chromedriver/chromedriver /usr/local/bin/

# Cleanup
rm -rf chromedriver.zip chromedriver/

# Verify
echo "ChromeDriver installed: $(chromedriver --version)"