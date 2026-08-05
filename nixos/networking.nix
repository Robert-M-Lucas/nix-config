{is-wsl, ...}: {
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  networking.resolvconf.enable = !is-wsl;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [23 3240 10000 41100 10001 3241 502 8081 5173 22 44818 2222];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPorts = [23 3240 10000 41100 10001 3241 502 8081 5173 22 44818 2222];
    trustedInterfaces = ["tailscale0"];
  };

  services.tailscale =
    if is-wsl
    then {}
    else {
      # enable = !is-worktop;
      enable = true;
      useRoutingFeatures = "client"; # acts as client only
      openFirewall = true; # open Tailscale ports
    };

  services.openssh = {
    enable = true;
    allowSFTP = true;
    ports = [22];
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      AllowUsers = ["robert"];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        # "hmac-sha2-512" # Might be less secure - needed for dartssh2
      ];
    };
  };
}
