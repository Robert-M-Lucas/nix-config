if [ -z "$1" ]; then
  echo "Usage: $0 <shell-name>"
  exit 1
fi

nix-shell --pure "/home/robert/nix-config/nixos/home-manager/scripts/shells/$1.nix"