{
  outputs,
  use-cuda,
  ...
} : {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      cudaSupport = use-cuda;
      android_sdk.accept_license = true;
      # permittedInsecurePackages = [
      #   "dotnet-sdk-6.0.428"
      # ];
    };
  };
}