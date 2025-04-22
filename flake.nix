{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";
  };

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

            # Need to define when using runAsRoot
            diskSize = 10 * 1024; # 10GB

            # Following runAsRoot to create dynamic home folder occur following error.
            # mount: /tmp/disk/mnt: wrong fs type, bad option, ....
            # Ref: https://github.com/NixOS/nixpkgs/issues/392421
            # runAsRoot = ''
            #!${pkgs.runtimeShell}
            # ${pkgs.dockerTools.shadowSetup}
            # mkdir -p /home/gentoo
            # apt-get update
            # cd /root
            # apt install debconf-utils -y
            # apt-get install -y \
            #   libharfbuzz-icu0 debconf-utils ibus ibus-hangul \
            #   fonts-noto-cjk libglu1 libcurl3-gnutls libcairo2 \
            #   libdbus-1-3 libxcb-dev libx11-xcb-dev libglu1-mesa-dev \
            #   libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
            #   libglib2.0-bin gsettings-desktop-schemas locales locales-all
            # '';
          };
        };

        apps.default = let
          getExe = pkgs.lib.getExe;
          docker = pkgs.lib.getExe pkgs.docker;
          xhost = getExe pkgs.xorg.xhost;
        in {
          type = "app";
          program = getExe (pkgs.writeShellScriptBin "run-hwp.sh" ''
            if ! ${docker} image inspect hangul_2020:1.1 >/dev/null 2>&1; then
              ${docker} load -i ${hwpImage}
            fi

            ${xhost} + >/dev/null 2>&1
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

            # use /home/user in docker image for mount point to current HOME.
            ${docker} run --rm \
              --env DISPLAY="$DISPLAY" \
              --volume /tmp/.X11-unix/:/tmp/.X11-unix/ \
              --volume $HOME:/home/user \
              --device=/dev/dri:/dev/dri \
              --env "QT_SCALE_FACTOR=1" \
              --entrypoint /root/hwp.sh \
              hangul_2020:1.1 "$FILE"

            ${xhost} - >/dev/null 2>&1
          '');
        };

        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [ docker podman xorg.xhost ];
          };
        };
      });
}
