# Stage 1: Python 3.12 base image + Rust for packages like tokenizers
FROM python:3.12-slim AS python-base

WORKDIR /app

# Install Rust and build tools + Chrome dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    gcc \
    git \
    unzip \
    wget \
    libglib2.0-0 \
    libnss3 \
    libgconf-2-4 \
    libfontconfig1 \
    libxss1 \
    libappindicator1 \
    libasound2 \
    fonts-liberation \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cargo/bin:${PATH}"

# Copy setup.sh and run it
COPY setup.sh .
RUN chmod +x setup.sh && ./setup.sh

# Copy Python requirements and install
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Node.js runtime + copy Python environment
FROM node:18

WORKDIR /app

COPY . .

# Copy Python environment from the previous stage
COPY --from=python-base /usr/local /usr/local
COPY --from=python-base /root/.cargo /root/.cargo
ENV PATH="/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.cargo/bin"

# Install Node.js dependencies
RUN npm install

# Start server
CMD ["node", "server.js"]
