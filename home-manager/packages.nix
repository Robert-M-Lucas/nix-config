{
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    pkgs-unstable,
    home,
    lite,
    ...
}: 
let
    # Adding the local file to the Nix store
    # wolframSH = builtins.fetchurl {
    #     url = "https://raw.githubusercontent.com/Robert-M-Lucas/nix-config/master/home-manager/assets/WolframEngine_13.3.0_LINUX.sh";
    #     sha256 = "96106ac8ed6d0e221a68d846117615c14025320f927e5e0ed95b1965eda68e31";
    # };

    # # Overriding the wolfram-engine package to include the file
    # customWolframEngine = pkgs.wolfram-engine.overrideAttrs (oldAttrs: {
    #     nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wolframSH ];
    # });
    pythonEnv = pkgs.python311.withPackages (ps: with ps; [
        # torchWithCuda
        # Add your Python packages here
        numpy
        scikit-learn
        jupyter
        matplotlib
        pooch
        opencv4
        ffmpeg-python
        pygobject3
        tensorflow
        keras
        pygame
        scikit-image
        trimesh
        # torch-bin
        # torchsde
        # torchvision-bin
        # torchaudio-bin
        # einops
        # transformers
        # tokenizers
        # sentencepiece
        # safetensors
        # aiohttp
        # pyyaml
        # pillow
        # scipy
        # tqdm
        # psutil
        # torchWithCuda

        #non essential dependencies:
        # kornia
        # spandrel
        # soundfile

        # Include libstdc++ for your environment
        # pkgs.libstdcxx5
    ]);
in {
    home.packages = let 
        x = with pkgs; [
    # ====== GUI Apps ======
            libreoffice
            # calibre
            obsidian
            protonvpn-gui
            pomodoro-gtk
            arduino-ide
            krita
            gimp
            obs-studio
            mediawriter
            rpi-imager
            # qimgv # Consider removing
            # libsForQt5.dolphin
            darktable
            # qbittorrent # Removed due to vulnerability atm
            # meld
            blender
            qalculate-gtk
            vesktop
            # steam - stable version seems to not work
            blender
            rare
            musescore
            insomnia
            alacarte
            prismlauncher

    # ====== CMD ======
            platformio-core
            clang-tools
            sl
            # oh-my-fish
            # gh
            rustup
            cloc
            neovim
            # xclip
            nodejs_22
            # wolfram-engine
            ffmpeg
            # clang
            # clang-tools
            # libgcc
            # gnumake
            # cmake
            # extra-cmake-modules
            # stdenv.cc.cc.lib
            pythonEnv
            # zoxide
            nasm
            # blas
            texlive.combined.scheme-full
            # libsForQt5.qtstyleplugin-kvantum
            # libsForQt5.qt5ct
            google-cloud-sdk
            fortune
            zip
            unzip
            xclip
            libqalculate

            pkg-config 
            alsa-lib
            libudev-zero

            legendary-gl

            dconf2nix

            (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
            (writeShellScriptBin "nix-clean" (builtins.readFile ./scripts/nix-clean.sh))

            (writeShellScriptBin "rust-shell" (builtins.readFile ./scripts/rust-shell.sh))
            # (writeShellScriptBin "shell" (builtins.readFile ./scripts/shell.sh))
            # (writeShellScriptBin "shell-pure" (builtins.readFile ./scripts/shell-pure.sh))
            (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
            (writeShellScriptBin "neofetch" (builtins.readFile ./scripts/unneofetch.sh))
            (writeShellScriptBin "gitf" (builtins.readFile ./scripts/gitf.sh))
            
            # (writeShellScriptBin "cdd" (builtins.readFile ./scripts/cdd.sh))
            # (writeShellScriptBin "cdu" (builtins.readFile ./scripts/cdu.sh))

    # ====== IDEs ======
            

    # ====== Extensions ======
            gnomeExtensions.ddterm
            gnomeExtensions.hide-top-bar
            gnomeExtensions.caffeine
            gnomeExtensions.vitals
            gnomeExtensions.enhanced-osk
            gnomeExtensions.blur-my-shell
            gnomeExtensions.appindicator
            gnomeExtensions.shutdowntimer
            gnomeExtensions.color-picker
            # gnomeExtensions.custom-accent-colors
            
            # graphite-gtk-theme
            # gtk-engine-murrine
            # gnome.gnome-themes-extra

    # ====== Other ======
            diff-so-fancy
        ];

        y = with pkgs-unstable; [
            # ====== IDEs ======
            jetbrains.rust-rover
            jetbrains.webstorm
            jetbrains.jdk
            jetbrains.clion
            jetbrains.pycharm-professional
            davinci-resolve
            # gephi
            discord
            # steam
        ];

        z = [
            # overlays.davinci-resolve
        ];

        non-lite = [
            pkgs-unstable.jetbrains.goland
            pkgs-unstable.android-studio
            pkgs-unstable.jetbrains.idea-ultimate
            pkgs-unstable.jetbrains.rider
            # pkgs-unstable.zed-editor
            pkgs-unstable.muse-sounds-manager
            pkgs.jetbrains.pycharm-community
            pkgs.wireshark
        ];
    in
        x ++ y ++ z ++ (if lite then [] else non-lite);
}
