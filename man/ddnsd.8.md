---
title: "DDNSDD"
section: 8
header: "Manual"
author: Michael L. Schaecher <MichaelLeeSchaecher@gmail.com>
footer: DDNSDD
version: 0.8.6
date: 2025-06-21
---

# NAME

ddnsd - Dynamic DNS (Domain Name Service) Daemon

# SYNOPSIS

_ddnsd_ ( start | stop | restart | status | version | help )

# DESCRIPTION

_ddnsd_ is a client for updating dynamic DNS records for a domain hosted on _Cloudflare_ or a subdomain hosted on _DuckDNS_. It can be used to update the IP address of a domain or subdomain when the IP address of the host changes. This is useful if your internet service provider doesn't provide a static IP address.

_start_
: Starts the DDNSD client service. This will run the client in the background and update the DNS records periodically.

_stop_
: Stops the DDNSD client service. This will stop the client from running in the background and updating the DNS records.

_restart_
: Restarts the DDNSD client service. This will stop the client and start it again in the background.

_status_
: Displays the status of the DDNSD client service. This will show whether the client is running or not, and if it is running, how long it has been running.

_version_
: Displays the version of the DDNSD client.

_help_
: Displays the help message for the DDNSD client. This will show the available commands and options.

# SEE ALSO

_ddnsd-config_(8)

# COPYRIGHT

Copyright (c) under the terms of the [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html) license.
