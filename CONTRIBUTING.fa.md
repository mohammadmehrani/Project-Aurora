# مشارکت در پروژه آرورا

از مشارکت شما در پروژه آرورا سپاسگزاریم! این سند راهنمایی‌هایی برای مشارکت‌های مؤثر ارائه می‌دهد.

## نحوه مشارکت

۱. **Fork** کردن مخزن
۲. **Clone** کردن fork در سیستم محلی
۳. **ایجاد شعبه** از `dev`:
   ```bash
   git checkout -b feature/نام-ویژگی-شما
   ```
۴. **ایجاد تغییرات** مطابق با استانداردهای ما:
   - Terraform: فرمت با `terraform fmt -recursive`
   - Ansible: استفاده از YAML linting (`yamllint`)
   - بدون رمز ثابت در کد — از متغیرها یا Key Vault استفاده کنید
   - اضافه کردن tags معنی‌دار به همه منابع Azure
۵. **اجرای چک‌های امنیتی**:
   ```bash
   make security-check
   ```
۶. **کامیت** با پیام‌های conventional commit:
   ```
   feat: اضافه کردن ماژول Application Gateway WAF
   fix: رفع تعارض priority در NSG
   docs: به‌روزرسانی دیاگرام معماری
   ```
۷. **Push و ایجاد PR** به شعبه `dev`

## workflow توسعه

```bash
# نصب pre-commit hooks
pip install pre-commit && pre-commit install

# تست محلی
make init-local
make plan ENVIRONMENT=dev
make validate
```

## چک‌لیست بازبینی کد

- [ ] `terraform fmt` پاس می‌شود
- [ ] هیچ رمز ثابت یا پسوردی در کد نیست
- [ ] همه منابع با `local.common_tags` برچسب خورده‌اند
- [ ] متغیرها دارای توضیحات و type هستند
- [ ] سازگار با عقب (یا تغییرات breaking مستند شده)
- [ ] قوانین امنیتی از اصل کمترین دسترسی پیروی می‌کنند
- [ ] ماژول‌های جدید دارای `main.tf`، `variable.tf` و `outputs.tf` هستند

## سؤال؟

یک issue برای بحث باز کنید.
