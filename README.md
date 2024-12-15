<div align="center">
    <strong>
        <h1>DynamicDNS</h1>
        Easily update your DNS records with your current IP address for both DuckDNS and Cloudflare.
    </strong>
</div>

## Introduction

Having a dynamic IP address can be a pain when you want to access your home network from outside your home. This is where DynamicDNS comes in. `ddns` is a bash script that can be used to update your DNS records with your current IP address for both DuckDNS and Cloudflare.

> **Note:** Having an public DNS record pointing to your home network can be a security risk and is not recommended unless you know what you are doing.

The recommended way to secure your home network is to use a VPN server like [WireGuard](https://www.wireguard.com/) or [OpenVPN](https://openvpn.net/). using this [guide](https://howtonebie.com/posts/using-proxmox-lxc-to-setup-wireguard) you can setup a **WireGuard** VPN server on your Proxmox server. The guide using [pivpn](https://www.pivpn.io/) for an easy setup.

## Installation

There are some requirements needed in order to install **ddns**. You will **jq** and **curl** installed on your system. If you don't have them installed use the default package manager for your system to install them. Once you have them installed you can then clone the repository and run the following command to install the script.

```bash
git clone https://github.com/MichaelSchaecher/ddns.git
```

Now install the script:

```bash
cd ddns ; sudo make install
```

If you want to install the manpage you will need to have **pandoc** installed on your system. Again use the default package manager for your system to install it.

```bash
sudo make install MANPAGE=y
```

Install with bash completion:

```bash
sudo make install BASH_COMPLETION=y
```

To uninstall the script run:

```bash
sudo make uninstall
```

To clean up the repository run `make clean`.

## Setting Systemd Timer

The command used to update the DNS records with this script can be demonized allowing for hands off automotive way to update the DNS records.

Using the following command to enable the timer:

```bash
sudo ddns [duck|cloudflare] <options-and-arguments-for-updating-record> --service
```

A systemd timer and service script will be created and enabled to run the script at the specified interval.
