# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

`ddnsd` is a Bash-based Dynamic DNS updater daemon for Linux. It runs as a systemd service, polls for public IP changes every 5 minutes, and updates DNS records via DuckDNS or Cloudflare APIs. The entire program is a single Bash script (`src/ddnsd`) with a shell-style config template (`src/config`).

## Build commands

```bash
make          # Build: converts man/*.md → _build/man/* via pandoc, copies src/* to _build/
make clean    # Remove _build/
make install  # Install binary to /usr/bin/ddnsd and man pages to /usr/share/man/
```

Build dependency: `pandoc` must be installed to convert Markdown man pages.

Runtime dependencies: `curl`, `jq`, `nano` (or `$EDITOR`), `systemd`.

## Debian packaging

```bash
dpkg-buildpackage -us -uc    # Build .deb packages (requires debhelper, pandoc, dh-make, git)
```

Packaging metadata lives in `debian/`. The service unit is at `debian/ddnsd.service`; it sources `/etc/ddnsd/config` as an `EnvironmentFile`.

## Architecture

The entire daemon logic is in `src/ddnsd` (a single Bash script). Key design points:

- **Entry point**: the `case "${1}"` block at the bottom dispatches subcommands (`start`, `stop`, `restart`, `status`, `config`, `help`, `version`).
- **IP monitoring loop**: `monitor-ip-address()` runs an infinite `while true` loop sleeping 5 minutes between checks. It compares the live IP from `check-ip()` against the saved IP in `/var/lib/ddnsd/current_ip`.
- **Provider dispatch**: when an IP change is detected, `monitor-ip-address()` calls either `duck-ddns()` or `cloudflare-ddns()` based on `$ddnsProvider`.
- **Logging**: all output goes through `event-log()`, which calls `logger` to write to the system journal under the `ddnsd` tag. `critical` events call `exit 1`.
- **Config sourcing**: `/etc/ddnsd/config` is a shell-style key=value file sourced at startup. Variables are mapped to internal names (e.g. `PROVIDER` → `$ddnsProvider`).
- **State file**: `/var/lib/ddnsd/current_ip` stores the last-known public IP across restarts.

## Config variable mapping

| Config key | Internal variable | Default |
|------------|-------------------|---------|
| `LOOKUP`   | `$ipLookup`       | `icanhazip` |
| `PROVIDER` | `$ddnsProvider`   | `duckdns` |
| `DOMAIN`   | `$domainName`     | — |
| `TOKEN`    | `$apiToken`       | — |
| `EMAIL`    | `$emailAddress`   | Cloudflare only |
| `METHOD`   | `$methodType`     | `token` |
| `ZONE`     | `$apiZone`        | Cloudflare only |
| `PROXY`    | `$useProxy`       | `false` |
| `TTL`      | `$timeToLive`     | `300` |
| `INSECURE` | `$useInsecure`    | DuckDNS only |
| `VERBOSE`  | `$verboseOutput`  | DuckDNS only |

## Manual pages

Source files are Markdown in `man/` (`ddnsd.1.md`, `ddnsd.conf.5.md`). `make` converts them to roff via `pandoc -s -t man`.

## Linting

No automated lint step in the Makefile. `shellcheck` is the appropriate tool for linting `src/ddnsd` and `src/completion/ddnsd`. Existing `# shellcheck disable=SC…` directives are intentional.
