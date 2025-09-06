sudo echo Sudo acquired

cd ~/nix-config

echo "| git pull"
git pull

echo "| sudo cp /home/robert/nix-config/server/configuration.nix /etc/nixos/configuration.nix"
sudo cp /home/robert/nix-config/configuration.nix /etc/nixos/configuration.nix

echo "| sudo nixos-rebuild switch"
sudo nixos-rebuild switch

echo "| git add -A"
git add -A
echo "| git commit -a"
git commit -a -m "-"
echo "| git push"
git push