# Check if a directory name is provided as an argument
if [ -z "$1" ]; then
    cd ..
    exit 0
fi

# Store the target directory name
local target_dir="$1"

# Start with the parent directory
current_dir=$(pwd)
current_dir=$(dirname "$current_dir")

# Loop until the root directory is reached
while [ "$current_dir" != "/" ]; do
    # Check if the target directory exists in the current directory
    if [ -d "$current_dir/$target_dir" ]; then
        cd "$current_dir/$target_dir"
        exit 0
    fi

    # Move up to the parent directory
    current_dir=$(dirname "$current_dir")
done

# Check the root directory separately
if [ -d "/$target_dir" ]; then
    cd "/$target_dir"
    exit 0
fi

# If the directory was not found
echo "Directory $target_dir not found"
exit 1
