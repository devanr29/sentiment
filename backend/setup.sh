#!/bin/bash
set -e  # Exit immediately on error

# Install dependencies tanpa interaksi
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    --no-install-recommends

# Install Google Chrome (method alternatif)
curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o chrome.deb
apt-get install -y ./chrome.deb
rm -f chrome.deb

# Setup ChromeDriver
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
CHROMEDRIVER_VERSION=$(curl -fsSL "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION%.*}")
curl -fsSL "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" -o chromedriver.zip
unzip -q chromedriver.zip
chmod +x chromedriver
mv chromedriver /usr/local/bin/
rm -f chromedriver.zip

# Verifikasi
echo "Chrome version: $(google-chrome --version)"
echo "ChromeDriver version: $(chromedriver --version)"