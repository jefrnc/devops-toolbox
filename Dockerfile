# Usa una imagen base de Ubuntu
FROM ubuntu:20.04

# Establece el entorno no interactivo para evitar problemas de instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza los repositorios y instala todas las dependencias básicas
RUN apt-get update && apt-get install -y \
    # Herramientas básicas
    curl \
    wget \
    unzip \
    zip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # Herramientas de red y debugging
    dnsutils \
    telnet \
    iputils-ping \
    netcat \
    traceroute \
    tcpdump \
    nmap \
    net-tools \
    iptables \
    iproute2 \
    openssh-client \
    # Herramientas de desarrollo
    git \
    vim \
    nano \
    jq \
    tree \
    htop \
    make \
    gcc \
    build-essential \
    # Clientes de bases de datos
    mysql-client \
    postgresql-client \
    redis-tools \
    # Otras utilidades
    less \
    file \
    sudo \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Instala herramientas de Python
RUN pip3 install --no-cache-dir \
    awscli \
    ansible \
    docker-compose \
    httpie

# Instala kubectl (detecta arquitectura)
RUN ARCH=$(dpkg --print-architecture) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Instala Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Instala Terraform manualmente (detecta arquitectura)
RUN ARCH=$(dpkg --print-architecture) && \
    TF_VERSION="1.5.7" && \
    wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_${ARCH}.zip && \
    unzip terraform_${TF_VERSION}_linux_${ARCH}.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TF_VERSION}_linux_${ARCH}.zip

# Instala herramientas adicionales de Kubernetes
RUN cd /tmp && \
    curl -LO https://github.com/ahmetb/kubectx/releases/latest/download/kubectx && \
    curl -LO https://github.com/ahmetb/kubectx/releases/latest/download/kubens && \
    chmod +x kubectx kubens && \
    mv kubectx kubens /usr/local/bin/

# Instala Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# Instala Azure CLI (método universal)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash || echo "Azure CLI installation failed - continuing"

# Instala Google Cloud SDK (método simplificado)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
        apt-get update && apt-get install -y google-cloud-cli && \
        rm -rf /var/lib/apt/lists/*; \
    else \
        echo "Google Cloud SDK not available for $ARCH - skipping"; \
    fi

# Instala yq manualmente
RUN ARCH=$(dpkg --print-architecture) && \
    YQ_VERSION="v4.35.1" && \
    if [ "$ARCH" = "arm64" ]; then YQ_ARCH="arm64"; else YQ_ARCH="amd64"; fi && \
    wget -q https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${YQ_ARCH} -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Configura alias útiles
RUN echo 'alias k=kubectl' >> /root/.bashrc && \
    echo 'alias tf=terraform' >> /root/.bashrc && \
    echo 'alias d=docker' >> /root/.bashrc && \
    echo 'alias dc=docker-compose' >> /root/.bashrc && \
    echo 'alias ll="ls -la"' >> /root/.bashrc

# Limpia los archivos de instalación
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Establece el directorio de trabajo
WORKDIR /root

# Comando por defecto
CMD ["bash"]