FROM alpine

LABEL sh.demyx.image demyx/browsersync
LABEL sh.demyx.maintainer Demyx <info@demyx.sh>
LABEL sh.demyx.url https://demyx.sh
LABEL sh.demyx.github https://github.com/demyxco
LABEL sh.demyx.registry https://hub.docker.com/u/demyx

# Set default variables
ENV BROWSERSYNC_ROOT /demyx
ENV BROWSERSYNC_CONFIG /etc/demyx
ENV BROWSERSYNC_LOG /var/log/demyx
ENV TZ America/Los_Angeles

# Configure Demyx
RUN set -ex; \
    addgroup -g 1000 -S demyx; \
    adduser -u 1000 -D -S -G demyx demyx; \
    \
    install -d -m 0755 -o demyx -g demyx "$BROWSERSYNC_ROOT"; \
    install -d -m 0755 -o demyx -g demyx "$BROWSERSYNC_CONFIG"; \
    install -d -m 0755 -o demyx -g demyx "$BROWSERSYNC_LOG"

# Install main packages
RUN set -ex; \
    apk add --update --no-cache bash dumb-init npm; \
    npm -g install browser-sync
    
# Copy the sauce
COPY src "$BROWSERSYNC_CONFIG"

# Finalize
RUN set -ex; \
    mv "$BROWSERSYNC_CONFIG"/entrypoint.sh /usr/local/bin/demyx; \
    chmod +x /usr/local/bin/demyx

WORKDIR "$BROWSERSYNC_ROOT"

EXPOSE 3000

USER demyx

ENTRYPOINT ["demyx"]
