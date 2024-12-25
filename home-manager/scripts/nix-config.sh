cd ~/nix-config

echo "Pre-acquiring sudo"
echo "| [sudo] echo \"Sudo acquired\""
sudo echo "Sudo acquired"

for arg in "$@"
do
  if [[ "$arg" == "--apply" ]]; then
    apply_mode=true
    break
  fi
  if [[ "$arg" == "--full" ]]; then
    full_mode=true
    break
  fi
done

if [[ -z "$full_mode" ]]; then
  echo "> Git pull? (Y/n):"
  read user_input
fi

if [ "$full_mode" == "true" ] || ! ([ "$user_input" == "n" ] && ! [ "$user_input" == "N" ]); then
  echo "| Git pull"
  git pull
fi


if [[ -z "$apply_mode" ]] && [[ -z "$full_mode" ]]; then
  codium -w .
fi

echo "| Git add"
git add -A

echo "> Enter hostname to switch to:"
read hostname

if [[ -z "$full_mode" ]]; then
  echo "> Update flake? (y/N):"
  read user_input
fi

if [ "$full_mode" == "true" ] || [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
    echo "| Updating flake"
    nix flake update
fi

echo "| [sudo] Switching"
sudo nixos-rebuild --flake .#$hostname switch

if [[ -z "$full_mode" ]]; then
  read -p "> Press enter to git diff"
  git diff
fi

echo "> Enter commit message:"
read commit_msg
git commit -a -m "$commit_msg"
  
echo "Git push"
git push