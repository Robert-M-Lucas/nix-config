# Check if a directory name is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_name>"
    exit 0
fi

local target_dir="$1"

# Initialize the queue with the current directory
local queue=("./")

# BFS loop
while [ ${#queue[@]} -gt 0 ]; do

    # Dequeue the first directory
    local current_dir="${queue[1]}"
    queue=("${queue[@]:1}")

    # Check if the target directory exists in the current directory
    # echo $current_dir$target_dir
    if [ -d "$current_dir$target_dir" ]; then
        cd "$current_dir$target_dir"
        exit 0
    fi

    # echo "CD: $current_dir"

    # Enqueue all subdirectories
    setopt CSH_NULL_GLOB
    setopt NULL_GLOB
    local subdirs=("$current_dir"*)
    for subdir in "${subdirs[@]}"; do
        # echo "    $subdir"
        # Only add directories to the queue
        if [ -d "$subdir" ]; then
            queue+=("$subdir/")
        fi
    done
done

# If the directory was not found
echo "Directory $target_dir not found"
exit 1