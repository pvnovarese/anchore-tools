FROM alpine:latest

MAINTAINER Paul Novarese <pvn@novarese.net>
LABEL maintainer="pvn@novarese.net"
LABEL name="anchore-tools"
LABEL org.opencontainers.image.title="anchore-tools"
LABEL org.opencontainers.image.description="anchore command line scanning tools (syft, grype, anchore-cli, and anchorectl)"

HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

# Installing required packages
RUN apk add --no-cache --upgrade \
    curl \
    wget \
    grep \
    python3 \
    jq \
    bash \
    bash-completion \
    git \
    openssh-client \
    && python3 -m ensurepip \
    && pip3 install anchorecli \
    && curl -sSfL https://anchorectl-releases.anchore.io/anchorectl/install.sh | sh -s -- -b /usr/local/bin v1.0.0 \
    && curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin v0.55.0 \
    && curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin v0.48.0 \
    && addgroup -g 1000 anchore \
    && adduser -u 1000 -G anchore --shell /bin/sh -D anchore 
    

# ensure we have a unique build and also provide a little metadata
RUN date > /image_build_timestamp && \
    touch image_build_timestamp_$(date +%Y-%m-%d_%T)
    
# Setting WORKDIR and USER 
USER anchore 
WORKDIR /home/anchore

CMD ["/bin/bash"]
