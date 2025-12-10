cd ~/nix-config/shells
git pull
codium -w .
read -p "Press enter to git diff"
git diff
read -p "Press enter to git add *"
git add *
echo "Enter commit message:"
read commit_msg
git commit -a -m "$commit_msg"
git push