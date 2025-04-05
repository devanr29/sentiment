FROM python:3.12.5
# Gunakan image resmi untuk menjalankan Node.js dan Python
FROM node:18 AS node-base

# Set working directory
WORKDIR /app

# Copy semua file ke dalam container
COPY . .

# Install dependencies untuk Python
RUN pip install --no-cache-dir -r requirements.txt

# Install dependencies untuk Node.js
RUN npm install

# Beri izin eksekusi ke setup.sh
RUN chmod +x setup.sh

# Jalankan setup.sh untuk install Chrome & ChromeDriver
RUN ./setup.sh

# Jalankan kedua aplikasi secara bersamaan
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port 8000 & node server.js"]
