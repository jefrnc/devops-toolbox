# Usa una imagen base de Ubuntu
FROM ubuntu:20.04

# Establece el entorno no interactivo para evitar problemas de instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza los repositorios y instala dependencias básicas
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Instala Python 3 y pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Instala AWS CLI
RUN pip3 install awscli --upgrade

# Instala herramientas de networking
RUN apt-get update && apt-get install -y \
    dnsutils \
    telnet \
    iputils-ping \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instala Ansible
RUN pip3 install ansible

# Instala Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update && apt-get install -y terraform

# Instala Tenv (assume it's a Python package)
RUN pip3 install tenv

# Instala Pulumi
RUN curl -fsSL https://get.pulumi.com | sh

# Instala GCP Tools
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y google-cloud-sdk

# Instala kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instala git
RUN apt-get update && apt-get install -y git

# Instala Helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && apt-get install -y apt-transport-https --no-install-recommends \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update && apt-get install -y helm

# Limpia los archivos de instalación para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /root

# Comando por defecto
CMD ["bash"]
