xhost + > /dev/null 2>&1

PATH_FILE=$1
PATH_FILE_RM_HEAD_SLASH=${PATH_FILE#/}

if [[ "$PATH_FILE" == "$PATH_FILE_RM_HEAD_SLASH" ]]; then
  FILE=$(pwd)/$PATH_FILE
else  # absolute path
  FILE=$PATH_FILE
fi

docker run --rm --env DISPLAY="$DISPLAY" --volume /tmp/.X11-unix/:/tmp/.X11-unix/ \
  --volume "$HOME":"$HOME" --entrypoint /root/hwp.sh hangul_2020:1.0 "$FILE"
xhost - > /dev/null 2>&1
