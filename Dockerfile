# Use a lightweight base image
FROM --platform=$BUILDPLATFORM alpine:latest

# Set environment variables
ENV DNSCRYPT_PROXY_VERSION=2.0.45

# Install necessary packages
RUN apk add --no-cache \
    ca-certificates \
    curl \
    libsodium \
    && update-ca-certificates

# Download and install dnscrypt-proxy
RUN curl -Lo /tmp/dnscrypt-proxy.tar.gz "https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_$TARGETARCH-${DNSCRYPT_PROXY_VERSION}.tar.gz" \
    && tar -xzf /tmp/dnscrypt-proxy.tar.gz -C /tmp \
    && mv /tmp/$(tar -tf /tmp/dnscrypt-proxy.tar.gz | head -1 | cut -f1 -d"/") /usr/local/dnscrypt-proxy \
    && rm /tmp/dnscrypt-proxy.tar.gz

# Copy the configuration file
COPY dnscrypt-proxy.toml /usr/local/dnscrypt-proxy/dnscrypt-proxy.toml

# Expose the DNSCrypt port
EXPOSE 53/udp

# Set the working directory
WORKDIR /usr/local/dnscrypt-proxy

# Run dnscrypt-proxy
ENTRYPOINT ["./dnscrypt-proxy"]