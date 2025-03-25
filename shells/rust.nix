let
  rust-overlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";

  pkgs = import <nixpkgs> {
    # overlays = [ (import rust-overlay) ];
  };
  # toolchain = pkgs.rust-bin.stable.latest.default;
in
  pkgs.mkShell rec {
    # packages = [ toolchain ];

    nativeBuildInputs = with pkgs; [
      openssl
      pkg-config
    ];

    buildInputs = with pkgs; [
      rustup

      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libxcb
      libxkbcommon
      alsa-lib
      libudev-zero
      cairo
      gdk-pixbuf
      graphene
      gtk4
      libadwaita

      gst_all_1.gstreamer
      # Common plugins like "filesrc" to combine within e.g. gst-launch
      gst_all_1.gst-plugins-base
      # Specialized plugins separated by quality
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      # Plugins to reuse ffmpeg to play almost every video format
      gst_all_1.gst-libav
      # Support the Video Audio (Hardware) Acceleration API
      gst_all_1.gst-vaapi

      SDL2

      shaderc
      directx-shader-compiler
      libGL
      vulkan-headers
      vulkan-loader
      vulkan-tools
      vulkan-tools-lunarg
      vulkan-validation-layers
    ];

    shellHook = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath buildInputs)}";
    '';
  }
