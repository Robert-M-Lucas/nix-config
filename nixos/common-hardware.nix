{
  is-wsl,
  ...
} : {
  swapDevices =
    if is-wsl
    then []
    else [
      {
        device = "/swapfile";
        size = 24 * 1024;
      }
    ];  
}