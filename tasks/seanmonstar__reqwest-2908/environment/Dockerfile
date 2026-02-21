FROM ubuntu:24.04

# Base system packages (common to all languages)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    patch \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add wasm32-unknown-unknown target for WASM tests
RUN rustup target add wasm32-unknown-unknown

# Install wasm-pack for running WASM tests
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Install Chrome for wasm-pack tests (headless mode)
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone repo at HEAD commit (with fix applied)
RUN git clone https://github.com/seanmonstar/reqwest.git src && \
    cd src && \
    (git fetch --depth 1 origin 2fee8aa0b63383dfc0de4a044baa07ff14f1583e || git fetch --depth 1 origin "+refs/pull/2908/head:refs/remotes/origin/pr/2908") && \
    git checkout --detach FETCH_HEAD && \
    git submodule update --init --recursive

WORKDIR /app/src

# TODO: Set environment variables if needed
# Check CI config and README for required env vars
# Examples: CI=true, NODE_ENV=test, CARGO_TERM_COLOR=never

# TODO: Install dependencies
# For Python: PREFER uv (much faster). Create venv and install:
#   uv venv /opt/venv
#   uv pip install --python /opt/venv/bin/python -e ".[dev,test]"
#   # Or: uv pip install --python /opt/venv/bin/python -r requirements.txt
#   # Then add to PATH: ENV PATH="/opt/venv/bin:${PATH}"
# For Node.js: npm ci, yarn install --frozen-lockfile, pnpm install --frozen-lockfile
# For Go: go mod download
# For Rust: cargo fetch
# For Ruby: bundle install
# For Java: mvn dependency:resolve or gradle dependencies

# TODO: Build if needed (check if it's a compiled language or has build step)
# Examples:
#   TypeScript: npm run build, tsc
#   Rust: cargo build
#   Go: go build ./...
#   Java: mvn compile, gradle build

# If install/build steps touched tracked files, reset them so bug.patch applies cleanly,
RUN git reset --hard

# Apply bug.patch to revert to buggy state (BASE)
COPY bug.patch /tmp/bug.patch
RUN patch -p1 < /tmp/bug.patch && rm /tmp/bug.patch

# TODO: Rebuild after applying bug.patch if needed
# For compiled languages (TypeScript, Rust, Go, Java), you MUST rebuild after patching

RUN rm -rf /app/src/.git

WORKDIR /app/src
