# === Stage 1: Install Node.js Dependencies ===
FROM node:18 AS node-base
WORKDIR /app
COPY package*.json ./
RUN npm install

# === Stage 2: Install Python Dependencies ===
FROM python:3.12 AS python-base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Tambahkan Rust toolchain
RUN apt-get update && apt-get install -y curl
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# === Stage 3: Final Image with Both Environments ===
FROM python:3.12
WORKDIR /app

# Copy semua file dari stage sebelumnya
COPY --from=node-base /app/node_modules /app/node_modules
COPY --from=python-base /app /app

# Copy seluruh project ke container
COPY . .

# Beri izin eksekusi ke setup.sh
RUN chmod +x setup.sh

# Jalankan setup.sh untuk install Chrome & ChromeDriver
RUN ./setup.sh

# Jalankan kedua aplikasi secara bersamaan
CMD ["sh", "-c", "uvicorn app:app --host 0.0.0.0 --port 8000 & node server.js"]
