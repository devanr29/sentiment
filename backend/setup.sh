#!/bin/bash

# Install Chrome and ChromeDriver for Railway
echo "Setting up Chrome and ChromeDriver..."

# Install Chrome
if [ ! -f "/usr/bin/google-chrome" ]; then
    echo "Installing Google Chrome..."
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
    apt-get update -y
    apt-get install -y google-chrome-stable
fi

# Install ChromeDriver (matching Chrome version)
if [ ! -f "/usr/local/bin/chromedriver" ]; then
    echo "Installing ChromeDriver..."
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1)
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
    wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
    unzip chromedriver_linux64.zip
    mv chromedriver /usr/local/bin/
    chmod +x /usr/local/bin/chromedriver
    rm chromedriver_linux64.zip
fi

# Verify installations
google-chrome --version
chromedriver --version