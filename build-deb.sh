#!/bin/bash

NAME="artikliotsing"
VERSION=`cd opt/${NAME} && node -e 'console.log(require("./package").version)'`

DIR=`pwd`
cd opt/$NAME
npm install --production --no-bin-links
cd $DIR

mkdir -p dist
rm -rf dist/${NAME}-${VERSION}_*.deb
fpm -s dir -a all -t deb -n ${NAME} --vendor "Andris Reinman" -m "andris@kreata.ee" -v $VERSION -C . \
  -p dist/${NAME}-VERSION_ARCH.deb \
  -d "nodejs" \
  -d "elasticsearch" \
  -d "redis-server" \
  --description "Otsing Eesti veebimeediast" \
  --after-install "hooks/after-install.sh" \
  --before-remove "hooks/before-remove.sh" \
  etc opt/artikliotsing \
  && echo "Package successfully built"
