apt-get update
apt-get install -y ca-certificates build-essential npm nodejs python2.7 git lsb-release --no-install-recommends
cd /root/
git clone --depth 1 --recursive https://github.com/mozilla-iot/gateway
cd gateway

npm config set unsafe-perm true
npm i npm@latest -g
/usr/local/bin/npm config set unsafe-perm true
/usr/local/bin/npm install
/usr/local/bin/npm install modclean -g
/usr/local/bin/npm audit fix
./node_modules/.bin/webpack --display errors-only
/usr/local/bin/npm dedupe
/usr/local/bin/npm prune --production
/usr/local/bin/npm cache clean --force
modclean -r

cd ..
mkdir -p ./webthings-gateway/DEBIAN
mkdir -p ./webthings-gateway/usr/share/webthings-gateway
mkdir -p ./webthings-gateway/usr/bin/
cp -r gateway/build gateway/node_modules gateway/config gateway/package.json gateway/package-lock.json gateway/LICENSE gateway/pagekite.py gateway/src ./webthings-gateway/usr/share/webthings-gateway/
cd ./webthings-gateway/

echo '#!/bin/sh' > ./usr/bin/webthings-gateway
echo 'cd /usr/share/webthings-gateway/' >> ./usr/bin/webthings-gateway
echo 'npm run run-only' >> ./usr/bin/webthings-gateway
chmod +x ./usr/bin/webthings-gateway

echo 'Package: webthings-gateway' > ./DEBIAN/control
echo 'Version: '$(sed -nr 's/^.*"version": "(.*)",.*$/\1/p' ./usr/share/webthings-gateway/package.json)'-'$(lsb_release --codename --short) >> ./DEBIAN/control
echo 'Priority: optional' >> ./DEBIAN/control
echo 'Architecture: '$(dpkg --print-architecture) >> ./DEBIAN/control
echo 'Maintainer: gucci-on-fleek' >> ./DEBIAN/control
echo 'Homepage: https://github.com/gucci-on-fleek/gateway-deb-package' >> ./DEBIAN/control
echo 'Description: Mozilla WebThings Gateway' >> ./DEBIAN/control
echo 'Depends: python2.7, nodejs (='$(dpkg --status nodejs | awk '/Version/ {print $2}')'), npm (>=3.5), ca-certificates' >> ./DEBIAN/control
echo 'Recommends: arping, autoconf, dnsmasq, ffmpeg, git, hostapd, libboost-python-dev, libboost-thread-dev, libbluetooth-dev, libffi-dev, libglib2.0-dev, libnanomsg-dev, libnanomsg5, libtool, libudev-dev, libusb-1.0-0-dev, mosquitto, policykit-1, python-pip, python3-pip, sqlite3'  >> ./DEBIAN/control

cd ..
dpkg-deb --build webthings-gateway
