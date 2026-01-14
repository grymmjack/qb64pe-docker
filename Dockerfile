# Multi-stage build for QB64PE compiler
FROM debian:12-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    make \
    x11-utils \
    mesa-common-dev \
    libglu1-mesa-dev \
    libasound2-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone QB64PE repository
WORKDIR /build
ARG QB64PE_VERSION=v4.3.0
RUN git clone --depth 1 --branch ${QB64PE_VERSION} https://github.com/QB64-Phoenix-Edition/QB64pe.git qb64pe

# Build QB64PE
WORKDIR /build/qb64pe
RUN make clean OS=lnx && \
    make OS=lnx BUILD_QB64=y -j$(nproc)

# Final runtime image
FROM debian:12-slim

# Re-declare ARG for use in this stage
ARG QB64PE_VERSION=v4.3.0

# Install runtime dependencies AND build tools
# QB64PE compiles user BASIC code to C++, then compiles that C++ to executables
# So we need the C++ compiler AND development headers in the runtime image
RUN apt-get update && apt-get install -y \
    build-essential \
    mesa-common-dev \
    libglu1-mesa-dev \
    libasound2-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    libglu1-mesa \
    libasound2 \
    libpng16-16 \
    libcurl4 \
    libx11-6 \
    libxcb1 \
    libgl1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy QB64PE from builder
COPY --from=builder /build/qb64pe /opt/qb64pe

# Set up environment
ENV PATH="/opt/qb64pe:${PATH}"
ENV QB64PE_HOME="/opt/qb64pe"

# Create working directory for user code
WORKDIR /workspace

# Default entrypoint - run qb64pe compiler
ENTRYPOINT ["/opt/qb64pe/qb64pe"]
CMD ["--help"]

# Labels
LABEL org.opencontainers.image.title="QB64PE Compiler"
LABEL org.opencontainers.image.description="QB64 Phoenix Edition compiler in a Docker container"
LABEL org.opencontainers.image.source="https://github.com/QB64-Phoenix-Edition/QB64pe"
LABEL org.opencontainers.image.version="${QB64PE_VERSION}"
