[![Donate](https://img.shields.io/badge/-%E2%99%A5%20Donate-%23ff69b4)](https://hmlendea.go.ro/funding)
[![Latest Release](https://img.shields.io/github/v/release/hmlendea/android-debloater)](https://github.com/hmlendea/android-debloater/releases/latest)
[![Build Status](https://github.com/hmlendea/android-debloater/actions/workflows/bash.yml/badge.svg)](https://github.com/hmlendea/android-debloater/actions/workflows/bash.yml)
[![License](https://img.shields.io/github/license/hmlendea/android-debloater)](https://github.com/hmlendea/android-debloater/blob/master/LICENSE)

# Android Debloater (ADB)

Debloat Android phones and Android TV devices through a single Bash script and ADB.

The script is intentionally conservative by default: it primarily disables packages instead of uninstalling them, which is safer to recover and typically safer for OTA updates.

## 📑 Table of Contents

- [Capabilities](#capabilities)
- [Use Cases](#use-cases)
- [Usage](#usage)
  - [Basic Run](#basic-run)
  - [Recovery Commands](#recovery-commands)
- [Known Limitations](#known-limitations)
- [System Requirements](#system-requirements)
- [Installation](#installation)
  - [Manual Installation](#manual-installation)
  - [Verification](#verification)
- [Privacy and Data](#privacy-and-data)
- [Development](#development)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Run](#run)
  - [Linting](#linting)
  - [Continuous Integration](#continuous-integration)
- [GitHub Actions](#github-actions)
- [Project Structure](#project-structure)
  - [Directories](#directories)
- [Architecture](#architecture)
- [Security](#security)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Project Engagement](#project-engagement)
- [License](#license)

## ✨ Capabilities

- Detects connected Android devices through ADB and exits early when none are available.
- Distinguishes device type (`Phone` versus `TV`) through package heuristics.
- Installs alternative applications on phones when they are absent (Aurora Store, F-Droid, selected Fossify apps, Breezy Weather).
- Disables a substantial multi-vendor package set (Google, Samsung, Xiaomi, Asus, Oppo/OnePlus, and others).
- Uninstalls only a small, explicit subset of packages.

## 🎯 Use Cases

- **Phone debloating:** Remove or disable pre-installed bloatware on Android phones while provisioning privacy-respecting alternatives.
- **TV debloating:** Disable unwanted packages on Android TV devices without installing additional applications.

## 🚀 Usage

### Basic Run

```bash
chmod +x android-debloater.sh
./android-debloater.sh
```

### Recovery Commands

Re-enable a package:

```bash
adb shell pm enable --user 0 <package.name>
```

Reinstall an uninstalled system package (when still present in the system image):

```bash
adb shell pm install-existing --user 0 <package.name>
```

List disabled packages:

```bash
adb shell pm list packages --user 0 -d
```

## ⚠️ Known Limitations

- The script is non-interactive and executes immediately.
- Some package groups include core applications (dialer, contacts, messaging, camera, file manager), which can alter expected device conduct.
- Certain entries are uninstalled (not only disabled).
- Package availability differs by OEM, ROM, and Android version.
- APK download links in the provisioning section can become stale over time.

## 🖥️ System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Linux, macOS, or compatible shell environment with ADB | Linux |
| Runtime tools | `adb`, `wget`, `bash` | Latest stable versions |
| Device state | USB debugging enabled and ADB authorisation accepted | Authorised ADB connection |

## 📦 Installation

This project is distributed as a single Bash script. No package manager installation is available.

[![Obtain it from GitHub](https://raw.githubusercontent.com/hmlendea/readme-assets/master/badges/stores/github.png)](https://github.com/hmlendea/android-debloater/releases)

### Manual Installation

1. Download the latest `android-debloater.sh` from the [releases page](https://github.com/hmlendea/android-debloater/releases).
2. Make it executable:
   ```bash
   chmod +x android-debloater.sh
   ```
3. Ensure system requirements are met (see [System Requirements](#system-requirements)).

### Verification

```bash
./android-debloater.sh --help
```
(Note: The script currently does not implement a `--help` flag; running it without a connected device will exit with an error message.)

## 🛡️ Privacy and Data

Android Debloater collects no personal data and transmits nothing to the project maintainers. The only external network activity is optional HTTPS downloads of APK files from verified upstream sources (Aurora Store, F-Droid, Fossify, Breezy Weather) when provisioning alternative applications on phones.

For the detailed description of how the application handles privacy and personal data, see the [Privacy Statement](./PRIVACY.md).

## 🛠️ Development

### Requirements

- Bash
- Android Platform Tools (`adb`)
- ShellCheck
- `wget`

### Setup

Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y android-tools-adb wget shellcheck
```

Arch Linux:

```bash
sudo pacman -Syy
sudo pacman -S android-tools wget shellcheck
```

Validate the ADB connection:

```bash
adb devices
```

### Run

```bash
bash ./android-debloater.sh
```

### Linting

```bash
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

### Continuous Integration

GitHub Actions validates every push and pull request targeting `master`. Reproduce the validation locally with:
```bash
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

## ⚙️ GitHub Actions

| Workflow | Purpose | What it does |
|----------|---------|--------------|
| [ bash.yml ](https://github.com/hmlendea/android-debloater/blob/master/.github/workflows/bash.yml) | ShellCheck validation | Checks out the repository and runs ShellCheck on all `.sh` files with error severity on every push and pull request to `master`. |

## 🗂️ Project Structure

### Directories

| Directory | Purpose |
|-----------|---------|
| `docs/` | Supplementary documentation covering architecture, configuration, testing, and other topics. |
| `.github/workflows/` | GitHub Actions workflow definitions. |

## 🏗️ Architecture

Android Debloater automates a curated Android debloating procedure through one Bash entry point, `android-debloater.sh`. The script detects an attached device through ADB, classifies it as a phone or TV through an installed-package heuristic, optionally provisions alternative applications for phones, and then executes a long sequential package deactivation pass with a smaller explicit uninstall subset.

See the [Architecture Documentation](./ARCHITECTURE.md) for the system context, principal components, runtime flows, ownership boundaries, dependencies, constraints, and extension points.

## 🔒 Security

See the [security policy](./SECURITY.md) for supported versions, vulnerability reporting, scope, disclosure policy, and recognition.

## 🤝 Contributing

You are welcome to bring any suggestion, feedback or modification to this project.

When doing so, please:
- Maintain cross-platform compatibility
- Maintain the pull requests as focused and consistent with the existing code style
- Maintain your branch up-to-date with `master`
- Revise the documentation when behaviour changes
- Properly test all changes

## 📜 Code of Conduct

See the [Code of Conduct](./CODE_OF_CONDUCT.md) for the standards of conduct expected in all project spaces.

## 💝 Project Engagement

Discovered a problem or have a suggestion? [Open an issue](https://github.com/hmlendea/android-debloater/issues)!

If you find this project useful, consider [funding it](https://hmlendea.go.ro/funding) or starring ⭐️ it on GitHub!

## 📄 License

This project is being distributed under the `GNU General Public License v3.0` or later.
See [LICENSE](./LICENSE) for details.
