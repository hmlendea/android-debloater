# API Usage Examples

## Not Applicable

Android Debloater is a **standalone Bash script**, not a library or service with a programmatic API.

There are no:
- Public functions to import
- HTTP endpoints to call
- SDKs or client libraries
- Plugin interfaces
- Extension points

## Usage Patterns

The only "API" is the command-line invocation:

```bash
# Direct execution
./android-debloater.sh

# With bash explicitly
bash android-debloater.sh

# Debug trace
bash -x android-debloater.sh
```

## Integration Patterns

### Shell Wrapper

```bash
#!/bin/bash
# wrapper.sh - Example wrapper for automation

set -euo pipefail

LOG_FILE="/var/log/android-debloater-$(date +%Y%m%d-%H%M%S).log"

echo "Starting debloat at $(date)" | tee -a "$LOG_FILE"
./android-debloater.sh 2>&1 | tee -a "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}
echo "Finished with exit code $EXIT_CODE at $(date)" | tee -a "$LOG_FILE"
exit $EXIT_CODE
```

### CI Integration

```yaml
# .github/workflows/device-test.yml (conceptual)
name: Device Test
on: workflow_dispatch
jobs:
  test:
    runs-on: self-hosted  # Requires physical device
    steps:
      - uses: actions/checkout@v4
      - name: Run debloater
        run: ./android-debloater.sh
```

### Ansible/Configuration Management

```yaml
# tasks.yml (conceptual)
- name: Clone android-debloater
  git:
    repo: https://github.com/.../android-debloater.git
    dest: /opt/android-debloater

- name: Run debloater
  command: ./android-debloater.sh
  args:
    chdir: /opt/android-debloater
  become: yes
  become_user: adbuser
```

## No Programmatic Interface

If you need programmatic control, consider:
1. Forking and extracting helper functions into a library
2. Wrapping script execution and parsing console output
3. Using ADB directly for specific operations

See [Change Guide](change-guide.md) for modification patterns.