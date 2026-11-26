# IMX477 Raspberry Pi Driver With Apertar Crop Modes

This directory builds a custom `imx477.ko` V4L2 sensor driver for Raspberry Pi.
It is based on Raspberry Pi's upstream `rpi-6.12.y` IMX477 driver, with extra
full-width and 2x2-binned cinema crop modes added for Apertar.

## Added Modes

The stock modes are still present:

- `4056x3040`
- `4056x2160`
- `2028x1520`
- `2028x1080`
- `1332x990`

Additional full-width crop modes:

- `4056x2280` - 16:9
- `4056x2192` - 1.85:1
- `4056x2136` - 1.90:1
- `4056x2028` - 2.00:1
- `4056x1844` - 2.20:1
- `4056x1828` - 2.22:1
- `4056x1728` - 2.35:1
- `4056x1696` - 2.39:1
- `4056x1624` - 2.50:1
- `4056x1592` - 2.55:1

Additional 2x2-binned crop modes:

- `2028x1140` - 16:9
- `2028x1096` - 1.85:1
- `2028x1068` - 1.90:1
- `2028x1014` - 2.00:1
- `2028x922` - 2.20:1
- `2028x914` - 2.22:1
- `2028x864` - 2.35:1
- `2028x848` - 2.39:1
- `2028x812` - 2.50:1
- `2028x796` - 2.55:1

## Install

Install prerequisites on the Pi:

```bash
sudo apt update
sudo apt install build-essential dkms device-tree-compiler raspberrypi-kernel-headers git
```

Build and install:

```bash
cd ~/imx477-v4l2-driver
chmod +x setup.sh
./setup.sh
```

Edit `/boot/firmware/config.txt` on Bookworm/Raspberry Pi OS 64-bit, or
`/boot/config.txt` on older images:

```ini
camera_auto_detect=0
dtoverlay=imx477
```

If the camera is on CAM0:

```ini
camera_auto_detect=0
dtoverlay=imx477,cam0
```

Reboot, then confirm the new modes:

```bash
sudo reboot
modinfo imx477 | grep -E 'filename|version|description'
rpicam-hello --list-cameras
dmesg | grep -Ei 'imx477|camera|unicam|pisp'
```

The `modinfo` output should include:

```text
description:    Sony IMX477 sensor driver with Apertar crop modes
version:        0.0.2-apertar-crops
```

If it does not, Raspberry Pi OS is still loading the stock `imx477` module
instead of this DKMS module.

## Notes

The added crop modes reuse Raspberry Pi's known-good base IMX477 mode register
sets and patch only the active window/output registers at stream start. This
keeps the driver close to upstream and makes the crop behavior easy to audit.

The source driver remains GPL-2.0, matching the upstream Raspberry Pi kernel
driver license.
