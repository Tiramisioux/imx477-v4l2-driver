#!/usr/bin/bash
set -e

DRV_VERSION=0.0.3
DRV_IMX=imx477

echo "Uninstalling any previous ${DRV_IMX} module"
for module_name in "${DRV_IMX}" "${DRV_IMX}-dkms"; do
	for module_version in 0.0.1 0.0.2 "${DRV_VERSION}"; do
		if sudo dkms status -m "${module_name}" -v "${module_version}" >/dev/null 2>&1; then
			sudo dkms remove -m "${module_name}" -v "${module_version}" --all || true
		fi
	done
done

sudo rm -rf "/usr/src/${DRV_IMX}-${DRV_VERSION}"
sudo mkdir -p "/usr/src/${DRV_IMX}-${DRV_VERSION}"
sudo cp -r "$(pwd)"/* "/usr/src/${DRV_IMX}-${DRV_VERSION}"
sudo chmod +x "/usr/src/${DRV_IMX}-${DRV_VERSION}/dkms.postinst"

sudo dkms add -m "${DRV_IMX}" -v "${DRV_VERSION}"
sudo dkms build -m "${DRV_IMX}" -v "${DRV_VERSION}"
sudo dkms install -m "${DRV_IMX}" -v "${DRV_VERSION}"

echo "Installed ${DRV_IMX} ${DRV_VERSION}. Reboot before testing the new modes."
echo "After reboot, run: modinfo imx477 | grep -E 'filename|version|description'"
