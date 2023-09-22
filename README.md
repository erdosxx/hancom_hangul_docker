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
$ $DESTDIR/run_hwp.sh <filename.hwp>

```

The mount and working directory in docker image is your `$HOME` folder. So
you can use this tool as if it runs without docker environment.
With [LF](https://github.com/gokcehan/lf) and [Ranger](https://github.com/ranger/ranger)
file manager, we can easily open HWP file.
To set LF, for example, please refer to [lfrc file](https://github.com/erdosxx/evoagile_configs/blob/master/lf/.config/lf/lfrc). That is, in `lfrc` file, add following line.

```shell
application/x-hwp|application/x-hwp+zip) setsid -f run_hwp.sh $f >/dev/null 2>&1 ;;
```

For Ranger, for example, see [riffle.conf](https://github.com/erdosxx/evoagile_configs/blob/master/ranger/.config/ranger/rifle.conf) file.
That is, in `rifle.conf` file, add following line.

```shell
ext hwp,  has run_hwp.sh,    X, flag f = run_hwp.sh "$@"
```
