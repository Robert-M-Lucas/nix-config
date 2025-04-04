sudo echo Sudo acquired

cd ~/nix-config
git pull

sudo cp ./server/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch

git add -A
git commit -a -m "-"
git push