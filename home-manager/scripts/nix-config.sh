cd /home/nix-config

echo "Pre-acquiring sudo"
echo "| [sudo] echo \"Sudo acquired\""
sudo echo "Sudo acquired"

if [ -e /home/robert/.nix-hostname ]; then
    echo "Hostname found at /home/robert/.nix-hostname"
    hostname=$(cat /home/robert/.nix-hostname)
else
    echo "Hostname not found at /home/robert/.nix-hostname"
    echo "> Enter hostname to switch to:"
    read hostname
fi

for arg in "$@"
do
  echo $arg
  if [[ "$arg" == "--apply" ]]; then
    apply_mode=true
    break
  fi
  if [[ "$arg" == "--full" ]]; then
    full_mode=true
    break
  fi
  if [[ "$arg" == "--light" ]]; then
    light_mode=true
    echo Light mode $light_mode
    break
  fi
done

if [[ -z "$full_mode" ]]; then
  echo "> Git pull? (Y/n):"
  read user_input
fi

if [ "$full_mode" == "true" ] || ! ([ "$user_input" == "n" ] && ! [ "$user_input" == "N" ]); then
  echo "| git pull"
  git pull
fi


if [[ -z "$apply_mode" ]] && [[ -z "$full_mode" ]]; then
  codium -w .
fi

echo "| git add"
git add -A


if [[ -z "$full_mode" ]]; then
  echo "> Update flake? (y/N):"
  read user_input
fi

if [ "$full_mode" == "true" ] || [ "$user_input" == "y" ] || [ "$user_input" == "Y" ]; then
    echo "| nix flake update"
    nix flake update
fi



if [ "$light_mode" == "true" ]; then
  echo "| [sudo] sudo nixos-rebuild --flake .#$hostname switch --cores 3 --max-jobs 3"
  sudo nixos-rebuild --flake .#$hostname switch --cores 3 --max-jobs 3
else
  echo "| [sudo] sudo nixos-rebuild --flake .#$hostname switch"
  sudo nixos-rebuild --flake .#$hostname switch
fi


if [[ -z "$full_mode" ]]; then
  read -p "> Press enter to git diff"
  git diff
fi

echo "> Enter commit message:"
read commit_msg
echo "| git commit -a -m \"$commit_msg\""
git commit -a -m "$commit_msg"

echo "| git push"
git push