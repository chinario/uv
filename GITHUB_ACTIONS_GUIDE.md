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

### 2. Publishing Workflows

- **publish-pypi.yml**: Contains PyPI publishing configurations
- **publish-docs.yml**: References `astral-sh/docs.git` specifically

### 3. Docker Build Workflows

- **build-docker.yml**: Contains Project IDs specific to astral-sh (`project: 7hd4vdzmw5 # astral-sh/uv`)

## Recommended Changes

### For Continuous Integration (CI)

Update the conditions in `.github/workflows/ci.yml` to allow your repository:

```yaml
# Change from:
if: github.repository == 'astral-sh/uv' && ...

# To:
if: (github.repository == 'astral-sh/uv' || github.repository == 'chinario/uv') && ...
```

### For Publishing

If you want to publish to your own PyPI account:

1. Update `.github/workflows/publish-pypi.yml` with your PyPI credentials
2. Update repository references in the publishing scripts

### For Documentation

Update `.github/workflows/publish-docs.yml` if you want to publish to your own documentation site.

## Running Your Own Builds

After making the appropriate changes to the workflow conditions, your fork will be able to run the same CI/CD processes as the original repository.

## Syncing Updates

To keep your fork up-to-date with the original repository:

1. Run the sync script: `bash scripts/sync-upstream.sh`
2. Reapply your customizations to the workflows as needed
3. Test the workflows in a development branch before merging to main