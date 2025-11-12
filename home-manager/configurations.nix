{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  is-worktop,
  ...
}: {
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

  # services.kdeconnect = {
  #   enable = true;
  #   package = pkgs.gnomeExtensions.gsconnect;
  # };

  services.flameshot.enable = true;

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
      set -U fish_color_normal CBCCC6
      set -U fish_color_command 5CCFE6
      set -U fish_color_keyword 5CCFE6
      set -U fish_color_quote BAE67E
      set -U fish_color_redirection D4BFFF
      set -U fish_color_end F29E74
      set -U fish_color_error FF3333
      set -U fish_color_param CBCCC6
      set -U fish_color_comment 5C6773
      set -U fish_color_match F28779
      set -U fish_color_selection --background=FFCC66
      set -U fish_color_search_match --background=FFCC66
      set -U fish_color_history_current --bold
      set -U fish_color_operator FFCC66
      set -U fish_color_escape 95E6CB
      set -U fish_color_cwd 73D0FF
      set -U fish_color_cwd_root red
      set -U fish_color_option CBCCC6
      set -U fish_color_valid_path --underline
      set -U fish_color_autosuggestion 707A8C
      set -U fish_color_user brgreen
      set -U fish_color_host normal
      set -U fish_color_host_remote yellow
      set -U fish_color_history_current --bold
      set -U fish_color_status red
      set -U fish_color_cancel --reverse
      set -U fish_pager_color_prefix normal --bold --underline
      set -U fish_pager_color_progress brwhite --background=cyan
      set -U fish_pager_color_completion normal
      set -U fish_pager_color_description B3A06D
      set -U fish_pager_color_selected_background --background=FFCC66
      set -U fish_pager_color_secondary_completion 
      set -U fish_pager_color_secondary_prefix 
      set -U fish_pager_color_selected_prefix 
      set -U fish_pager_color_selected_description 
      set -U fish_pager_color_background 
      set -U fish_pager_color_secondary_background 
      set -U fish_pager_color_secondary_description 
      set -U fish_pager_color_selected_completion
      direnv hook fish | source
    ";
  };

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        james-yu.latex-workshop
        aaron-bond.better-comments
        k--kato.intellij-idea-keybindings
        tamasfe.even-better-toml
        rust-lang.rust-analyzer
        fill-labs.dependi
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools
        # dan-c-underwood.arm
      ]
      ++ (
        if is-worktop
        then
          with pkgs.vscode-extensions; [
            # johnstoncode.svn-scm
          ]
        else []
      );
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
