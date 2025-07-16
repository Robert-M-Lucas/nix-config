if [ -z "$1" ]; then
  echo "Usage: $0 <flake-name>"
  exit 1
fi

cp -r "/home/robert/nix-config/dev-flakes/$1/." .
direnv allow