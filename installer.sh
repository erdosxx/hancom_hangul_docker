#!/usr/bin/env bash

HWP_PACKAGE="hoffice_hwp_2020_amd64.deb"

if [[ ! -e $HWP_PACKAGE ]]; then
  wget --header="Host: cdn.hancom.com" \
    --header="Referer: https://www.hancom.com/cs_center" \
    https://cdn.hancom.com/pds/hnc/DOWN/gooroom/"$HWP_PACKAGE"
fi

docker buildx build -t hangul_2020:1.0 -f Dockerfile --no-cache \
  --build-arg GetMyHome="$HOME" .

LOCATION=${DESTDIR:-~/.local/bin}

if [[ -d "$LOCATION" ]]; then
  cp run_hwp.sh "$LOCATION"
else
  echo "The default install location, $LOCATION is not exist."
  echo "Set DESTDIR to your own location."
fi
