# Check if an argument was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

cmd="$1"
prev=""
current=$(which "$cmd" 2>/dev/null)

if [ -z "$current" ]; then
    echo "Command '$cmd' not found."
    exit 1
fi

echo "Starting with: $current"

while true; do
    # Resolve symlink if present
    if [ -L "$current" ]; then
        next=$(readlink "$current")
    else
        next="$current"
    fi

    # If no change, break
    if [ "$next" = "$prev" ]; then
        break
    fi

    # Log only if changed
    if [ "$next" != "$current" ]; then
        echo "readlink -> $next"
    fi

    prev="$current"
    current=$(which "$next" 2>/dev/null || echo "$next")

    # Log only if changed
    if [ "$current" != "$next" ]; then
        echo "which    -> $current"
    fi

    # If which fails, assume next is final
    if [ -z "$current" ]; then
        current="$next"
        break
    fi
done

echo "Final resolved path: $current"
