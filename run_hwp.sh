#!/usr/bin/env bash
xhost + > /dev/null 2>&1

INPUT_PATH_FILE=$1

get_absolute_path() {
  local PATH_FILE=$1
  PATH_FILE_RM_HEAD_SLASH=${PATH_FILE#/}

  if [[ "$PATH_FILE" == "$PATH_FILE_RM_HEAD_SLASH" ]]; then
    echo "$(pwd)/$PATH_FILE"
  else  # absolute path
    echo "$PATH_FILE"
  fi
}

[[ -z "$INPUT_PATH_FILE" ]] && FILE="" || FILE=$(get_absolute_path "$INPUT_PATH_FILE")

docker run --rm --env DISPLAY="$DISPLAY" --volume /tmp/.X11-unix/:/tmp/.X11-unix/ \
  --volume "$HOME":"$HOME" --device=/dev/dri:/dev/dri --entrypoint /root/hwp.sh hangul_2020:1.0 "$FILE"

xhost - > /dev/null 2>&1
