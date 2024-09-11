cd ~/nix-config

echo "| Git pull"
git pull

for arg in "$@"
do
  if [[ "$arg" == "--apply" ]]; then
    apply_mode=true
    break
  fi
done

if [[ -z "$apply_mode" ]]; then
  codium -w .
fi


echo "| Git add"
git add *

echo "> Enter hostname to switch to:"
read hostname

echo "> Update flake? (y/N):"
read user_input
if [ "$user_input" = "y" ] || [ "$user_input" = "Y" ]; then
    echo "| Updating flake"
    nix flake update
fi

echo "| Switching"
sudo nixos-rebuild --flake .#$hostname switch

read -p "> Press enter to git diff"
git diff

echo "> Enter commit message:"
read commit_msg
git commit -a -m "$commit_msg"

echo "Git push"
git push