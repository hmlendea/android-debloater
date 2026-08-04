[![Donate](https://img.shields.io/badge/-%E2%99%A5%20Donate-%23ff69b4)](https://hmlendea.go.ro/funding)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://gnu.org/licenses/gpl-3.0)

# Android Debloater (ADB)

Debloat Android phones and Android TV devices through a single Bash script and ADB.

The script is intentionally conservative by default: it primarily disables packages instead of uninstalling them, which is safer to recover and typically safer for OTA updates.

## 📑 Table of Contents

- [Features](#features)
- [Usage](#usage)
  - [Basic Run](#basic-run)
  - [Recovery Commands](#recovery-commands)
- [Known Limitations](#known-limitations)
- [System Requirements](#system-requirements)
- [Development](#development)
  - [Requirements](#requirements)
  - [Setup](#setup)
  - [Run](#run)
- [Contributing](#contributing)
- [Helping out](#helping-out)
- [License](#license)

## ✨ Features

- Detects connected Android devices through ADB and exits early when none are available.
- Distinguishes device type (`Phone` versus `TV`) through package heuristics.
- Installs alternative applications on phones when they are absent (Aurora Store, F-Droid, selected Fossify apps, Breezy Weather).
- Disables a substantial multi-vendor package set (Google, Samsung, Xiaomi, Asus, Oppo/OnePlus, and others).
- Uninstalls only a small, explicit subset of packages.

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

- **OS:** Linux, macOS, or a compatible shell environment with ADB available
- **Runtime tools:** `adb`, `wget`, `bash`
- **Device state:** USB debugging enabled and ADB authorisation accepted on the target device

## 🛠️ Development

### Requirements

- Bash
- Android Platform Tools (`adb`)
- `wget`

### Setup

Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y android-tools-adb wget
```

Arch Linux:

```bash
sudo pacman -Syy
sudo pacman -S android-tools wget
```

Validate the ADB connection:

```bash
adb devices
```

### Run

```bash
bash ./android-debloater.sh
```

## 🤝 Contributing

You are welcome to bring any suggestion, feedback or modification to this project.

When doing so, please:
- Maintain cross-platform compatibility
- Maintain the pull requests as focused and consistent with the existing code style
- Maintain your branch up-to-date with `master`
- Revise the documentation when behaviour changes
- Properly test all changes

## 💝 Helping out

Discovered a problem or have a suggestion? [Open an issue](https://github.com/hmlendea/android-debloater/issues)!

If you find this project useful, consider [funding it](https://hmlendea.go.ro/funding) or starring ⭐️ it on GitHub!

[![Donate](https://raw.githubusercontent.com/hmlendea/readme-assets/master/donate_generic.png)](https://hmlendea.go.ro/funding)

## 📄 License

This project is being distributed under the `GNU General Public License v3.0` or later.
See [LICENSE](./LICENSE) for details.
