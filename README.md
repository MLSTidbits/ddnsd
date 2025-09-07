<div align="center">
    <img
        src="images/logo.png"
        alt="ddnsd logo"
        width="auto"
        height="200"
    />
    <h1><b>DDNSD</b></h1>
    <p>A lightweight Dynamic DNS updater daemon</p>
</div>

## About

`ddnsd` is a lightweight Dynamic DNS updater daemon for Linux (DuckDNS & Cloudflare supported).
It runs as a systemd service and reads a shell-style configuration file.

## Features

- Runs as a systemd service (`ddnsd.service`)
- Supports DuckDNS and Cloudflare providers
- Configured via a plain shell-style config (`KEY=value`)
- Logs available via `journalctl -u ddnsd`

## Installation

### Install from the APT repository

The instructions for adding the [MLS Tidbits](https://mlstidbits.com) APT repository at the [archive](https://archive.mlstidbits.com).

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/MLSTidbits.gpg] https://archive.mlstidbits.com/ stable main" |
sudo tee /etc/apt/sources.list.d/MLSTidbits.list

wget -qO - https://archive.mlstidbits.com/key/MLSTidbits.gpg | sudo dd of=/usr/share/keyrings/MLSTidbits.gpg
```

### Manual install (from source)

Do the following to install `ddnsd` from source for none Debian-based distributions like Fedora, Arch, etc.

```bash
git clone https://github.com/yourusername/ddnsd.git
cd ddnsd
sudo install -m 0755 ddnsd /usr/local/bin/ddnsd
# (copy service file if provided)
sudo cp ddnsd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ddnsd
```

## Configuration

Important: The configuration file is a shell-style file (key=value) located at: `/etc/ddnsd/config`. The script sources this file, so values should be valid shell assignments (no YAML).

### Global variables (defaults shown)

```bash
# What service to use for the IP address lookup. Options are ( ifconfig or icanhaz ):
#     - ifconfig:  A simple service that returns your public IP address in plain text.
#     - ipinfo:    A service that provides your public IP address along with additional information
#                  such as location and ISP.
#     - icanhazip: A popular service that returns your public IP address in plain text.
#
# Default: icanhazip.]
#LOOKUP=icanhazip

# This setting specifies which dynamic DNS provider to use. You can choose between
# cloudflare and duckdns.
#
# Default: duckdns.
#PROVIDER=duckdns

# The domain name you want to update. For Cloudflare, this should be the full domain
# name (e.g., example.com), and for DuckDNS, it should be just the subdomain (e.i.
# myduckdns) you created on DuckDNS.
DOMAIN=example.com

# This is the API token for your Cloudflare or DuckDNS account. For Cloudflare, you can
# create a token with the necessary permissions in your Cloudflare dashboard. For DuckDNS,
# you can find your token on the DuckDNS website after logging in.
#
# Example: 1234567890abcdef1234567890abcdef
TOKEN=1234567890abcdef1234567890abcdef
```

### Cloudflare-specific variables (optional; used when PROVIDER=cloudflare)

```bash
# Your Cloudflare account email address. This is required if you are using Cloudflare
# as your dynamic DNS provider.
# Example: myemail@email.com
EMAIL=example@email.com

# The Zone ID is the unique identifier for your domain in Cloudflare. You can find this in your
# Cloudflare dashboard under the domain settings. This setting is not required for DuckDNS.
# Example: 1234567890abcdef1234567890abcdef
#ID=123456

# Cloudflare uses either a token or global API key for authentication. For most users the token
# is the preferred method.
# default: token
METHOD=token

# For Cloudflare, this is the Zone ID of your domain. You can find this in your Cloudflare
# dashboard under the domain settings. This setting is not required for DuckDNS.
#
# Example: 1234567890abcdef1234567890abcdef
ID=819997954458ad1be79b4ebb71b17b22

# For Cloudflare, this setting allows you to enable or disable the proxy for your domain. If set
# to true, Cloudflare will act as a proxy for your domain, providing additional security and
# performance benefits.
#
#     **Note**: If you are using a VPS/VPN service then you may want to set this to `false`
#               to avoid issues with the proxy. This is true for self-hosted VPN services
#               like [WireGuard](https://www.wireguard.com/) or [OpenVPN](https://openvpn.net/).
#
# Default: true.
PROXY=false

# Time-to-live (TTL) for the DNS record in seconds. This setting controls how long the DNS record
# will be cached by DNS resolvers.
# Values: (60, 120, 300, 3600, 7200, 14400, 21600, 43200, 86400)
# Cloudflare sets the default TTL to 300 seconds (5 minutes or auto) if not specified.
# Default: 300.
#TTL=60
```

### DuckDNS-specific variables (optional; used when PROVIDER=duckdns)

```bash
# This setting allows you to enable insecure connections to the DuckDNS API using HTTP instead
# of HTTPS. This generally not recommended due to security concerns, but it can be useful in
# certain situations.
#
# Default: false.
#INSECURE=false

# Should the output from DuckDNS be more verbose? This setting controls whether
# This helps you see more detailed information about the updates being made.
#
# Default: false.
#VERBOSE=false
```

## Usage

If install from the APT repository, the service should be enabled and started automatically. However, you well need to create and edit the configuration file at `/etc/ddnsd/config` with your settings. When done, restart the service with: `sudo ddnsd restart`.

To verify that the service is running correctly, you can check the status with:

```bash
sudo ddnsd status
```

For manual installation, after copying the service file to `/usr/lib/systemd/system/`, enable and start the service with: Then edit the configuration file at `/etc/ddnsd/config` with your settings. When done, enable and start the service with:

```bash
sudo systemctl enable --now ddnsd.service
```

View live logs: `sudo journalctl -t ddnsd -f`

## Files & locations

- System config: /etc/ddnsd/config
- Version (packaged): /usr/share/doc/ddnsd/version (if installed)
- Systemd unit: ddnsd.service (install location: /etc/systemd/system/ddnsd.service or /lib/systemd/system/ depending on packaging)

## Troubleshooting

- If updates fail, check journalctl -u ddnsd for errors.
- Ensure /etc/ddnsd/config contains valid KEY="value" entries (no YAML).
- For Cloudflare, verify EMAIL, METHOD, TOKEN/API key and ID (zone id) are correct.
- For DuckDNS, ensure DOMAIN matches the DuckDNS subdomain and TOKEN is valid.

## Contact / Support

If problems persist, include the output of:

```bash
sudo journalctl -t ddnsd --no-pager | tail -n 100
```

and your /etc/ddnsd/config (redacting secrets like TOKEN) when requesting help.
