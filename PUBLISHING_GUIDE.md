# Automated Publishing Mechanism for Your Fork

This guide explains how to set up automated publishing for your fork of uv, allowing you to publish your modified version when needed.

## Overview

The original uv repository has several publishing mechanisms:
- PyPI for Python package distribution
- crates.io for Rust crate distribution
- GitHub Releases for binary distributions
- Docker images for containerized distribution

## Setting Up Automated Publishing

### 1. PyPI Publishing

To set up PyPI publishing for your fork:

1. Create an account on [PyPI](https://pypi.org/account/register/)
2. Create a project on PyPI (you'll need to choose a different name than "uv" since it's already taken)
3. Generate an API token in your PyPI account settings
4. Add the token as a GitHub secret named `PYPI_API_TOKEN` in your repository settings

In your fork, you'll need to modify the `pyproject.toml` file to:
- Change the package name to something unique (e.g., `uv-fork`, `custom-uv`, or your preferred name)
- Update the versioning to avoid conflicts with the original
- Update the description and author information

### 2. crates.io Publishing

To set up crates.io publishing:

1. Create an account on [crates.io](https://crates.io/)
2. Generate an API token using `cargo login`
3. Add the token as a GitHub secret named `CARGO_REGISTRY_TOKEN` in your repository settings
4. Update the crate name in `crates/uv/Cargo.toml` to avoid conflicts with the original

### 3. GitHub Releases

GitHub Releases are automatically handled by the existing `release.yml` workflow. You'll need to:

1. Ensure your fork's release workflow is configured to run when you create a new tag
2. The existing workflow should create GitHub Releases with binaries for different platforms

### 4. Docker Images

To publish Docker images:

1. Create accounts on Docker Hub and/or GitHub Container Registry (GHCR)
2. Add credentials as GitHub secrets:
   - `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` for Docker Hub
   - `CR_PAT` for GitHub Container Registry
3. Update the image names in `.github/workflows/build-docker.yml` to match your repository

## Required GitHub Secrets

For full publishing functionality, add these secrets to your repository settings (Settings → Secrets and variables → Actions):

- `PYPI_API_TOKEN`: For PyPI package publishing
- `CARGO_REGISTRY_TOKEN`: For crates.io crate publishing
- `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`: For Docker Hub publishing
- `CR_PAT`: For GitHub Container Registry publishing
- `ASTRAL_DOCS_PAT`: If you plan to deploy documentation to a custom location

## Customizing Package Names

To avoid conflicts with the original project, you should change the package names in:

1. `pyproject.toml`: Update the `[project]` name field
2. `crates/uv/Cargo.toml`: Update the `package.name` field
3. Update any references to the package name in documentation or scripts

## Publishing Process

Once configured:

1. Make your modifications to the source code
2. Update the version number in the appropriate configuration files
3. Create and push a Git tag (e.g., `v0.1.0-fork`)
4. The GitHub Actions workflows will automatically build and publish your modified version

## Important Considerations

- Be respectful of the original authors by clearly indicating this is a fork with modifications
- Choose unique package names to avoid conflicts with the original project
- Consider contributing beneficial changes back to the original project via pull requests
- Follow the licensing terms of the original project (this project is MIT licensed)
- Be mindful of trademark issues when choosing names for your fork

## Disabling Publishing (Optional)

If you only want to build the project locally and don't need automated publishing, you can:

1. Remove or disable the publishing jobs in the GitHub Actions workflows
2. Remove any repository secrets related to publishing
3. Skip the sections related to publishing in this guide