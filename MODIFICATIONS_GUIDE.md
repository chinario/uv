# Making Modifications to Source Code

This guide explains how to make modifications to the uv source code in your fork while maintaining the ability to sync with upstream.

## Understanding the Project Structure

uv is a Rust project with Python bindings:

- `crates/`: Contains Rust crates (the main logic is in `crates/uv/`)
- `Cargo.toml`: Rust workspace configuration
- `pyproject.toml`: Python packaging configuration
- `scripts/`: Utility scripts
- `.github/workflows/`: GitHub Actions workflows

## Process for Making Modifications

### 1. Before Making Changes

1. Ensure your repository is synced with upstream:
   ```bash
   bash scripts/sync-upstream.sh
   ```

2. Create a new branch for your changes:
   ```bash
   git checkout -b feature/my-modification
   ```

### 2. Making Changes

1. Identify the files you need to modify
2. Make your changes following the existing code style
3. Test your changes locally (see Testing section below)

### 3. After Making Changes

1. Commit your changes with clear commit messages
2. Push your branch to GitHub
3. Create a pull request or merge to your main branch

## Syncing with Upstream After Modifications

When syncing with upstream after you've made changes:

1. Save a patch of your changes (optional but recommended):
   ```bash
   git diff HEAD~1 > my-changes.patch  # If your changes are in the last commit
   ```

2. Sync with upstream:
   ```bash
   bash scripts/sync-upstream.sh
   ```

3. Reapply your modifications if needed
4. Resolve any conflicts that arise
5. Test your changes still work after the sync

## Testing Your Changes

### Building uv

1. Install Rust if you haven't already
2. Build the project:
   ```bash
   cargo build
   ```

### Running Tests

Run the test suite to ensure your changes don't break anything:
```bash
cargo test
```

### Local Installation

To install your modified version locally for testing:
```bash
pip install -e .
```

## Important Considerations

1. **Maintain Compatibility**: Try to maintain compatibility with the original codebase to make upstream syncing easier.

2. **Document Changes**: Keep a record of what modifications you made and why.

3. **Test Thoroughly**: Ensure your changes work correctly and don't introduce regressions.

4. **Consider Upstream Contribution**: If your changes are generally useful, consider contributing them back to the original repository.

## Example Workflow

Here's an example of how to make a simple modification:

```bash
# 1. Sync with upstream first
bash scripts/sync-upstream.sh

# 2. Create a branch for your changes
git checkout -b feature/custom-option

# 3. Make your modifications
# Edit files as needed...

# 4. Test your changes
cargo test
cargo build

# 5. Commit your changes
git add .
git commit -m "Add custom option to uv command"

# 6. Push and continue working
git push origin feature/custom-option
```

## Troubleshooting

If you encounter merge conflicts when syncing:
1. Carefully review the conflicts
2. Preserve your custom changes
3. Apply the upstream changes where appropriate
4. Test thoroughly after resolving conflicts