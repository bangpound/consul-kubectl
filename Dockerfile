FROM hashicorp/consul:1.10.2

# curl -L -s https://dl.k8s.io/release/stable.txt
ARG KUBECTL_VERSION="v1.20.7"

RUN mkdir -p /opt/kubectl/bin && cd /opt/kubectl/bin/ && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && chmod +x kubectl
