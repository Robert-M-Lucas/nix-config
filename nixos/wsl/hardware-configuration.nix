{ lib, ... } :
{
  wsl.enable = true;
  wsl.defaultUser = "robert";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}