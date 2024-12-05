# This file defines overlays
{inputs, nixpkgs, ...}: {
    # This one brings our custom packages from the 'pkgs' directory
    additions = final: _prev: import ../pkgs final.pkgs;

    # This one contains whatever you want to overlay
    # You can change versions, add patches, set compilation flags, anything really.
    # https://nixos.wiki/wiki/Overlays
    modifications = final: prev: {
        # mutter = prev.mutter.overrideAttrs (old: {
        #     src = nixpkgs.fetchFromGitLab  {
        #     domain = "gitlab.gnome.org";
        #     owner = "vanvugt";
        #     repo = "mutter";
        #     rev = "triple-buffering-v4-47";
        #     hash = "sha256-145ec3b2c62cba22bc8f5c7a2e8e2fef48f4da8f";
        #     };
        # });
        # example = prev.example.overrideAttrs (oldAttrs: rec {
        # ...
        # });
        # davinci-resolve = prev.davinci-resolve.override (old: {
        #     buildFHSEnv = a: (old.buildFHSEnv (a // {
        #         extraBwrapArgs = a.extraBwrapArgs ++ [
        #             "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
        #         ];
        #     }));
        # });
    };

    # When applied, the unstable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.unstable'
    # unstable-packages = final: _prev: {
    #     unstable = import inputs.nixpkgs-unstable {
    #         system = final.system;
    #         config.allowUnfree = true;
    #     };
    # };
}
