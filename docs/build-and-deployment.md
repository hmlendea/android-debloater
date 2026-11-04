# Build and Deployment

## Build Process

Android Debloater has **no build process**. It is a single interpreted Bash script.

| Step | Command | Output |
|------|---------|--------|
| Validate syntax | `bash -n android-debloater.sh` | Exit code only |
| Lint | `shellcheck android-debloater.sh` | Diagnostics |
| Package | N/A | Script is the artefact |

## Deployment Model

### Distribution

- **Primary**: GitHub repository (source)
- **Installation**: `git clone` + `chmod +x`
- **Execution**: Direct invocation `./android-debloater.sh`

### Artefacts

| Artefact | Location | Versioning |
|----------|----------|------------|
| Script | `android-debloater.sh` | Git commit hash |
| Documentation | `*.md` files | Git commit hash |
| CI workflow | `.github/workflows/bash.yml` | Git commit hash |

### Release Process

No formal release process. Users consume from `master` branch directly.

## Environments

| Environment | Purpose | Configuration |
|-------------|---------|---------------|
| Operator host | Execution | Requires `bash`, `adb`, `wget` |
| GitHub Actions | CI validation | `ubuntu-latest` runner |
| Android device | Target | USB debugging + ADB auth |

## Deployment Topology

```
GitHub Repository
       │
       ▼ (git clone)
Operator Host ──────► Android Device
  (script)              (target)
       │
       ▼ (CI push)
GitHub Actions (ShellCheck)
```

## Rollback

- **Script**: `git checkout <previous-commit>`
- **Device state**: Manual ADB commands (`pm enable`, `pm install-existing`)

## Versioning

No semantic versioning. Repository state identified by Git commit hash.

## Dependencies at Deployment Time

| Dependency | Source | Version Pinning |
|------------|--------|-----------------|
| `bash` | Host OS package manager | OS default |
| `adb` | Android Platform Tools | Operator choice |
| `wget` | Host OS package manager | OS default |
| ShellCheck | CI runner / Host OS | Ubuntu default / OS default |

## Deployment Checklist

- [ ] Host has `bash` ≥ 4.0
- [ ] Host has `adb` in PATH (Android Platform Tools)
- [ ] Host has `wget` in PATH
- [ ] Target device has USB debugging enabled
- [ ] Target device has authorised ADB connection
- [ ] Operator has reviewed hard-coded APK URLs
- [ ] Operator has backed up device (recommended)