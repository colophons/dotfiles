#!/usr/bin/env bash
set -euo pipefail

exec 9>"${XDG_RUNTIME_DIR:?}/i3-scratch-hyper.lock"
flock -n 9 || exit 0

tree=$(i3-msg -r -t get_tree)
commands=$(jq -r '
    [
        .. | objects | select(.type? == "workspace")
        | any(.. | objects; .focused? == true) as $current
        | .. | objects
        | select(.window? != null)
        | select((.name // "") | test("^Hyper (Journal|\\w\\d\\w)"))
        | {
            id,
            current: $current,
            size: (if (.name | startswith("Hyper Journal"))
                   then "656 px 800 px" else "532 px 260 px" end)
        }
    ] as $windows
    # If any member is on the focused workspace, hide the whole group.
    # Otherwise bring every member here, including those on other workspaces.
    | any($windows[]; .current) as $hide
    | $windows
    | map("[con_id=\(.id)] move scratchpad"
          + if $hide then ""
            else ", scratchpad show, resize set \(.size)" end)
    | join("; ")
' <<< "$tree")

# No matching windows is a no-op; never send an unqualified scratchpad command.
if [[ -n "$commands" ]]; then
    i3-msg "$commands" >/dev/null
fi
