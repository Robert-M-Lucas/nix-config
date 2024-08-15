cd ~/nix-config
git pull
codium -w .
echo "Enter hostname to switch to:"
read hostname
sudo nixos-rebuild --flake .#$hostname switch
read -p "Press enter to git diff"
git diff
read -p "Press enter to git add *"
git add *
echo "Enter commit message:"
read commit_msg
git commit -a -m "$commit_msg"
git push