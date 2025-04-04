#!/bin/bash
set -ex  # Enable debugging and exit on error

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

# Download ChromeDriver
mkdir -p /tmp/chromedriver
curl -fSL "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/$CHROME_VERSION/linux64/chromedriver-linux64.zip" -o /tmp/chromedriver.zip
unzip -q /tmp/chromedriver.zip -d /tmp/chromedriver

# Install ChromeDriver
install -o root -g root -m 0755 /tmp/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

# Verify installation
if ! command -v chromedriver &> /dev/null; then
    echo "ChromeDriver installation failed!"
    echo "Searching for chromedriver in /tmp:"
    find /tmp -name chromedriver
    exit 1
fi

echo "ChromeDriver successfully installed: $(chromedriver --version)"
echo "ChromeDriver path: $(which chromedriver)"