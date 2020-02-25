# Depreciated!
There is an [official package](https://github.com/mozilla-iot/gateway-deb) now, so this repository is no longer needed.

# .deb Packages for the [Mozilla WebThings Gateway](https://iot.mozilla.org/gateway/)
Very basic packages to install the [Mozilla WebThings Gateway](https://iot.mozilla.org/gateway/)

## Platforms
Builds are available for:

| Distro | Version | Arch |
|---|---|---|
| Ubuntu | Bionic (18.04), Eoan (19.10) | x86_64, arm64 |
| Debian | Buster (Stable), Bullseye (Testing) | x86_64 |
| Raspbian | Buster (10), Stretch (9) | armv7

~~Check the [releases](https://github.com/gucci-on-fleek/gateway-deb-package/releases) for downloads. Make sure to download the most recent release for the appropriate platform.~~ **Depreciated!**

## Installing
```bash
sudo apt install ./webthings-gateway-{version}.deb
```
<p align="center"> or </p>

```bash
sudo apt install ./webthings-gateway-{version}.deb --no-install-recommends
```

## Running
```bash
webthings-gateway
```

## Issues
- Many addons do not work.
    - The package does not install the Python bindings so any Python addons will not work. 
    - When using `--no-install-recommends`, most of the hardware-based addons (USB, Bluetooth) will not work because there aren't any libraries.
    - Any addons that need a C/C++ compiler will not work because the package does not install build tools.
- The package does not support changing any network settings.
- Any upgrades must be done with the package manager by downloading a new release from GitHub. Do not upgrade from the Web UI of the gateway or `apt upgrade`.
- The package does not install a service. The gateway must be started manually.
- The gateway stores its data under `~/.mozilla-iot/` instead of `/var/`.
- Not all of the packages have been tested (but most of them have been), so bad things may happen.
- The package is build from the master branch of [upstream](https://github.com/mozilla-iot/gateway), so some of the code may not be very stable.

Most of these issues should be pretty easy to fix, but they just haven't been quite yet.

## Contributing
Submit an issue or a pull request if something isn't working quite right. Please include system specs (distro, architecture) and the version of the package that you used.
