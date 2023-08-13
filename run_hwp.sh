xhost + > /dev/null 2>&1
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v ~/Downloads/:/root/Downloads/ -v ~/Documents/:/root/Documents/ hangul_2020:1.0
xhost - > /dev/null 2>&1
