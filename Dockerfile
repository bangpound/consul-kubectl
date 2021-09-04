FROM hashicorp/consul:1.10.2

RUN mkdir -p /opt/kubectl/bin && cd /opt/kubectl/bin/ && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && chmod +x kubectl
