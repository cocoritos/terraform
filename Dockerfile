FROM node:iron-alpine3.18

ARG TERRAFORM_VERSION=1.9.0

# Install base packages
RUN set -ex; \
    apk add --no-cache apache2-utils; \
    apk add --no-cache curl; \
    apk add --no-cache git; \
    apk add --no-cache jq; \
    apk add --no-cache openssh;

# Install services
RUN set -ex; \
    # set ARCH dynamically
    case "$(uname -m)" in \
        aarch64) ARCH=arm64 ;; \
        x86_64) ARCH=amd64 ;; \
        *) echo "Unsupported architecture"; exit 1 ;; \
    esac; \
    echo "Building for architecture: $ARCH"; \
    # terraform
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip -P /tmp/; \
    unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip -d /usr/local/bin/; \
    # cleaning
    rm -rf /tmp/*;
