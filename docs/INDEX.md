# Documentation Index

Master index for Android Debloater documentation.

## Repository Summary

**Android Debloater** — Single-script Bash automation for debloating Android devices via ADB.

| Aspect | Detail |
|--------|--------|
| **Purpose** | Disable/uninstall ~300 pre-installed packages; provision 14 open-source alternatives on phones |
| **Entry Point** | `android-debloater.sh` (662 lines) |
| **Runtime** | `bash` + `adb` + `wget` |
| **Target** | Android devices (Phone/TV) via USB debugging |
| **License** | GNU GPL v3.0 |
| **CI** | GitHub Actions → ShellCheck |

## Root Document Map

| Document | Purpose | Audience |
|----------|---------|----------|
| [README.md](../README.md) | User-facing overview, usage, recovery, limitations | Operators |
| [ARCHITECTURE.md](../ARCHITECTURE.md) | System architecture, runtime flow, components, data, interfaces | Architects, contributors |
| [SECURITY.md](../SECURITY.md) | Security policy, vulnerability reporting, scope | Security researchers |
| [PRIVACY.md](../PRIVACY.md) | Privacy policy, data handling, external integrations | Users, auditors |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Contribution guidelines, code style, testing | Contributors |
| [LICENSE](../LICENSE) | GNU GPL v3.0 full text | All |
| [.github/workflows/bash.yml](../.github/workflows/bash.yml) | CI workflow (ShellCheck) | Maintainers |

## Documentation Catalogue (docs/)

### Repository Overview
| File | Description |
|------|-------------|
| [repository-overview.md](repository-overview.md) | Purpose, scope, entry points, capabilities, runtime topology, integrations, invariants |
| [repository-structure.md](repository-structure.md) | Source tree layout, module organisation, file naming, directory purposes, module boundaries |

### Architecture
| File | Description |
|------|-------------|
| [architecture.md](architecture.md) | Internal component decomposition, interaction model, data flow, state management, failure propagation, boundary contracts, extension points, anti-patterns |

### Components
| File | Description |
|------|-------------|
| [components/presentation.md](components/presentation.md) | Console output component with ANSI colours, no structured logging |
| [components/host-and-composition.md](components/host-and-composition.md) | Process topology, tool composition (adb, wget, rm), working directory usage, single-target assumption |
| [components/application-services.md](components/application-services.md) | Package probe/mutation helpers (5 functions detailed) |
| [components/browser-state-and-localisation.md](components/browser-state-and-localisation.md) | Documented as not applicable |
| [components/integration-models.md](components/integration-models.md) | ADB, HTTPS APK download, host filesystem, GitHub Actions integration contracts |

### Flows
| File | Description |
|------|-------------|
| [flows/startup-and-rendering.md](flows/startup-and-rendering.md) | Bootstrap, device detection, classification sequence |
| [flows/phone-provisioning.md](flows/phone-provisioning.md) | Alternative APK installation flow with 14 curated packages and SIM heuristic |
| [flows/package-deactivation.md](flows/package-deactivation.md) | Main debloat catalogue execution with ~300 packages across 50+ categories |
| [flows/continuous-integration.md](flows/continuous-integration.md) | GitHub Actions ShellCheck workflow |

### Behaviour
| File | Description |
|------|-------------|
| [behaviour/browse-and-search.md](behaviour/browse-and-search.md) | Documented as not applicable |
| [behaviour/inspect-edit-delete.md](behaviour/inspect-edit-delete.md) | Package probe, disable/enable, uninstall/reinstall behaviours with manual recovery commands |

### Cross-Cutting Concerns
| File | Description |
|------|-------------|
| [configuration.md](configuration.md) | All hard-coded configuration (classification heuristic, provisioning APKs, package catalogue, user target, temp file location) |
| [dependencies.md](dependencies.md) | External, runtime, upstream, development, CI dependencies with version compatibility matrix |
| [data-model.md](data-model.md) | Transient host data, device-side persistent state, temporary files, package identifier format, state transitions, invariants |
| [error-handling.md](error-handling.md) | Current implicit best-effort approach, explicit guards, error taxonomy, recommended improvements |
| [logging.md](logging.md) | No structured logging, console output characteristics, what is/isn't logged, recommended improvements |
| [security.md](security.md) | Threat model, trust boundaries, security properties, vulnerability surface, controls, recommendations |
| [testing.md](testing.md) | Test strategy, organisation, coverage (manual testing only, ShellCheck CI) |
| [build-and-deployment.md](build-and-deployment.md) | Build pipeline, deployment, environments (single script, no build) |
| [change-guide.md](change-guide.md) | How to modify common areas safely (catalogue, provisioning, helpers) |
| [design-decisions.md](design-decisions.md) | Key architectural choices (disable over uninstall, heuristic classification, phone-only provisioning) |
| [invariants.md](invariants.md) | System-wide invariants (user 0 scope, disable-over-uninstall, single-target, best-effort, heuristic classification, static catalogue) |
| [integrations.md](integrations.md) | External system integrations (ADB, APK providers, GitHub Actions) |
| [state-and-persistence.md](state-and-persistence.md) | State management (device package state only, no host persistence) |
| [concurrency-and-scheduling.md](concurrency-and-scheduling.md) | Threading/async (none — sequential synchronous) |
| [documentation-maintenance.md](documentation-maintenance.md) | How to keep docs current, ownership |
| [faq.md](faq.md) | Frequently asked questions |
| [troubleshooting.md](troubleshooting.md) | Common issues and solutions |
| [quick-start.md](quick-start.md) | Getting started guide for newcomers |
| [ambiguities-and-open-questions.md](ambiguities-and-open-questions.md) | Unresolved items, TODOs, known gaps |
| [api-usage-examples.md](api-usage-examples.md) | N/A for shell script (documented as such) |
| [api-reference/INDEX.md](api-reference/INDEX.md) | N/A for shell script (documented as such) |

## Navigation Aids

### By Audience

| Audience | Start Here |
|----------|------------|
| **New User** | [quick-start.md](quick-start.md) → [README.md](../README.md) → [faq.md](faq.md) |
| **Operator** | [README.md](../README.md) → [troubleshooting.md](troubleshooting.md) → [faq.md](faq.md) |
| **Contributor** | [CONTRIBUTING.md](../CONTRIBUTING.md) → [change-guide.md](change-guide.md) → [architecture.md](architecture.md) |
| **Auditor** | [SECURITY.md](../SECURITY.md) → [security.md](security.md) → [privacy.md](../PRIVACY.md) |
| **Architect** | [ARCHITECTURE.md](../ARCHITECTURE.md) → [architecture.md](architecture.md) → [design-decisions.md](design-decisions.md) |

### By Task

| Task | Documents |
|------|-----------|
| Run script | [quick-start.md](quick-start.md), [README.md](../README.md) |
| Recover from mistake | [README.md](../README.md#recovery), [troubleshooting.md](troubleshooting.md#recovery-procedures) |
| Add package | [change-guide.md](change-guide.md#adding-a-package-to-the-debloat-catalogue), [flows/package-deactivation.md](flows/package-deactivation.md) |
| Add provisioning app | [change-guide.md](change-guide.md#adding-a-provisioning-apk-phone-only), [flows/phone-provisioning.md](flows/phone-provisioning.md) |
| Understand architecture | [ARCHITECTURE.md](../ARCHITECTURE.md), [architecture.md](architecture.md) |
| Debug failure | [troubleshooting.md](troubleshooting.md), [error-handling.md](error-handling.md) |
| Review security | [SECURITY.md](../SECURITY.md), [security.md](security.md) |
| Update documentation | [documentation-maintenance.md](documentation-maintenance.md) |

## Maintenance Metadata

| Property | Value |
|----------|-------|
| **Generated** | 2025 (see Git history) |
| **Last Sync** | After script changes |
| **Total Files** | 30 (root: 7, docs/: 23) |
| **Coverage** | All specification areas addressed |
| **Validation** | `markdown-link-check docs/**/*.md` |

## Link Integrity

All internal links use relative paths. Verify with:

```bash
npx markdown-link-check docs/**/*.md ../README.md ../ARCHITECTURE.md ../SECURITY.md ../PRIVACY.md ../CONTRIBUTING.md
```

---

*This index is the master navigation document. Update it when adding/removing documentation files.*