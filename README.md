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

$ sudo emerge -av xhost
```

# Install

1. Clone this repository.

```shell
$ git clone https://github.com/erdosxx/hancom_hangul_docker.git

```

2. Download Hancom HWP Debian package file, `hoffice-hwp_11.20.0.989_amd64.deb`
   from [this](https://yadi.sk/d/G4vRRdsLZznPng) and move it to this repository.

3. Build docker image.

```shell
$ docker buildx build -t hangul_11.20.0.989:1.0.1 -f Dockerfile .
```

After above command, check created docker image.

```shell
$ docker images
REPOSITORY           TAG       IMAGE ID       CREATED          SIZE
hangul_11.20.0.989   1.0.1     539a5663dca4   26 minutes ago   3.53GB
```

4. Copy running script in your PATH, for exmaple, `~/.local/bin/`.

```shell
$ cp run_hwp.sh ~/.local/bin/
$ chmod 744 ~/.local/bin/run_hwp.sh
```

# How to use

After installation, you can run this as following.

```shell
$ ~/.local/bin/run_hwp.sh

```

When the program launched, you can only type English characters.
To type Hangul with English, press `<F8>` key and change to Hangul input mode.
With this, using your local(original) Hangul-English toggle key, you can
type Hangul and English.
As you can find in `run_hwp.sh` file, this docker image
mounts your local `~/Docuemnts` and `~/Downloads` folder to the docker file system.
If you want to change it or add more folders, you can edit `run_hwp.sh` as you want.