<div align="right">
    <img
        src="images/logo.svg"
        alt="ddnsd logo"
        width="auto"
        height="300"
    />
</div>

## About

Most IP Addresses provided by ISPs are dynamic, meaning they can change over time. This can be problematic if you want to self-host services like a web/game server vps or vpn. There needs to be a way to update the DNS records automatically when your IP changes. This is where **ddnsd** comes in. **ddnsd** is a **bash** script that runs in the background and checks your public IP address for any changes. If a change is detected, it updates the DNS records of your domain using the [Cloudflare](https://developers.cloudflare.com/dns/manage-dns-records/how-to/managing-dynamic-ip-addresses/) or [DuckDNS](https://www.duckdns.org/) API.

### Features

- **Dynamic DNS Updates**: Automatically updates DNS records when your IP changes.
- **Multiple Providers**: Supports both [Cloudflare](https://www.cloudflare.com/learning/dns/glossary/dynamic-dns/) and [DuckDNS](https://www.duckdns.org/).
- **Configurable**: Easily configure providers settings
- **Domain Management**: Add, delete, and list domains.
- **IP Address Detection**: Automatically detects your public IP address.

### Requirements

For **`ddnsd`** to work correctly, you need a standard server or LXC system with the following. For best results, it is recommended use [Proxmox](https://www.proxmox.com/en/) with an [Debian](https://www.debian.org/) LXC container or full VM server.

- 1.5Ghz CPU or higher
- 1GB RAM or higher (512MB for LXC container)
- 25GB Disk Space or higher (4GB for LXC container)
- Network connection
- **Cloudflare** or **DuckDNS** account.

### Drawbacks

- **VPS/VPN Conflicts**: If you are using a VPN service, you may encounter issues with the Cloudflare proxy. In this case, it is recommended to disable the proxy in the configuration file.
- **Security**: Using HTTP instead of HTTPS for DuckDNS can expose your credentials. It is recommended to use HTTPS whenever possible.
- **Limited to Cloudflare and DuckDNS**: Currently, only these two providers are supported. If you need support for other providers, follow [contributing](#contributing) section on how to contribute to the project.

## Installation

The application is designed to be isntalled on a Debian/Ubuntu system via `apt` package manager. To install **`ddnsd`**, follow the steps provided on the [ropistories](https://repository.howtonebie.com/) webpage. To install on a non-Debian system, you'll to clone the repository `git clone https://github.com/MichaelSchaecher/ddnsd.git` or `gh repo clone MichaelSchaecher/ddnsd` and copy the necessary files to your system.

```console
sudo cp -av ddnsd /usr/bin/
sudo cp -av ddnsd.conf /etc/ddnsd.conf
```

`Pandoc` is required to generate the manpage file. If `pandoc` is installed then run the following command to generate the manpage file:

```console
sudo pandoc -s -t man man/ddnsd.8.md -o /usr/share/man/man8/ddnsd.8
sudo pandoc -s -t man man/ddnsd-conf.8.md -o /usr/share/man/man8/ddnsd-conf.8
sudo mandb
```

## Configuration

The configuration file is located at `/etc/ddnsd.conf`. You should edit this file to set your Cloudflare or DuckDNS credentials, as well as any other settings you wish to customize.

### DDNS Provider

This setting specifies which dynamic DNS provider to use. You can choose between `cloudflare` and `duckdns`. The default is `duckdns`.

> **DDNS_PROVIDER**="duckdns"

### Domain Name

The domain name you want to update. For Cloudflare, this should be the full domain name (e.g., `example.com`), and for DuckDNS, it should be just the subdomain (e.g., `myduckdns`) you created on DuckDNS. The default is `myduckdns`.

```bash
DOMAIN_NAME="myduckdns"
```

### Cloudflare Email

Your Cloudflare account email address. This is required if you are using Cloudflare as your dynamic DNS provider. Example: myemail@email.com

```bash
CLOUDFLARE_EMAIL="myemail@email.com"
```

### API Token

This is the API token for your Cloudflare or DuckDNS account. For Cloudflare, you can create a token with the necessary permissions in your Cloudflare dashboard. For DuckDNS, you can find your token on the DuckDNS website after logging in.

```bash
API_TOKEN="your_api_token_here"
```

### Zone ID

For Cloudflare, this is the Zone ID of your domain. You can find this in your Cloudflare dashboard under the domain settings. This setting is not required for DuckDNS.

```bash
ZONE_ID="your_zone_id_here"
```

### Allow HTTP

This setting allows you to enable insecure connections to the DuckDNS API using HTTP instead of HTTPS. This generally not recommended due to security concerns, but it can be useful in certain situations. The default is `false`.

```bash
ALLOW_HTTP=false
```

### Proxy

For Cloudflare, this setting allows you to enable or disable the proxy for your domain. If set to `true`, Cloudflare will act as a proxy for your domain, providing additional security and performance benefits. The default is `true`.

> **Note**: If you are using a VPN service then you may want to set this to `false` to avoid issues with the proxy. This is true for self-hosted VPN services like [WireGuard](https://www.wireguard.com/) or [OpenVPN](https://openvpn.net/).

```bash
PROXY=true
```

### Keep Alive

This tells Cloudflare how often to renew the DNS record. The default is `3600` seconds (1 hour). In most cases, you can leave this as is, but if you have a dynamic IP address that changes frequently, you may want to set this to a lower value.

```bash
KEEP_ALIVE=3600
```

## Usage

Once you have installed and configured **`ddnsd`**, you can use it to manage your dynamic DNS records. The main command is `ddnsd`, which can be run with various options.

### Basic Command

To run the **`ddnsd`** command, simply execute:

```bash
ddnsd start -u/--update
```

This will check your current IP address and update your DNS records if necessary. The service will run in the background and periodically check for IP changes based on the configuration settings. Once the terminal is closed or `Ctrl+C` is pressed, the service will stop running.

### Options

- `start`: Start the **`ddnsd`** service.
- `stop`: Stop the **`ddnsd`** service.
- `restart`: Restart the **`ddnsd`** service.
- `status`: Display the current status of the **`ddnsd`** service.
- `help`: Display help information for the **`ddnsd`** command.
- `version`: Display the version of **`ddnsd`**.
- `config`: Open the configuration file in the default text editor.

### Flag Options

- `-h`, `--help`: Display help information.
- `-v`, `--version`: Display the version of **`ddnsd`**.
- `-l`, `--list`: List all domains managed by **`ddnsd`**.
- `-a`, `--add`: Add a new domain to the list of managed domains.
- `-d`, `--daemonize`: Run **`ddnsd`** as a daemon in the background.
- `-r`, `--remove`: Remove a domain from the list of managed domains.
- `-u`, `--update`: Force an update of the DNS records for all managed domains.
- `-i`, `--ip`: Display the current public IP address.

## Contributing

Contributions are welcome! If you have suggestions for improvements or new features, please open an issue or submit a pull request on the [GitHub repository](https://github.com/MichaelSchaecher/ddnsd/pulls). Features and bug fixes are always welcome.

## Support

If you encounter any issues or have questions, please open an issue on the [GitHub repository](https://github.com/MichaelSchaecher/ddnsd/issues).

## License

Copyright (c) 2024 under the [GPL-3.0 License](COPYING) all rights reserved.
