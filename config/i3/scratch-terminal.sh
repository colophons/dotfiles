#!/usr/bin/env bash
set -euo pipefail

# Keep repeated key presses from launching duplicates before Kitty maps its window.
exec 9>"${XDG_RUNTIME_DIR:?}/i3-scratch-terminal.lock"
flock -n 9 || exit 0

scratch_exists() {
    local tree
    tree=$(i3-msg -r -t get_tree) || exit 1
    jq -e 'any(.. | objects; .window_properties.class? == "scratch.terminal")' \
        <<< "$tree" >/dev/null
}

if scratch_exists; then
    i3-msg '[class="^scratch.terminal$"] scratchpad show' >/dev/null
    exit 0
fi

# The for_window rule moves the new terminal into the scratchpad and shows it.
# Do not let the long-lived Kitty process inherit the launch lock.
ghostty --class=scratch.terminal --gtk-single-instance=true 9>&- & #-1 --class scratch-terminal 9>&- &

# Hold the lock until i3 sees the window (up to five seconds).
for ((attempt = 0; attempt < 50; attempt++)); do
    if scratch_exists; then
        exit 0
    fi
    sleep 0.1
done

printf '%s\n' 'Scratch terminal did not appear within five seconds.' >&2
exit 1
