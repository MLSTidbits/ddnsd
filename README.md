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

### Debian/Ubuntu

```bash
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
```

```bash
wget -qO - https://raw.githubusercontent.com/MichaelSchaecher/apt-repo/refs/heads/main/key/HowToNebie.gpg |
gpg --dearmor | sudo dd of=/usr/share/keyrings/HowToNebie.gpg
```

### Manual

You can also build the deb package yourself by cloning the repository.

```bash
git clone https://github.com/MichaelSchaecher/ddns.git
cd ddns
```

```bash
make debian
sudo dpkg -i package/*.deb
```

Or just manually copy the files to the correct location.

```bash
sudo cp -av app/usr /
```
