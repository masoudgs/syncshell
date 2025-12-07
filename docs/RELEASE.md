# Release Process

This document outlines the steps to release a new version of syncshell.

## Prerequisites

- [ ] All tests are passing
- [ ] All changes are committed and pushed
- [ ] You're on the `develop` branch
- [ ] Python environment is set up (Poetry installed)
- [ ] Git Flow is initialized (`git flow init`)

## Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (v2.0.0): Breaking changes or major new features
- **MINOR** (v1.1.0): New features, backwards compatible
- **PATCH** (v1.0.9): Bug fixes, backwards compatible

## Release Steps

### 1. Start Release Branch

```bash
# Ensure you're on develop branch with latest changes
git checkout develop
git pull origin develop

# Start a new release branch using git flow
git flow release start vX.Y.Z
```

### 2. Run Tests

```bash
# Run all tests
make test

# Run tests with coverage (optional)
make test-cov

# Run linter
make lint
```

### 3. Update Version

Update the version number in `pyproject.toml`:

```toml
[tool.poetry]
version = "vX.Y.Z"
```

### 4. Update CHANGELOG (if exists)

Document the changes in this release:

- New features
- Bug fixes
- Breaking changes
- Deprecations

### 5. Commit Version Bump

```bash
# Stage the version change
git add pyproject.toml

# Commit with conventional commit message
git commit -m "chore: bump version to vX.Y.Z"
```

### 6. Finish Release with Git Flow

```bash
# Finish the release (merges to main and develop, creates tag)
git flow release finish vX.Y.Z

# You'll be prompted to:
# 1. Enter tag message (e.g., "Release vX.Y.Z")
# 2. Enter merge commit message for main
# 3. Enter merge commit message for develop

# Push all branches and tags
git push origin main
git push origin develop
git push origin --tags
```

### 7. Build Package

```bash
# Clean previous builds
make clean

# Build the package
poetry build
```

This creates distribution files in `dist/`:

- `syncshell-vX.Y.Z-py3-none-any.whl`
- `syncshell-vX.Y.Z.tar.gz`

### 8. Publish to PyPI

#### Test PyPI (Optional - Recommended for first time)

```bash
# Configure TestPyPI repository
poetry config repositories.testpypi https://test.pypi.org/legacy/

# Publish to TestPyPI
poetry publish -r testpypi

# Test installation from TestPyPI
pip install --index-url https://test.pypi.org/simple/ syncshell
```

#### Production PyPI

```bash
# Publish to PyPI (requires PyPI credentials)
poetry publish

# Or build and publish in one step
poetry publish --build
```

**Note**: You'll need to configure PyPI credentials first:

```bash
poetry config pypi-token.pypi YOUR_PYPI_TOKEN
```

### 9. Create GitHub Release

1. Go to <https://github.com/masoudgs/syncshell/releases/new>
2. Select the tag: `vX.Y.Z`
3. Set release title: `vX.Y.Z`
4. Add release notes (copy from CHANGELOG)
5. Attach distribution files (optional)
6. Click "Publish release"

Or use GitHub CLI:

```bash
# Create release with notes
gh release create vX.Y.Z \
  --title "vX.Y.Z" \
  --notes "Release notes here" \
  dist/*
```

## Quick Reference Commands (Git Flow)

```bash
# Complete release workflow with Git Flow
git checkout develop
git pull origin develop
git flow release start vX.Y.Z
make test
# Update version in pyproject.toml
git add pyproject.toml
git commit -m "chore: bump version to vX.Y.Z"
git flow release finish vX.Y.Z
# Enter tag message, main merge message, and develop merge message when prompted
git push origin main
git push origin develop
git push origin --tags
poetry build
poetry publish
gh release create vX.Y.Z --title "vX.Y.Z" --notes "Release notes" dist/*
```

## Rollback a Release

If you need to rollback a release:

```bash
# Delete local tag
git tag -d vX.Y.Z

# Delete remote tag
git push origin :refs/tags/vX.Y.Z

# Delete PyPI release (contact PyPI support - cannot be done automatically)

# Delete GitHub release
gh release delete vX.Y.Z
```

## Troubleshooting

### Poetry build fails

```bash
# Clear cache and rebuild
poetry cache clear pypi --all
poetry install
poetry build
```

### PyPI authentication fails

```bash
# Re-configure credentials
poetry config pypi-token.pypi YOUR_NEW_TOKEN
```

### Git merge conflicts

```bash
# Abort merge
git merge --abort

# Resolve conflicts manually, then
git add .
git commit
```

## Automation (Future)

Consider setting up:

- GitHub Actions for automated releases
- Automated CHANGELOG generation
- Automated version bumping
- Automated PyPI publishing on tag push

## Checklist Template

Use this checklist for each release:

- [ ] All tests passing
- [ ] Version updated in `pyproject.toml`
- [ ] CHANGELOG updated (if exists)
- [ ] Changes committed to develop
- [ ] Develop merged to main
- [ ] Git tag created and pushed
- [ ] Package built successfully
- [ ] Published to PyPI
- [ ] GitHub release created
- [ ] Main merged back to develop
- [ ] Release announced (if applicable)
