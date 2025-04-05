#!/bin/bash
set -e

echo "🔧 Setting up ChromeDriver..."

# Get installed Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
echo "📦 Installed Chrome version: $CHROME_VERSION"

# Download ChromeDriver (Chrome for Testing channel)
curl -fSL "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_VERSION}/linux64/chromedriver-linux64.zip" -o /tmp/chromedriver.zip

# Extract
unzip -q /tmp/chromedriver.zip -d /tmp/chromedriver

# Move chromedriver to PATH
CHROMEDRIVER_PATH="/tmp/chromedriver/chromedriver-linux64/chromedriver"
echo "🔍 Detected chromedriver path: $CHROMEDRIVER_PATH"

if [ -f "$CHROMEDRIVER_PATH" ]; then
    cp "$CHROMEDRIVER_PATH" /usr/local/bin/chromedriver
    chmod +x /usr/local/bin/chromedriver
    echo "✅ ChromeDriver installed: $(chromedriver --version)"
else
    echo "❌ ChromeDriver not found!"
    exit 1
fi
