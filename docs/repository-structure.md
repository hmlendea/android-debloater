# Repository Structure

## Source Tree Layout

```
android-debloater/
├── android-debloater.sh          # Main orchestration script (662 lines)
├── .github/
│   └── workflows/
│       └── bash.yml              # ShellCheck CI workflow
├── ARCHITECTURE.md               # Root architecture documentation
├── CONTRIBUTING.md               # Contribution guidelines
├── LICENSE                       # GPL v3 license
├── PRIVACY.md                    # Privacy policy
├── README.md                     # User-facing documentation
├── SECURITY.md                   # Security policy
├── .gitignore
└── docs/                         # Generated documentation (this directory)
    ├── INDEX.md
    ├── repository-overview.md
    ├── repository-structure.md
    ├── architecture.md
    ├── components/
    ├── flows/
    ├── behaviour/
    ├── api-reference/
    ├── configuration.md
    ├── dependencies.md
    ├── data-model.md
    ├── error-handling.md
    ├── logging.md
    ├── security.md
    ├── testing.md
    ├── build-and-deployment.md
    ├── change-guide.md
    ├── design-decisions.md
    ├── invariants.md
    ├── integrations.md
    ├── state-and-persistence.md
    ├── concurrency-and-scheduling.md
    ├── documentation-maintenance.md
    ├── faq.md
    ├── troubleshooting.md
    ├── quick-start.md
    ├── ambiguities-and-open-questions.md
    └── api-usage-examples.md
```

## Module Organisation

The repository follows a flat structure with a single script owning all orchestration logic. There are no submodules, packages, or separate libraries.

### Primary Module: `android-debloater.sh`

| Section | Lines | Responsibility |
|---------|-------|----------------|
| Shebang and header | 1–14 | Script metadata, safety notes |
| ADB device detection | 16–21 | Bootstrap; abort if no devices |
| Package probe helpers | 23–44 | `is_android_package_installed`, `is_android_package_disabled` |
| Package mutation helpers | 46–86 | `enable_android_package`, `disable_android_package`, `install_android_package`, `uninstall_android_package`, `reinstall_android_package` |
| Device classification | 88–91 | Heuristic check for TV vs Phone |
| Phone provisioning | 94–130 | Alternative APK installation (Aurora, F-Droid, Fossify, Breezy) |
| Debloat catalogue | 133–662 | ~300 package identifiers in vendor/category groups |

### CI Module: `.github/workflows/bash.yml`

Single job `check` running ShellCheck on all `**/*.sh` files at error severity.

## File Naming Conventions

- Scripts: kebab-case with `.sh` extension (`android-debloater.sh`)
- Documentation: kebab-case with `.md` extension (`ARCHITECTURE.md`, `README.md`)
- Workflow: kebab-case with `.yml` extension (`bash.yml`)
- License: uppercase (`LICENSE`)

## Directory Purposes

| Directory | Purpose |
|-----------|---------|
| `.github/workflows/` | GitHub Actions CI definitions |
| `docs/` | Generated deep-dive documentation (complements root docs) |
| `docs/components/` | Per-component deep dives |
| `docs/flows/` | End-to-end execution flows |
| `docs/behaviour/` | User-facing behaviours |
| `docs/api-reference/` | API reference (N/A for this shell script) |

## Module Boundaries

The script has no internal module boundaries — all functions and the catalogue coexist in one file. The only architectural boundaries are:

1. **Host ↔ Device** — ADB transport boundary
2. **Host ↔ Network** — HTTPS download boundary (provisioning only)
3. **Script ↔ CI** — ShellCheck validation boundary

There are no:
- Internal package boundaries
- Dependency injection points
- Plugin or extension mechanisms
- Configuration file abstractions