---
title: "DDNS"
section: 8
header: "DDNS Manual"
author: Michael L. Schaecher <github.com/MichaelSchaecher>
footer: DDNS
version: 0.15.1
date: 2024-12-13
---

# NAME

ddns - Dynamic DNS (Domain Name System) client

# SYNOPSIS

**ddns** [*command*] \<options\> args..

# DESCRIPTION

**ddns** is a client for updating dynamic DNS records for a domain hosted on *Cloudflare* or a subdomain hosted on *DuckDNS*. It can be used to update the IP address of a domain or subdomain when the IP address of the host changes. This is useful if your internet service provider doesn't provide a static IP address.

# COMMANDS

**duck** [*options*] *<args>* ...
:   Update a DuckDNS subdomain.

**cloudflare** [*options*] *<args>* ...
:   Update a Cloudflare domain.

**help**
:   Show brief help message.

**version**
:   Show version information.

# OPTIONS

## Global Options

**-d**, **--domain** *my.domain.com*
:   The domain or subdomain to update. For DuckDNS this is the subdomain i.e `example.duckdns.org`. For Cloudflare this is the domain that you have registered with Cloudflare i.e `example.com`.

**-t**, **--token** *token*
:   The API token for the DuckDNS or Cloudflare service. For Cloudflare it it recommended to not use the global API, but to create a new API token with the necessary permissions for the domain you want to update.

**-s**, **--service**
:   Create a Systemd Timer to update the DNS record at regular intervals. This is only available on Linux systems with Systemd.

**-D**, **--disable**
:   Disable the Systemd Timer.

**-h**, **--help**
:   Show a more detailed help message for either duck or cloudflare commands.

## Cloudflare Options

**-e**, **--email** *email@address.con*
:   The email address associated with your Cloudflare account.

**-z**, **--zone** *Zone ID*
:   The zone ID for the domain you want to update. This is only required for Cloudflare.

**-p**, **--proxy** *y|n*
:   Enable proxying through Cloudflare. WARNING: This may conflict with some services and/or devices.

**-k**, **--keep**
:   How long to keep the record active in seconds. Default is 300 seconds (5 minutes). See **KEEPING THE RECORD ACTIVE** for more information.

## DuckDNS Options

**-i**, **--insecure** y|n
:   Allow insecure connections to the DuckDNS API. This is not recommended. The default is `false`.

**-v**, **--verbose**
:   Enable verbose output to give more information about the update process.

# KEEPING THE RECORD ACTIVE

When updating a DNS record, the record is set to be active for a certain amount of time. This is to prevent the record from being deleted if the client fails to update the record in the future. The default time is 300 seconds (5 minutes). This can be changed with the `-k` or `--keep` option.

> **NOTE**: The exactable times are [60, 120, 300, 900, 1800, 3600, 43200, 86400] seconds or [1m, 2m, 5m, 15m, 30m, 1h, 12h, 1d] minutes.

# EXAMPLES

To update a DNS record for a domain hosted on Cloudflare setting the record to be active for 1 hour:

```bash
sudo ddns cloudflare -d example.com -t <API_TOKEN> -e <EMAIL> -z <ZONE_ID> -k 3600
```

To update a DNS record for a subdomain hosted on DuckDNS:

```bash
sudo ddns duck -d example.duckdns.org -t <API_TOKEN>
```

# COPYRIGHT

DDNS is licensed under the MIT License Copyright (c) 2024 Michael L. Schaecher
