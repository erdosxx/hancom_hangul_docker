#!/usr/bin/env bash
xhost + >/dev/null 2>&1

INPUT_PATH_FILE=$1

get_absolute_path() {
  local PATH_FILE=$1
  if [[ "$PATH_FILE" = /* ]]; then
    # Already absolute path
    ABS_PATH="$PATH_FILE"
  else
    # Make absolute path
    ABS_PATH="$(pwd)/$PATH_FILE"
  fi
  # Replace home folder name to user due to the mount point in the docker image
  # See following code --volume $HOME:/home/user
  # Ex) /home/gentoo/... -> /home/user/...
  echo "$(echo "$ABS_PATH" | sed 's|^/home/[^/]*|/home/user|')"
}

[[ -z "$INPUT_PATH_FILE" ]] && FILE="" || FILE=$(get_absolute_path "$INPUT_PATH_FILE")

docker run --rm --env DISPLAY="$DISPLAY" --volume /tmp/.X11-unix/:/tmp/.X11-unix/ \
  --volume "$HOME":/home/user --device=/dev/dri:/dev/dri --env "QT_SCALE_FACTOR=1" \
  --entrypoint /root/hwp.sh hangul_2020:1.1 "$FILE"

xhost - >/dev/null 2>&1
