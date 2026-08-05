{
  ...
} : {
  users.groups.video = {};
  users.users = {
    robert = {
      description = "Robert Lucas";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel" "networkmanager" "docker" "i2c" "video" "wireshark"];
    };
    guest = {
      description = "Guest";
      password = "guest";
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };
    temp = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };
  };

  users.groups.libvirtd.members = ["robert"];
}