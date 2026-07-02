# پروژه آرورا — خودکارسازی زیرساخت ابری Azure

[![CI/CD Pipeline](https://github.com/mohammadmehrani/Project-Aurora/actions/workflows/main.yml/badge.svg)](https://github.com/mohammadmehrani/Project-Aurora/actions/workflows/main.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-≥_1.6-844FBA.svg)](https://www.terraform.io)
[![Azure](https://img.shields.io/badge/Azure-Infrastructure-0078D4.svg)](https://azure.microsoft.com)

زیرساخت به‌عنوان کد (IaC) در سطح تولید برای استقرار یک زیرساخت وب مقاوم، خود-متغیر (auto-scaling) و کاملاً مانیتورشده روی **Microsoft Azure**.

---

## معماری

```
Azure Front Door (CDN + WAF)
       │
       ▼
Azure Application Gateway (SSL/TLS, WAF v2)
       │
       ▼
Azure Load Balancer (Standard, HA)
       │
       ▼
┌─────────────────────────────────┐
│  VM Scale Set  (Ubuntu 24.04)  │
│  خود-متغیر: ۱ تا ۱۰ نمونه      │
│  Premium SSD, health probes    │
└─────────────────────────────────┘
       │
       ├── Azure Monitor (Metrics, Logs, Alerts)
       ├── Azure Key Vault (Secrets, SSH keys)
       ├── Azure Bastion (دسترسی امن مدیریتی)
       ├── Azure Backup (پشتیبان‌گیری روزانه)
       └── Log Analytics + App Insights
```

## ویژگی‌های کلیدی

| ویژگی | پیاده‌سازی |
|---|---|
| **زیرساخت به‌عنوان کد** | Terraform با ماژول‌های قابل استفاده مجدد |
| **مدیریت پیکربندی** | Ansible — نصب و پیکربندی Nginx، امن‌سازی |
| **CI/CD** | GitHub Actions — اسکن امنیتی، plan، استقرار چند-محیطی |
| **خود-متغیر (Auto-scaling)** | scale-out (>۷۵٪ CPU) و scale-in (<۳۰٪ CPU)، ۱ تا ۱۰ نمونه |
| **دسترسی بالا** | Load Balancer، health probes، fault domains |
| **امنیت** | احراز هویت SSH، Key Vault، NSG با کمترین دسترسی |
| **مانیتورینگ** | Azure Monitor، Application Insights، Log Analytics، آلرت |
| **پشتیبان و DR** | Recovery Services Vault، پشتیبان روزانه با نگهداری ماهانه/سالیانه |
| **دسترسی امن** | Azure Bastion — بدون IP عمومی روی VMs |
| **رمزنگاری** | رمزنگاری دوگانه زیرساخت، TLS 1.2+، HTTPS-only |
| **چند-محیطی** | Dev → Staging → Production با تأیید دستی |

## تکنولوژی‌ها

| تکنولوژی | کاربرد | ورژن |
|---|---|---|
| **Terraform** | فراهم‌سازی منابع ابری | ≥ ۱.۶ |
| **Ansible** | مدیریت پیکربندی | آخرین نسخه |
| **Azure** | ارائه‌دهنده ابر | — |
| **Ubuntu** | سیستم‌عامل VM | ۲۴.۰۴ LTS |
| **Nginx** | وب سرور | آخرین نسخه پایدار |
| **GitHub Actions** | CI/CD | — |

## شروع سریع

### پیش‌نیازها

- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ ۱.۶
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- اشتراک Azure با دسترسی [Owner](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#owner) یا [Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor)

### ۱. احراز هویت به Azure

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

### ۲. ایجاد بک‌اند狀態 Terraform

```bash
az group create --name Project-Aurora-tfstate --location "UK South"
az storage account create --name projectauroratfstate --resource-group Project-Aurora-tfstate --sku Standard_LRS --allow-blob-public-access false
az storage container create --name tfstate --account-name projectauroratfstate
```

### ۳. استقرار

```bash
make init
make plan ENVIRONMENT=dev
make apply ENVIRONMENT=dev
```

یا مرحله به مرحله:

```bash
cd terraform
terraform init
TF_VAR_environment=dev TF_VAR_branch_name=$(git rev-parse --abbrev-ref HEAD) terraform plan
TF_VAR_environment=dev TF_VAR_branch_name=$(git rev-parse --abbrev-ref HEAD) terraform apply
```

### ۴. دسترسی

بعد از استقرار، IP عمومی Load Balancer به عنوان خروجی نمایش داده می‌شود:

```bash
make output
```

در مرورگر به آدرس `http://<LOAD_BALANCER_IP>` بروید.

## ساختار پروژه

```
├── .github/workflows/        # CI/CD (اسکن امنیتی، plan، apply)
├── ansible/
│   ├── setup.sh              # اسکریپت بوت‌استرپ VM
│   ├── playbooks/
│   │   ├── install-nginx.yml # playbook اصلی
│   │   └── roles/nginx-setup/
│   │       ├── tasks/        # تسک‌های نقش
│   │       ├── handlers/     # مدیریت سرویس‌ها
│   │       └── templates/    # قالب‌های Jinja2
├── terraform/
│   ├── main.tf               # پیکربندی ریشه
│   ├── providers.tf          # پیکربندی provider + backend
│   ├── variables.tf          # متغیرهای ورودی
│   ├── outputs.tf            # مقادیر خروجی
│   ├── locals.tf             # مقادیر محلی + tags
│   └── modules/
│       ├── resource_group/   # Resource Group
│       ├── vnet_and_subnet/  # شبکه مجازی + زیرشبکه‌ها
│       ├── nsg/              # NSG
│       ├── storage_account/  # ذخیره‌ساز رمزنگاری‌شده
│       ├── key_vault/        # مدیریت اسرار
│       ├── lb_and_pip/       # Load Balancer + IP عمومی
│       ├── vmss/             # VM Scale Set (خود-متغیر)
│       ├── vmss_extension/   # افزونه‌های VM
│       ├── bastion/          # Azure Bastion
│       ├── monitoring/       # Log Analytics، App Insights، آلرت
│       └── backup/           # Recovery Services Vault
├── Makefile                  # خودکارسازی توسعه‌دهنده
├── .pre-commit-config.yaml   # Pre-commit hooks
├── .tflint.hcl               # تنظیمات TFLint
├── README.md                 # مستندات انگلیسی
├── README.fa.md              # مستندات فارسی
└── CONTRIBUTING.md
```

## محیط‌ها

| محیط | شعبه فعال‌ساز | تأیید | کاربرد |
|---|---|---|---|
| **dev** | `dev`, `main`, `feature/*` | خیر | توسعه و تست |
| **staging** | `main` | خیر | اعتبارسنجی پیش-تولید |
| **production** | `main` (tag) | **دستی** | بارکاری واقعی |

## امنیت

- **بدون رمز ثابت در کد** — همه رمزها در حال اجرا تولید یا در Key Vault ذخیره می‌شوند
- **احراز هویت SSH** — رمز عبور روی همه VMs غیرفعال است
- **جداسازی شبکه** — هیچ IP عمومی روی VMs وجود ندارد؛ دسترسی فقط از طریق Bastion
- **رمزنگاری در حالت استراحت** — رمزنگاری دوگانه زیرساخت روی ذخیره‌ساز
- **رمزنگاری در حال انتقال** — TLS 1.2+ اجباری، HTTPS-only
- **اسکن امنیتی** — Checkov + Trivy روی هر commit
- **RBAC** — Key Vault با Azure RBAC؛ قوانین NSG با کمترین دسترسی

## مانیتورینگ و آلرت‌ها

| آلرت | شرط | اقدام |
|---|---|---|
| CPU بالا | > ۸۰٪ به مدت ۵ دقیقه | ایمیل |
| CPU پایین | < ۲۰٪ به مدت ۵ دقیقه | ایمیل (تشخیص بیکاری) |
| میزبان ناسالم | هر VM ناسالم | ایمیل |
| رویدادهای خود-متغیر | scale-in/out | ثبت در Log Analytics |

## بهینه‌سازی هزینه

| ویژگی | صرفه‌جویی |
|---|---|
| **خود-متغیر** | مقیاس به ۱ نمونه در ترافیک کم |
| **Premium SSD** | فقط برای دیسک سیستم (۶۴ GB) |
| **Reserved instances** | توصیه برای تعهد ۱+ ساله |
| **توسعه/تست** | استفاده از SKU کوچک‌تر (`Standard_B2s`) |
| **Azure Hybrid Benefit** | استفاده از لایسنس‌های موجود |

## مشارکت

لطفاً برای جزئیات workflow مشارکت به [CONTRIBUTING.md](CONTRIBUTING.md) مراجعه کنید.

## مجوز

تحت [MIT License](LICENSE) منتشر شده است.

## قدردانی

ساخته شده با ❤️ با استفاده از Terraform، Ansible و Azure. الهام گرفته از الگوهای زیرساخت تولید در مقیاس.
