# 🚀 Terraform-Docker-EC2 AutoDeploy: End-to-End DevSecOps Pipeline

---

## 📌 Project Title

**Automated DevSecOps Pipeline for Dockerized Application Deployment on AWS EC2 using Terraform, Jenkins, Prometheus, Grafana, Trivy & Slack**

---

## 🧩 Problem Statement

Modern application deployments often suffer from:

- Manual infrastructure provisioning
- Inconsistent deployment workflows
- Lack of security scanning before release
- No real-time monitoring or alerting
- No centralized visibility into system or container health
- Delayed incident detection

These gaps increase operational risk, reduce deployment speed, and compromise security posture.

This project addresses those challenges by building a fully automated, secure, and observable CI/CD pipeline using industry-standard DevOps tools.

---

## 🎯 Project Objective

The objective of this project is to design and implement a complete DevSecOps pipeline that:

- Provisions infrastructure using Infrastructure as Code (IaC)
- Builds and deploys Dockerized applications automatically
- Performs automated code quality checks
- Conducts container vulnerability scanning
- Deploys application to AWS EC2 automatically
- Monitors system & container metrics in real-time
- Triggers alerts to Slack when threshold conditions are breached
- Ensures security, reliability, and observability across the deployment lifecycle

---

## 🛠 Tools & Technologies Used

### ☁ Cloud & Infrastructure
- AWS EC2
- Terraform (Infrastructure as Code)

### 🐳 Containerization
- Docker
- Docker Compose
- cAdvisor (Container metrics)

### 🔁 CI/CD
- Jenkins (Pipeline as Code)
- GitHub Webhooks
- Declarative Jenkinsfile

### 🔍 Code Quality & Security
- SonarQube (Static Code Analysis)
- Trivy (Container vulnerability scanning)

### 📊 Monitoring & Observability
- Prometheus
- Node Exporter
- Grafana
- Slack (Alert Notifications)

### 💻 Application
- Nginx (Dockerized)
- Custom HTML Login UI

---

## 🏗 System Architecture


Developer → GitHub → Webhook → Jenkins Pipeline
↓
SonarQube Analysis
↓
Docker Build
↓
Trivy Security Scan
↓
Docker Deployment on EC2
↓
Prometheus ← Node Exporter + cAdvisor
↓
Grafana Dashboard
↓
Slack Alert Notification


The architecture ensures automation, security validation, and real-time monitoring in a continuous loop.

---

## 🔄 CI/CD Pipeline Flow

1. Developer pushes code to GitHub.
2. GitHub webhook triggers Jenkins pipeline automatically.
3. Jenkins performs:
   - Code checkout
   - SonarQube analysis (Quality Gate validation)
   - Docker image build
   - Trivy security scan (HIGH & CRITICAL vulnerabilities)
4. If checks pass:
   - Existing container is stopped & removed
   - New container is deployed automatically
5. Slack notifies build status.

This enables zero-manual deployment with full validation before release.

---

## 🚀 Deployment Strategy

- Infrastructure provisioned via Terraform
- Immutable Docker image builds
- Container redeployment using:

docker stop → docker rm → docker run

- Restart policy: `--restart unless-stopped`
- Fully automated after GitHub push
- No manual SSH-based deployment

This ensures consistency and repeatability across deployments.

---

## 🔐 Security & Best Practices

- Infrastructure as Code (Version controlled)
- SonarQube Quality Gate enforcement
- Trivy container vulnerability scanning
- Slack build status notifications
- Monitoring & Alerting enabled
- CPU alert rule (>80%) configured
- Minimal manual intervention
- Secure key-based SSH access
- Separation of monitoring components

Security scanning is integrated directly into CI/CD, shifting security left.

---

## 🧠 Monitoring & Alerting

### Metrics Collected

- CPU Usage
- Memory Usage
- Disk Utilization
- Network Traffic
- Container-level metrics

### Monitoring Stack

- Prometheus scrapes:
- Node Exporter (Host metrics)
- cAdvisor (Container metrics)

- Grafana dashboards:
- Node Exporter Full Dashboard
- Real-time container metrics

### Alerting

- CPU > 80% threshold
- Evaluated every 1 minute
- Slack notification triggered automatically
- Alert auto-resolves when threshold drops

This ensures proactive infrastructure health monitoring.

---

## ⚠ Challenges & Solutions

### 1. Trivy Causing Pipeline Lag
**Issue:** EC2 root volume ran out of space during vulnerability database download.  
**Solution:** Increased EC2 root volume size and resized filesystem.

### 2. Prometheus Targets Showing DOWN
**Issue:** Incorrect scrape target (localhost instead of container name).  
**Solution:** Updated `prometheus.yml` to use:

node-exporter:9100
cadvisor:8080


### 3. Alert Not Triggering
**Issue:** Slack webhook incorrectly added in Runbook URL field.  
**Solution:** Created proper Slack Contact Point in Grafana.

### 4. Docker Redeployment Conflicts
**Issue:** Container name conflicts.  
**Solution:** Added safe stop & remove logic with fallback handling.

---

## 📈 Impact & Results

- 100% automated CI/CD pipeline
- Integrated DevSecOps workflow
- Zero-manual deployment after push
- Real-time infrastructure observability
- Security scanning before deployment
- Instant Slack alerts for system anomalies
- Reduced operational overhead
- Improved deployment reliability

Pipeline execution time: ~1 minute  
Alert trigger latency: <1 minute  

---

## 🔮 Future Scope

- Kubernetes deployment (EKS / self-managed cluster)
- Helm-based application packaging
- Auto-scaling integration
- Blue-Green or Canary deployment strategy
- Centralized logging (ELK Stack)
- Alertmanager advanced routing
- Multi-environment support (Dev / Stage / Prod)

---

## 🏁 Conclusion

This project demonstrates the implementation of a production-grade DevSecOps pipeline that integrates infrastructure provisioning, automated deployment, security validation, monitoring, and alerting into a single cohesive workflow.

It reflects practical, hands-on implementation of modern DevOps principles and cloud-native best practices.

---
