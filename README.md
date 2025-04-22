# Build docker image for Hancom Hangul HWP

This package supports to install Hancom Hangul for Linux in NixOS, Gentoo or
other Linux distributions by using docker.

# Getting Started

## In NisOS or Linux distro with Nix package manager.

If you use NixOS or have [Nix package manager](https://nixos.org/download/) in you distro,
you can simply try to run.

```shell
$ nix run github:erdosxx/hancom_hangul_docker
```
or with file

```shell
$ nix run github:erdosxx/hancom_hangul_docker -- [HWP file]
```

### Adding this App in your NixOS environment.

In your `flake.nix` file, add `hancom-hwp` as an input.

```nix
# flake.nix
inputs = {
    ...
    hancom-hwp = {
      url = "github:erdosxx/hancom_hangul_docker";
    };
}

outputs = { nixpkgs, home-manager, ... }@inputs:
    or
outputs = { nixpkgs, home-manager, hancom-hwp, ...}:
    ...
```

To access the run script, you can add following in your nix file.

```nix
  run_hwp = inputs.hancom-hwp.apps.${pkgs.system}.default.program;
```

or if you don't use `input` as second case.

```nix
  run_hwp = hancom-hwp.apps.${pkgs.system}.default.program;
```

### Checking installation status

This App use [my prebuilt HWP docker image](https://hub.docker.com/repository/docker/maxecho/hangul_2020/general)
in dockerhub. So after runing this, you can find the image as following.

```shell
~ ❯ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hangul_2020   1.1       f51099803df1   55 years ago   3.88GB
```

## For non Nix based distro

### Requirements

To use this you need to install `docker`, `docker-buildx`, `xhost` and `make` programs.

For example in Gentoo linux, install docker and additional tools as following commands.
See [`Gentoo docker WIKI`](https://wiki.gentoo.org/wiki/Docker) for more detailed instruction.

```shell
$ sudo emerge -av app-containers/docker
$ sudo emerge -av docker-cli
$ sudo emerge -av docker-buildx

$ sudo emerge -av sys-devel/make
$ sudo emerge -av xhost
```

### Install

1. Clone this repository.

```shell
$ git clone https://github.com/erdosxx/hancom_hangul_docker.git

```

2. Define `DESTDIR` for the location of the script, `run_hwp.sh`.
   So without definition of it, the default location, `$HOME/.local/bin` is used.

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
hangul_2020    1.1       8f62f4663ad9   23 minutes ago   3.77GB
```

### Uninstall

With the definition of `DESTDIR`, run

```shell
$ export DESTDIR="$HOME/.local/bin"
$ make uninstall
```

### How to use

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

# Tips

## Increase resolution

If you think that zoom level of HWP application is small, you can zoom up by editing
`run_hwp.sh` file. The default scale factor is 1.
For example, to increase it to 1.2, change the value of `QT_SCALE_FACTOR` as following.

```shell
...
  --volume "$HOME":"$HOME" --device=/dev/dri:/dev/dri --env "QT_SCALE_FACTOR=1.2" \
...
```

## Build your own docker image

You can change `Dockerfile` for your own purpose. For non Nix based distro,
the installation process build docker image from `Dockerfile`, it could be enough.
However, for Nix based distro you need to build your own docker image in your dockerhub.

```nix
# flake.nix
  ...
  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        hwpImage = self.packages.${system}.default;
        dockerhubUser = "maxecho";
        imgName = "hangul_2020";
        imgTag = "1.1";
      in {
        packages = {
          default = pkgs.dockerTools.buildImage {
            name = imgName;
            tag = imgTag;

            fromImage = pkgs.dockerTools.pullImage {
              imageName = "${dockerhubUser}/${imgName}";
              imageDigest =
                "sha256:7477dbc6a480000ef5b5c83b97ac524410a79fe9a496fc85aa12a1d6916f1645";
              sha256 = "sha256-/61xydnfRiGDEWzVrsQcbKs5FXTlotV+zSzyd7Hfn9s=";
            };
...
```

For example, in `flake.nix` file, you need to change `dockerhubUser`, `imgNmae`, `imgTag`
`imageDigest` and `sha256`.
according to your dockerhub status.
To prepare my docker image, I used following commands. Please refer to this.

```shell
# For checking current image status
$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hangul_2020   1.1       f51099803df1   55 years ago   3.88GB

# To delete an image.
$ docker rmi hangul_2020:1.1

# Build image with Docker file.
$ bash installer.sh

# Add tag for upload created image to my dockerhub.
# You need to change your own id rather than maxecho.
$ docker tag hangul_2020:1.1 maxecho/hangul_2020:1.1

# login my dockerhub
$ docker login -u maxecho

# Upload image to dockerhub
$ docker push maxecho/hangul_2020:1.1
```
