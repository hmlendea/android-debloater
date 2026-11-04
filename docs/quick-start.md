# Quick Start

## For New Users

### 1. Prerequisites

| Tool | Install |
|------|---------|
| `bash` | Pre-installed on Linux/macOS; WSL/Git Bash on Windows |
| `adb` | [Android Platform Tools](https://developer.android.com/tools/releases/platform-tools) |
| `wget` | `apt install wget` / `brew install wget` / `choco install wget` |

### 2. Device Setup

1. **Enable Developer Options**: Settings → About phone → Tap "Build number" 7 times
2. **Enable USB Debugging**: Settings → Developer options → USB debugging
3. **Connect Device**: USB cable to host
4. **Authorise ADB**: Accept prompt on device screen

### 3. Verify Connection

```bash
adb devices
# Output:
# List of devices attached
# <serial>    device
```

### 4. Run Script

```bash
git clone https://github.com/<owner>/android-debloater.git
cd android-debloater
chmod +x android-debloater.sh
./android-debloater.sh
```

### 5. Observe Output

```
[*] Probing ADB devices...
[+] Device found: <serial>
[*] Classifying device...
[+] Device type: Phone
[*] Provisioning phone with alternative apps...
[+] Installing com.aurora.store...
...
[*] Starting debloat catalogue...
[+] Disabling com.google.android.apps.docs...
...
[*] Done.
```

## For Contributors

### 1. Fork & Clone

```bash
git clone https://github.com/<your-fork>/android-debloater.git
cd android-debloater
```

### 2. Validate Syntax

```bash
bash -n android-debloater.sh
```

### 3. Lint

```bash
shellcheck android-debloater.sh
```

### 4. Test on Device

```bash
./android-debloater.sh
```

### 5. Submit PR

- Describe change and rationale
- Reference affected packages
- Include device tested on

## For Reviewers

### Checklist

- [ ] `bash -n` passes
- [ ] `shellcheck` passes (errors only)
- [ ] Catalogue changes documented in PR
- [ ] No hard-coded secrets
- [ ] APK URLs verified accessible
- [ ] Recovery commands still valid

## One-Line Summary

```bash
# Clone, connect device, run
git clone <repo> && cd android-debloater && ./android-debloater.sh
```