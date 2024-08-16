cd ~/nix-config
git pull
codium -w .
git add *
echo "Enter hostname to switch to:"
read hostname
sudo nixos-rebuild --flake .#$hostname switch
read -p "Press enter to git diff"
git diff
echo "Enter commit message:"
read commit_msg
git commit -a -m "$commit_msg"
git push