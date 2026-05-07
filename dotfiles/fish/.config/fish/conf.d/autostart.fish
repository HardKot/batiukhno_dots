if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1; and uwsm check may-start
        exec uwsm start hyprland
    end
end
