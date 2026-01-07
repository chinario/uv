# GitHub Actions Configuration Guide for Your Fork

This guide explains how to adapt the GitHub Actions workflows from the original `astral-sh/uv` repository to work with your fork.

## Key Workflows That May Need Modification

### 1. Conditional Execution

Several workflows contain conditions that restrict execution to the official repository:

- **sync-python-releases.yml**: Line 14 - `if: github.repository == 'astral-sh/uv'`
- **ci.yml**: Multiple lines (1818, 2924, 2964) - `if: github.repository == 'astral-sh/uv'`
- **build-docker.yml**: Line 59 - `IS_LOCAL_PR: ${{ github.event.pull_request.head.repo.full_name == 'astral-sh/uv' }}`

**Solution:** Modify these conditions to include your repository:
```yaml
if: github.repository == 'astral-sh/uv' || github.repository == 'chinario/uv'
```

### 2. Additional Repository-Specific Changes

In **build-docker.yml**, you may need to update:
- Line 147: Project identifier for your repository if using Depot
- Line 296: Project identifier for your repository if using Depot
- Docker image names if you want to customize them for your fork (UV_DOCKERHUB_IMAGE in the env section)

### 3. Publishing Workflows

For publishing workflows to work with your fork, you may need to update:
- **publish-pypi.yml**: Update PyPI project details if you want to publish to your own PyPI repository
- **publish-crates.yml**: Update Cargo registry details if you want to publish to your own crate registry
- **publish-docs.yml**: Update documentation deployment settings
- **release.yml**: Update release process for your fork

### 4. Environment Variables and Secrets

For publishing workflows to work, you will need to set up the following secrets in your GitHub repository settings:
- `PYPI_API_TOKEN` for PyPI publishing
- `CARGO_REGISTRY_TOKEN` for crates.io publishing
- `ASTRAL_DOCS_PAT` for documentation deployment (if applicable)
- Any other tokens required for your specific publishing needs