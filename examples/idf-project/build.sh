#!/usr/bin/env bash
set -e

RED="\e[31m"
ENDCOLOR="\e[0m"

if ! command -v idf.py &>/dev/null; then
    echo -e "${RED}===============================${ENDCOLOR}"
    echo -e "${RED}Loading esp-idf...${ENDCOLOR}"
    source /opt/esp-idf/export.sh >/dev/null
fi

echo -e "${RED}===============================${ENDCOLOR}"
echo -e "${RED}Building dcode component... ${ENDCOLOR}"

if [[ -e /opt/ldc-xtensa/bin/ldc2 ]]; then
    echo -e "${RED}Using local ldc-xtensa install${ENDCOLOR}"
    dub build --root=dcode --compiler=/opt/ldc-xtensa/bin/ldc2 --build=release
elif docker -v &>/dev/null; then
    echo -e "${RED}Using esp-dlang docker image${ENDCOLOR}"
    docker run --rm --tty --volume="${PWD}/dcode:/work/dcode" jmeeuws/esp-dlang dub build --root=dcode --build=release
else
    echo -e "${RED}No local ldc-xtensa or working docker installation was found!${ENDCOLOR}"
    echo -e "${RED}Aborting...${ENDCOLOR}"
    exit 1
fi

echo -e "${RED}===============================${ENDCOLOR}"
echo -e "${RED}Building other idf components... ${ENDCOLOR}"
idf.py build

echo -e "${RED}===============================${ENDCOLOR}"
