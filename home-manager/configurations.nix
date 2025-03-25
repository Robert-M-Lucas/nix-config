{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # pkgs.mkShell = {
  #     buildInputs = [
  #         # pkgs.python3
  #         pkgs.libstdcxx5
  #         # (pkgs.python3Packages.your-package-here)
  #     ];
  # };

  programs.git = {
    enable = true;
    userName = "Robert-M-Lucas";
    userEmail = "100799838+Robert-M-Lucas@users.noreply.github.com";
    lfs.enable = true;
    extraConfig = {
      core.pager = "diff-so-fancy | less --tabs=4 -RF";
      interactive.diffFilter = "diff-so-fancy --patch";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fetchFromGitHub {
          owner = "IlanCosman";
          repo = "tide";
          rev = "a34b0c2809f665e854d6813dd4b052c1b32a32b4";
          sha256 = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
        };
      }
    ];
    shellInit = "
            set PATH ~/flutter/bin:$PATH
            export RGH=\"https://github.com/Robert-M-Lucas\"
            export SHS=/home/robert/nix-config/shells
            export RUST_SHELL=/home/robert/nix-config/shells/rust.nix
            export SHLS=/home/robert/nix-config/shells
            export CHROME_EXECUTABLE=google-chrome-stable 
            export ANDROID_HOME=/home/robert/Android/Sdk/
            tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=Yes
            ";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      james-yu.latex-workshop
      aaron-bond.better-comments
      k--kato.intellij-idea-keybindings
      bungcip.better-toml
      rust-lang.rust-analyzer
      serayuzgur.crates
    ];
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
