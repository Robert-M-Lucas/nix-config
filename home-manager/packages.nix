{
  pkgs,
  pkgs-unstable,
  pkgs-jb,
  is-pc,
  is-worktop,
  is-wsl,
  ...
}: let
  Trio-UnifiedApi = pkgs.python312Packages.buildPythonPackage rec {
    pname = "Trio-UnifiedApi";
    version = "1.2.1rc1";

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/d9/b0/2ede950a6a7f50fa622c7164ef67fa723d7d75c628de93c184fb60289b7b/trio_unifiedapi-1.2.1rc1-cp312-cp312-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      sha256 = "sha256-g0U9tUvZXkIUs47iCX8378IXPVDW/Y/35bkVxJr+H9g=";
    };

    format = "wheel";

    build-system = with pkgs.python312Packages; [
    ];

    propagatedBuildInputs = with pkgs.python312Packages; [
    ];

    doCheck = false;
  };

  mdx-spanner = pkgs.python312Packages.buildPythonPackage rec {
    pname = "mdx_spanner";
    version = "0.1.0";

    src = pkgs.python312Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-5yNFgAqbhnQS3Dy3scU9vy7TJ72vVZkX+RB69i6sE7M=";
    };

    pyproject = true;

    build-system = with pkgs.python312Packages; [
      setuptools
    ];

    propagatedBuildInputs = with pkgs.python312Packages; [
      markdown
    ];

    doCheck = false;
  };

  zensical-custom = pkgs.python312Packages.buildPythonApplication rec {
    pname = "zensical";
    version = "0.0.31";
    pyproject = true;

    # We fetch from PyPi, because GitHub repo does not contain all sources.
    # The publish process also copies in assets from zensical/ui.
    # We could combine sources, but then nix-update won't work.
    src = pkgs.python312Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-nBLwe95wxL/bE9bK4b7fjRgGTSV6boESihUlArKKj8M=";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-5lsL42TYg7AsnCxzLcg/KEewcTKLBKvRMJtu+fBkgeY=";
    };

    nativeBuildInputs = with pkgs.rustPlatform; [
      maturinBuildHook
      cargoSetupHook
    ];

    dependencies = with pkgs.python312Packages; [
      click
      deepmerge
      markdown
      pygments
      pymdown-extensions
      pyyaml
      mdx-spanner
      mdx-truly-sane-lists
      colorama
    ];

    # nativeCheckInputs = [ pkgs.testers.versionCheckHook ];
    # versionCheckProgramArg = "--version";
  };

  pythonEnv = pkgs.python312.withPackages (
    ps: (with ps; [
        numpy
        scikit-learn
        jupyter
        matplotlib
        pooch
        opencv4
        ffmpeg-python
        pygobject3
        pygame
        scikit-image
        trimesh
        notebook
        beautifulsoup4
        lxml
        requests
        termcolor
        flask
        pynput
        pyautogui
        keyboard
        websockets
        standard-telnetlib
        numpy
        matplotlib
        west
        jsonschema
        tree-sitter
        tree-sitter-grammars.tree-sitter-c
        python-docx
        minify-html
        beautifulsoup4
        textual
        markdown
        mdx-spanner
        Trio-UnifiedApi
      ]
    )
  );
in {
  home.packages = let
    minimal = with pkgs; [
      # ====== CMD ======
      home-manager
      pythonEnv
      clang-tools
      cmake
      ninja
      sl
      rustup
      cloc
      nasm
      fortune
      zip
      unzip
      libqalculate
      pkg-config
      libudev-zero
      dconf2nix
      lcov
      poetry
      valgrind
      pipes-rs
      cbonsai
      asciiquarium
      nyancat
      neo
      delta
      podman
      nodejs_22
      ffmpeg
      nixd
      nixfmt
      glab
      subversion
      musl
      musl.dev

      # ====== Scripts ======

      (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
      (writeShellScriptBin "nix-clean" (builtins.readFile ./scripts/nix-clean.sh))

      (writeShellScriptBin "flake" (builtins.readFile ./scripts/flake.sh))

      (writeShellScriptBin "rust-shell" (builtins.readFile ./scripts/rust-shell.sh))
      (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
      (writeShellScriptBin "neofetch" (builtins.readFile ./scripts/unneofetch.sh))
      (writeShellScriptBin "gitf" (builtins.readFile ./scripts/gitf.sh))
      (writeShellScriptBin "chx" (builtins.readFile ./scripts/chx.sh))
      (writeShellScriptBin "where" (builtins.readFile ./scripts/where.sh))
      (writeShellScriptBin "netports" (builtins.readFile ./scripts/netports.sh))
      (writeShellScriptBin "docker-nuke" (builtins.readFile ./scripts/docker-nuke.sh))
      (writeShellScriptBin "genpass" (builtins.readFile ./scripts/genpass.sh))

      (writeShellScriptBin "prores" (builtins.readFile ./scripts/prores.sh))
      (writeShellScriptBin "mp4" (builtins.readFile ./scripts/mp4.sh))
      (writeShellScriptBin "nft" (builtins.readFile ./scripts/nft.sh))

      (writeShellScriptBin "wbb" (builtins.readFile ./scripts/wbb.sh))
      (writeShellScriptBin "exp" (builtins.readFile ./scripts/exp.sh))
      (writeShellScriptBin "flameshot-gui" (builtins.readFile ./scripts/flameshot-gui.sh))
    ];
    general = with pkgs; [
      # ====== CMD ======
      platformio-core
      qemu
      spotdl
      winetricks
      distrobox
      texlive.combined.scheme-full
      wineWowPackages.stableFull
      xclip

      # ====== GUI Apps ======
      onlyoffice-desktopeditors
      gnome-solanum
      qalculate-gtk
      insomnia
      alacarte
      gthumb
      amberol
      emblem
      spotify
      gnome-clocks
      impression
      smile
      resources
      hieroglyphic
      boxbuddy
      meld
      teams-for-linux
      libusb1
      glib
      krb5

      # ====== IDEs ======
      arduino-ide

      # ====== Extensions ======
      gnome-shell-extensions
      gnomeExtensions.ddterm
      gnomeExtensions.hide-top-bar
      gnomeExtensions.caffeine
      gnomeExtensions.vitals
      gnomeExtensions.blur-my-shell
      gnomeExtensions.appindicator
      gnomeExtensions.color-picker
    ];

    pc-only = [
    ];

    fastop-only = [
    ];

    non-work = [
      # ====== GUI Apps ======
      pkgs.prismlauncher
      pkgs.keypunch
      pkgs.unityhub
      pkgs.legendary-gl
      pkgs.cutechess

      pkgs.calibre
      pkgs-unstable.discord
      pkgs-unstable.darktable
      pkgs-unstable.muse-sounds-manager
      pkgs-unstable.upscayl
      pkgs-unstable.davinci-resolve

      # ====== CMD ======
      pkgs.google-cloud-sdk
      pkgs.gradle
      pkgs.diesel-cli
      pkgs.dotnet-sdk
      pkgs.android-tools
      pkgs.yt-dlp
      pkgs.fastchess

      # pkgs.Chess-Coding-Adventure
    ];

    work-only = [
      pkgs.gitkraken
      pkgs.go-configure
      pkgs.gtkwave
      pkgs.iverilog
      zensical-custom
      pkgs.gcc-arm-embedded
    ];

    jetbrains-ides = [
      pkgs-jb.jetbrains.rust-rover
      pkgs-jb.jetbrains.webstorm
      pkgs-jb.jetbrains.clion
      pkgs-jb.jetbrains.pycharm
      pkgs-jb.android-studio
      pkgs-jb.jetbrains.idea
      pkgs-jb.jetbrains.goland
      pkgs-jb.jetbrains.rider
    ];
  in
    (
      if is-wsl
      then minimal
      else minimal ++ general
    )
    ++ (
      if !is-worktop && !is-wsl
      then jetbrains-ides
      else []
    )
    ++ (
      if is-wsl
      then []
      else
        (
          if is-worktop
          then work-only
          else non-work
        )
    )
    ++ (
      if !is-worktop && !is-wsl
      then
        (
          if is-pc
          then pc-only
          else fastop-only
        )
      else []
    );
}
