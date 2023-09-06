#!/usr/bin/env bash

docker rmi hangul_2020:1.0
rm hoffice_hwp_2020_amd64.deb

LOCATION=${DESTDIR:-~/.local/bin}

if [[ -e "$LOCATION"/run_hwp.sh ]]; then
  rm "$LOCATION"/run_hwp.sh
else
  echo "Cannot find run_hwp.sh in $LOCATION. Please delete it manually."
fi
