apt-get update
apt-get install -y build-essential npm nodejs python2 git lsb-release --no-install-recommends
cd /root/
git clone --depth 1 --recursive https://github.com/mozilla-iot/gateway
cd gateway

npm install
npm i npm@latest -g
/usr/local/bin/npm audit fix
./node_modules/.bin/webpack --display errors-only
/usr/local/bin/npm dedupe
/usr/local/bin/npm prune --production
/usr/local/bin/npm cache clean --force

cd ..
mkdir -p ./webthings-gateway/DEBIAN
mkdir -p ./webthings-gateway/usr/share/
mkdir -p ./webthings-gateway/usr/bin/
mv ./gateway/ ./webthings-gateway/usr/share/webthings-gateway/
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
echo 'Description: webthings-gateway' >> ./DEBIAN/control
echo 'Depends: python2, nodejs (='$(apt-cache show nodejs | awk '/Version/ {print $2}')'), npm (>=5.8.0)' >> ./DEBIAN/control

cd ..
dpkg-deb --build webthings-gateway