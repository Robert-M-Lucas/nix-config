echo "> Are you sure you want to clean? (y/N):"

echo "Pre-acquiring sudo"
echo "| [sudo] echo \"Sudo acquired\""
sudo echo "Sudo acquired"

read user_input
if ! ([ "$user_input" = "y" ] || [ "$user_input" = "Y" ]); then
    echo "| Exitting"
    exit
fi

echo "| nix-env --delete-generations old"
nix-env --delete-generations old
echo "| sudo nix-env --delete-generations old"
sudo nix-env --delete-generations old

echo "| nix-store --gc"
nix-store --gc
echo "| sudo nix-store --gc"
sudo nix-store --gc

echo "| nix-collect-garbage -d"
nix-collect-garbage -d
echo "| sudo nix-collect-garbage -d"
sudo nix-collect-garbage -d