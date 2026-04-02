# DevOps Toolbox 🛠️

Una imagen Docker todo-en-uno con las herramientas esenciales para DevOps, SRE y debugging en Kubernetes.

## 🚀 ¿Qué es esto?

DevOps Toolbox es una imagen Docker basada en Ubuntu que incluye todas las herramientas que un ingeniero DevOps/SRE necesita para:
- Debuggear aplicaciones en Kubernetes
- Gestionar infraestructura cloud
- Automatizar deployments
- Troubleshooting de redes y servicios

## 📦 Herramientas Incluidas

### ☁️ Cloud Providers
- **AWS CLI** - Gestión de recursos AWS
- **Google Cloud SDK** - Herramientas para GCP
- **Azure CLI** - Gestión de recursos Azure

### 🏗️ Infrastructure as Code
- **Terraform** - Provisioning de infraestructura
- **Tenv** - Gestor de versiones de Terraform
- **Pulumi** - IaC moderno con lenguajes de programación
- **Ansible** - Automatización y configuración

### 🐳 Container & Kubernetes
- **kubectl** - CLI de Kubernetes
- **Helm** - Gestor de paquetes para Kubernetes
- **k9s** - UI terminal para Kubernetes
- **kubectx/kubens** - Cambio rápido de contextos y namespaces
- **stern** - Logs multi-pod en tiempo real

### 🔍 Debugging & Networking
- **netcat, telnet** - Testing de conectividad
- **tcpdump** - Captura de paquetes
- **nmap** - Escaneo de redes
- **traceroute** - Traza de rutas
- **dnsutils** (dig, nslookup) - Debugging DNS
- **curl, wget** - Testing HTTP/HTTPS
- **ping** - Testing ICMP
- **iptables** - Debugging de reglas de firewall
- **net-tools, iproute2** - Herramientas de red

### 💾 Clientes de Bases de Datos
- **mysql-client** - Cliente MySQL
- **postgresql-client** - Cliente PostgreSQL
- **redis-tools** - Herramientas Redis
- **mongodb-clients** - Cliente MongoDB

### 🛠️ Utilidades Generales
- **git** - Control de versiones
- **vim, nano** - Editores de texto
- **jq** - Procesamiento de JSON
- **tree** - Visualización de directorios
- **htop** - Monitor de procesos
- **Python 3 + pip** - Scripting y herramientas Python
- **make, gcc** - Herramientas de compilación

## 🏃‍♂️ Uso Rápido

### Ejecutar la imagen
```bash
docker run -it --rm jefrnc/devops-toolbox:latest
```

### Con credenciales AWS
```bash
docker run -it --rm \
  -v ~/.aws:/root/.aws:ro \
  jefrnc/devops-toolbox:latest
```

### Con kubeconfig para Kubernetes
```bash
docker run -it --rm \
  -v ~/.kube:/root/.kube:ro \
  jefrnc/devops-toolbox:latest
```

### Con acceso a Docker del host
```bash
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jefrnc/devops-toolbox:latest
```

### Modo completo (todas las credenciales)
```bash
docker run -it --rm \
  -v ~/.aws:/root/.aws:ro \
  -v ~/.kube:/root/.kube:ro \
  -v ~/.gcloud:/root/.config/gcloud:ro \
  -v ~/.azure:/root/.azure:ro \
  jefrnc/devops-toolbox:latest
```

## 🎯 Casos de Uso

### Debugging en Kubernetes
```bash
# Ejecutar un pod temporal para debugging
kubectl run debug --image=jefrnc/devops-toolbox:latest -it --rm

# Dentro del pod, puedes usar todas las herramientas
nslookup mi-servicio
curl http://mi-servicio:8080/health
telnet redis-server 6379
```

### Testing de conectividad
```bash
# Verificar conectividad a base de datos
mysql -h mysql.ejemplo.com -u usuario -p

# Test de Redis
redis-cli -h redis.ejemplo.com ping

# Verificar puertos abiertos
nmap -p 80,443,8080 mi-servidor.com
```

### Análisis de red
```bash
# Capturar tráfico HTTP
tcpdump -i any -A 'tcp port 80'

# Ver rutas de red
traceroute google.com

# Debugging DNS
dig ejemplo.com
nslookup ejemplo.com
```

## 🔨 Construir la imagen localmente

```bash
git clone https://github.com/jefrnc/devops-toolbox
cd devops-toolbox
docker build -t devops-toolbox:local .
```

## 🤝 Contribuir

¿Falta alguna herramienta esencial? ¡Las PRs son bienvenidas!

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/nueva-herramienta`)
3. Commit tus cambios (`git commit -m 'Agregar nueva-herramienta'`)
4. Push al branch (`git push origin feature/nueva-herramienta`)
5. Abre un Pull Request

## ⭐ ¿Te sirvió?

Si esta herramienta te fue útil, no olvides darle una estrella al repositorio ⭐

## 📝 Licencia

Este proyecto está bajo la licencia MIT - mira el archivo [LICENSE](LICENSE) para más detalles.