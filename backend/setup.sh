#!/bin/bash
# Install Chrome dan ChromeDriver di Railway
apt-get update && apt-get install -y wget unzip google-chrome-stable
wget https://chromedriver.storage.googleapis.com/LATEST_RELEASE
wget https://chromedriver.storage.googleapis.com/`cat LATEST_RELEASE`/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
mv chromedriver /usr/bin/chromedriver
chmod +x /usr/bin/chromedriver