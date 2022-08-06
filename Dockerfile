FROM alpine:latest

MAINTAINER Paul Novarese <pvn@novarese.net>
LABEL maintainer="pvn@novarese.net"
LABEL name="anchore-tools"
LABEL org.opencontainers.image.title="anchore-tools"
LABEL org.opencontainers.image.description="anchore command line scanning tools (syft, grype, anchore-cli, and anchorectl)"

HEALTHCHECK --timeout=10s CMD /bin/true || exit 1

# Installing required packages
RUN apk add --no-cache --upgrade \
    vim \
    curl \
    wget \
    grep \
    python3 \
    jq \
    bash \
    bash-completion \
    && python3 -m ensurepip \
    && pip3 install anchorecli \
    && curl https://anchorectl-releases.s3-us-west-2.amazonaws.com/v0.2.0/anchorectl_0.2.0_linux_amd64.tar.gz | tar xzvf - -C /usr/local/bin/ 
    ### don't really need these
    ### && curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin \
    ### && curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin 

# Setting WORKDIR and USER 
USER nobody 
WORKDIR /tmp

CMD ["/bin/bash"]
