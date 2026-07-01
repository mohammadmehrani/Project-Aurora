# Contributing to Project Aurora

Thank you for contributing to Project Aurora! This document provides guidelines for making impactful contributions.

## How to Contribute

1. **Fork** the repository
2. **Clone** your fork locally
3. **Create a branch** from `dev`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make changes** following our standards:
   - Terraform: Format with `terraform fmt -recursive`
   - Ansible: Use YAML linting (`yamllint`)
   - No hardcoded secrets — use variables or Key Vault
   - Add meaningful tags to all Azure resources
5. **Run security checks**:
   ```bash
   make security-check
   ```
6. **Commit** using conventional commit messages:
   ```
   feat: add Application Gateway WAF module
   fix: correct NSG rule priority conflict
   docs: update architecture diagram
   ```
7. **Push and create a PR** to the `dev` branch

## Development Workflow

```bash
# Install pre-commit hooks
pip install pre-commit && pre-commit install

# Test locally
make init-local
make plan ENVIRONMENT=dev
make validate
```

## Code Review Checklist

- [ ] Terraform `fmt` passes
- [ ] No hardcoded secrets or passwords
- [ ] All resources tagged with `local.common_tags`
- [ ] Variables have descriptions and types
- [ ] Backward compatible (or documented breaking changes)
- [ ] Security rules follow least-privilege principle
- [ ] New modules have `main.tf`, `variable.tf`, and `outputs.tf`

## Questions?

Open an issue for discussion.
