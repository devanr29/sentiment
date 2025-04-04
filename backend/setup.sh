#!/bin/bash
# Install dependencies
apt-get update && apt-get install -y wget unzip gnupg curl

# Install Google Chrome
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get -y update && apt-get -y install google-chrome-stable

# Get matching ChromeDriver version
CHROME_MAJOR_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1)
CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_MAJOR_VERSION")

# Install ChromeDriver
mkdir -p /tmp/chromedriver
curl -sS -o /tmp/chromedriver/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
unzip /tmp/chromedriver/chromedriver.zip -d /tmp/chromedriver
mv /tmp/chromedriver/chromedriver /usr/local/bin/
chmod +x /usr/local/bin/chromedriver

# Verify installation
google-chrome --version
chromedriver --version