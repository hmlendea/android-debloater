# Documentation Maintenance

## Documentation Structure

```
├── README.md                    # Root: user-facing overview
├── ARCHITECTURE.md              # Root: system architecture
├── SECURITY.md                  # Root: security policy
├── PRIVACY.md                   # Root: privacy policy
├── CONTRIBUTING.md              # Root: contribution guide
├── LICENSE                      # Root: GPL v3.0
├── docs/
│   ├── INDEX.md                 # Master index (this file's parent)
│   ├── repository-overview.md
│   ├── repository-structure.md
│   ├── architecture.md
│   ├── configuration.md
│   ├── dependencies.md
│   ├── data-model.md
│   ├── error-handling.md
│   ├── logging.md
│   ├── security.md
│   ├── testing.md
│   ├── build-and-deployment.md
│   ├── change-guide.md
│   ├── design-decisions.md
│   ├── invariants.md
│   ├── integrations.md
│   ├── state-and-persistence.md
│   ├── concurrency-and-scheduling.md
│   ├── documentation-maintenance.md
│   ├── faq.md
│   ├── troubleshooting.md
│   ├── quick-start.md
│   ├── ambiguities-and-open-questions.md
│   ├── api-usage-examples.md
│   ├── api-reference/
│   │   └── INDEX.md
│   ├── components/
│   │   ├── presentation.md
│   │   ├── host-and-composition.md
│   │   ├── application-services.md
│   │   ├── browser-state-and-localisation.md
│   │   └── integration-models.md
│   ├── flows/
│   │   ├── startup-and-rendering.md
│   │   ├── phone-provisioning.md
│   │   ├── package-deactivation.md
│   │   └── continuous-integration.md
│   └── behaviour/
│       ├── browse-and-search.md
│       └── inspect-edit-delete.md
```

## Maintenance Principles

| Principle | Practice |
|-----------|----------|
| **Single source of truth** | Root docs are authoritative; `docs/` complements with implementation detail |
| **Sync on change** | When script changes, update affected `docs/` files in same commit |
| **No duplication** | `docs/` files reference root docs; don't repeat policy content |
| **Version control** | All docs in Git; history tracks evolution |

## Update Triggers

| Trigger | Files to Review |
|---------|-----------------|
| Script logic change | `architecture.md`, `components/*.md`, `flows/*.md`, `invariants.md` |
| Package catalogue change | `flows/package-deactivation.md`, `change-guide.md`, `data-model.md` |
| Provisioning APK change | `flows/phone-provisioning.md`, `integrations.md`, `dependencies.md` |
| Helper function change | `components/application-services.md`, `change-guide.md` |
| New dependency | `dependencies.md`, `integrations.md`, `build-and-deployment.md` |
| Security issue | `security.md`, `SECURITY.md`, `design-decisions.md` |
| CI workflow change | `flows/continuous-integration.md`, `build-and-deployment.md` |

## Ownership

| Document | Owner | Review Cadence |
|----------|-------|----------------|
| Root docs (README, ARCHITECTURE, etc.) | Maintainers | Per release / major change |
| `docs/` implementation docs | Contributors | Per script change |
| `docs/INDEX.md` | Maintainers | After any `docs/` addition/removal |

## Style Conventions

- **Headings**: ATX style (`#`, `##`, `###`)
- **Code blocks**: Fenced with language (`bash`, `yaml`, `text`)
- **Tables**: GitHub-flavoured markdown pipes
- **Cross-references**: Relative links (`../README.md`, `components/presentation.md`)
- **Emphasis**: `**bold**` for terms, `` `code` `` for identifiers
- **Lists**: `- ` for unordered, `1. ` for ordered

## Validation

```bash
# Check for broken internal links (requires markdown-link-check)
npx markdown-link-check docs/**/*.md

# Check ShellCheck still passes
shopt -s globstar nullglob
shellcheck **/*.sh --severity error
```

## Adding New Documentation

1. Create file in appropriate `docs/` subdirectory
2. Follow existing structure and style
3. Add entry to `docs/INDEX.md` catalogue
4. Update this file if new category added
5. Ensure cross-references from related docs