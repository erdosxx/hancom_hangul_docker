# Build docker image for Hancom Hangul HWP

This package supports to install Hancom Hangul for Linux in Gentoo or
other Linux distributions by using docker.

# Requirements

This image is tested in Gentoo Linux with docker.
However, most of Linux distributions can support this.

Install docker and additional tools.
See [`Gentoo docker WIKI`](https://wiki.gentoo.org/wiki/Docker) for more detailed instruction.
`xhost` is required to launch GUI from docker container.

```shell
$ sudo emerge -av app-containers/docker
$ sudo emerge -av docker-cli
$ sudo emerge -av docker-buildx

$ sudo emerge -av sys-devel/make
$ sudo emerge -av xhost
```

# Install

1. Clone this repository.

```shell
$ git clone https://github.com/erdosxx/hancom_hangul_docker.git

```

2. Define `DESTDIR` for the location of the script, `run_hwp.sh`.
   The default location is `$HOME/.local/bin`, so without definition of it,
   the default location is used.

```shell
$ export DESTDIR="$HOME/.local/bin"
```

Run `make`.

```shell
$ make
```

Check the installed docker images as following.

```shell
$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
hangul_2020    1.0       8f62f4663ad9   23 minutes ago   3.77GB
```

# Uninstall

With the definition of `DESTDIR`, run

```shell
$ export DESTDIR="$HOME/.local/bin"
$ make uninstall
```

# How to use

After installation, you can run this as following.

```shell
$ $DESTDIR/run_hwp.sh

```

When the program launched, you can only type English characters.
To type Hangul with English, press `<F8>` key and change to Hangul input mode.
With this, using your local(original) Hangul-English toggle key, you can
type Hangul and English.
As you can find in `run_hwp.sh` file, this docker image
mounts your local `~/Docuemnts` and `~/Downloads` folder to the docker file system.
If you want to change it or add more folders, you can edit `run_hwp.sh` as you want.
