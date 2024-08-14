{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Robert-M-Lucas";
    userEmail = "100799838+Robert-M-Lucas@users.noreply.github.com";
    lfs.enable = true;
  };
}