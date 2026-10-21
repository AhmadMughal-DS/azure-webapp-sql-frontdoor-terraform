# Azure Web App + SQL + Front Door (Terraform)

> A web app on Azure App Service, backed by Azure SQL, published globally through Azure Front Door — provisioned with Terraform.
> **Author:** Muhammad Ahmad · **IaC:** Terraform · **Cloud:** Azure

![Terraform CI](https://github.com/AhmadMughal-DS/azure-webapp-sql-frontdoor-terraform/actions/workflows/terraform.yml/badge.svg)
![Terraform](https://img.shields.io/badge/Terraform-1.6%2B-7B42BC?logo=terraform&logoColor=white)
![Security](https://img.shields.io/badge/scanned-tfsec%20%7C%20checkov-success)
![Azure](https://img.shields.io/badge/Azure-App%20Service%20%7C%20SQL%20%7C%20Front%20Door-0078D4?logo=microsoftazure&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

- **App Service (Linux)** runs the web application on a dedicated plan.
- **Azure SQL** provides the managed relational database (TLS 1.2 enforced).
- **Azure Front Door (Standard)** gives a global, HTTPS-only entry point with health probes and caching in front of the app.

## 🏗️ Architecture

> 🎨 **Interactive diagram (industry-standard icons):** [open in Lucid — page 13](https://lucid.app/lucidchart/3da75ce3-ea66-4296-81b3-00d20a60435b/edit)

```mermaid
flowchart LR
    User([Global User])
    FD[Azure Front Door]
    App[App Service - Linux]
    SQL[(Azure SQL Database)]

    User -->|HTTPS| FD
    FD -->|origin| App
    App -->|TDS 1433| SQL
```

## 🚀 Deploy

```bash
cd terraform
az login
export TF_VAR_sql_admin_password='YourStr0ng!Passw0rd'
terraform init
terraform apply

terraform output frontdoor_endpoint
```

## 🧹 Clean up

```bash
terraform destroy
```

## 💰 Cost note

App Service (B1), Azure SQL (Basic), and Front Door Standard all bill while running. Destroy when done.

## 🔐 Production hardening (next steps)

- Store the DB password in **Key Vault** and reference it from App Service.
- Lock SQL to **Private Endpoint** instead of the Azure-services firewall rule.
- Add a **WAF policy** on Front Door.

---

*Built and maintained by **Muhammad Ahmad**.*
