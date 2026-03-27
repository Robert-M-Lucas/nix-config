{
  pkgs,
  stdenv,
  dpkg,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  ...
}:
stdenv.mkDerivation {
  pname = "go-compare";
  version = "6.52.002";

  src = builtins.path {
    path = /home/robert/nix-config/pkgs/go-configure/local/go-configure-sw-hub-v6.52.002-debian-12-amd64.deb;
    name = "go-configure-sw-hub-v6.52.002-debian-12-amd64.deb";
    sha256 = "sha256-bwD8DgEL0Pkoq9ANaa7A3LK0VVthiN1UTFlfhH13EOc=";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook copyDesktopItems];

  dontWrapQtApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "go-configure-sw-hub";
      exec = "${placeholder "out"}/bin/GPLauncher %f";
      icon = "slg7";
      desktopName = "Go Configure Software Hub";
      comment = "Go Configure Software Hub.";
      keywords = ["GreenPAK" "Designer" "SLG5100X" "Development"];
      categories = ["Utility" "Application"];
      terminal = false;
      mimeTypes = [
        "application/gp3-extension"
        "application/gp4-extension"
        "application/gp5-extension"
        "application/ppak-extension"
        "application/gp6-extension"
        "application/hvp-extension"
        "application/aap-extension"
        "application/ffpga-extension"
        "application/ldo-extension"
        "application/can-extension"
        "application/gcan-extension"
        "application/envm-extension"
      ];
    })
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    libGL
    libxkbcommon
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtquickcontrols2
    # xorg.libxcb-cursor
    xcb-util-cursor
    nss
    nspr
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
    alsa-lib
    xorg.libxshmfence
    xorg.libxkbfile
    graphviz
    cups
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s $out/usr/local/go-configure-sw-hub/bin/GPLauncher $out/bin/GPLauncher
    runHook postInstall
  '';
}
