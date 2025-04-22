#!/usr/bin/env bash

HWP_PACKAGE="hoffice_hwp_2020_amd64.deb"

if [[ ! -e $HWP_PACKAGE ]]; then
  echo "Downloading $HWP_PACKAGE..."
  wget --header="Host: cdn.hancom.com" \
    --header="Referer: https://www.hancom.com/cs_center" \
    https://cdn.hancom.com/pds/hnc/DOWN/gooroom/"$HWP_PACKAGE"
fi

if ! docker image inspect hangul_2020:1.1 >/dev/null 2>&1; then
  docker buildx build -t hangul_2020:1.1 -f Dockerfile --no-cache .
else
  echo "Docker image hangul_2020:1.1 already exists"
fi

LOCATION=${DESTDIR:-~/.local/bin}

# Conditional symlink creation
if [[ -d "$LOCATION" ]]; then
  if [[ ! -e "$LOCATION/run_hwp.sh" ]]; then
    ln -s "$(pwd)/run_hwp.sh" "$LOCATION/"
    echo "Created symlink at $LOCATION/run_hwp.sh"
  else
    echo "Symlink or file already exists at $LOCATION/run_hwp.sh"
  fi
else
  echo "Install location $LOCATION does not exist"
  echo "Set DESTDIR to a valid directory"
fi
