cd ~/nix-config
codium -w .
read -p "Press enter to git add *"
git add *
echo "Enter commit message:"
read commit_msg
git commit -a -m $commit_msg
git push
read -p "Press enter to switch"
sudo nixos-rebuild --flake .#default switch