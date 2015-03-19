#!/bin/bash

NAME="artikliotsing"
VERSION=`cd opt/${NAME} && node -e 'console.log(require("./package").version)'`

DIR=`pwd`
cd opt/$NAME
npm install
cd $DIR

mkdir -p dist
rm -rf dist/${NAME}-${VERSION}_*.deb
fpm -s dir -t deb -n ${NAME} -v $VERSION -C . \
  -p dist/${NAME}-VERSION_ARCH.deb \
  -d "nodejs" \
  -d "elasticsearch" \
  -d "redis-server" \
  --description "Otsing Eesti veebimeediast" \
  --before-install "hooks/before-install.sh" \
  --after-install "hooks/after-install.sh" \
  --before-upgrade "hooks/before-upgrade.sh" \
  --after-upgrade "hooks/after-upgrade.sh" \
  --before-remove "hooks/before-remove.sh" \
  etc opt/artikliotsing \
  && echo "Package successfully built"
