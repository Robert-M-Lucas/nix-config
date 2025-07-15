if [ -z "$1" ]; then
  echo "Usage: $0 <flake-name>"
  exit 1
fi

nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1"
