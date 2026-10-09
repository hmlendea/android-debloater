# Contributing to Android Debloater

Thank you for your interest in contributing to Android Debloater! This document provides guidelines for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Pull Request Process](#pull-request-process)
- [Code Style](#code-style)
- [Testing](#testing)
- [Documentation](#documentation)
- [Issue Reporting](#issue-reporting)

## Code of Conduct

By participating in this project, you agree to abide by the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Please report unacceptable behavior to the project maintainers.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/android-debloater.git
   cd android-debloater
   ```
3. Add the upstream remote:
   ```bash
   git remote add upstream https://github.com/hmlendea/android-debloater.git
   ```

## Development Setup

### Requirements

- Bash
- Android Platform Tools (`adb`)
- ShellCheck
- `wget`

### Installation

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install -y android-tools-adb wget shellcheck
```

**Arch Linux:**
```bash
sudo pacman -Syy
sudo pacman -S android-tools wget shellcheck
```

### Validate ADB Connection

```bash
adb devices
```

### Run the Script

```bash
bash ./android-debloater.sh
```

### Run Linting (ShellCheck)

```bash
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

## Making Changes

1. Create a new branch from `master`:
   ```bash
   git checkout master
   git pull upstream master
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the [Code Style](#code-style) guidelines

3. Test your changes thoroughly (see [Testing](#testing))

4. Update documentation if behavior changes

5. Commit your changes with clear, descriptive messages:
   ```bash
   git commit -m "feat: add support for new device type detection"
   ```

## Pull Request Process

1. Ensure your branch is up-to-date with `master`:
   ```bash
   git fetch upstream
   git rebase upstream/master
   ```

2. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. Open a Pull Request against the `master` branch of the upstream repository

4. Ensure the PR description includes:
   - What changes were made
   - Why the changes were made
   - How to test the changes
   - Any related issues

5. All CI checks must pass (ShellCheck validation)

6. Maintainers will review the PR and may request changes

7. Once approved, the PR will be merged

## Code Style

### Bash Script Guidelines

- Use `#!/bin/bash` shebang
- Use 4 spaces for indentation (no tabs)
- Use descriptive variable names (UPPER_SNAKE_CASE for constants, lower_snake_case for variables)
- Quote all variable expansions: `"${VAR}"`
- Use `local` for function-scoped variables
- Prefer `[[ ]]` over `[ ]` for conditionals
- Use `$(command)` instead of backticks
- Add comments for non-obvious logic
- Keep functions small and focused

### Package List Guidelines

When adding packages to the debloat catalogue:
- Group packages by vendor/category
- Add comments explaining what each package group does
- Prefer disabling over uninstalling (safer for OTA updates)
- Only uninstall packages that are confirmed safe to remove
- Test on actual devices when possible

### Commit Message Format

Follow conventional commits:
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation changes
- `style:` — formatting, missing semicolons, etc.
- `refactor:` — code restructuring
- `test:` — adding tests
- `chore:` — maintenance tasks

## Testing

### Manual Testing

1. Connect an Android device with USB debugging enabled
2. Run the script:
   ```bash
   bash ./android-debloater.sh
   ```
3. Verify the device is detected correctly (Phone vs TV)
4. Verify packages are disabled/uninstalled as expected
5. Test recovery commands:
   ```bash
   adb shell pm enable --user 0 <package.name>
   adb shell pm install-existing --user 0 <package.name>
   ```

### Linting

Run ShellCheck before submitting:
```bash
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

### CI Validation

GitHub Actions runs ShellCheck on every push and PR targeting `master`. Ensure your changes pass locally before pushing.

## Documentation

- Update `README.md` for user-facing changes
- Update `ARCHITECTURE.md` for architectural changes
- Update `PRIVACY.md` for data handling changes
- Update `SECURITY.md` for security-related changes
- Add comments in the script for complex logic

## Issue Reporting

### Bug Reports

When reporting a bug, please include:
- Script version or commit hash
- Host OS and version
- Android device model and Android version
- ADB version (`adb version`)
- Steps to reproduce
- Expected vs actual behavior
- Relevant console output (redact sensitive data)

### Feature Requests

When requesting a feature, please include:
- Use case and motivation
- Proposed solution (if any)
- Alternatives considered
- Impact on existing functionality

### Security Issues

Report security vulnerabilities via [GitHub Security Advisories](https://github.com/hmlendea/android-debloater/security/advisories) — do not open public issues for security concerns.

## License

By contributing, you agree that your contributions will be licensed under the GNU General Public License v3.0 or later, same as the project.