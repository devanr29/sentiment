# Gunakan image Python 3.12
FROM python:3.12-slim

# ======== Instal dependensi sistem ========
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    gnupg \          
    && rm -rf /var/lib/apt/lists/*

# ======== Instal Chrome & Chromedriver (cara modern) ========
# Install Google Chrome
RUN mkdir -p /etc/apt/keyrings && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable

# Install ChromeDriver (versi yang sesuai dengan Chrome)
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1) && \
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    wget -q "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# ======== Setup direktori kerja ========
WORKDIR /app
COPY . .

# ======== Install dependensi Python ========
RUN pip install --no-cache-dir -r requirements.txt

# ======== Expose port & jalankan app ========
EXPOSE 3000

# Perintah untuk menjalankan server
CMD ["python", "server.js"]