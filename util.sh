# Utility functions

setwb() { # <scheme> <wid>
    test $# -eq 2 || return $ERRARG;
    wattr $2 || return $ERRWIN;
    isFullscreen $2 && { chwb -s 0 $2; return; }
    case $1 in
        Norm*) chwb -s $BW -c $CNorm $2 ;;
        Foc*)  chwb -s $BW -c $CFoc  $2 ;;
        Attn)  chwb -s $BW -c $CAttn $2 ;;
        None)  chwb -s 0                ;;
        *)     return $ERRARG           ;;
    esac
}

getwid() { # <regex>
    t=$(mktemp)
    for wid in $(lsw); do
        printf '%s\t%s\n' "$wid" \
            "$(xprop -id "$wid" | sed -rn '
                /WM_CLASS/s/^.*"(.*)", "(.*)"$/\1\t\2/p;
                /_NET_WM_NAME/s/^.*"(.*)"$/\1/p;
                /_NET_WM_PID/s/^.*=\s+(.*)$/\1/p' |\
              tr '\n' '\t')"
    done | \
        grep -iE "$@" | cut -f1 >$t;
    if [ "$(wc -l <$t)" -gt 0 ]; then
        cat $t;
    else
        return 1;
    fi
}

isExecutable() { # <func|file>
    type $1 >/dev/null 2>&1;
}

isInt() { # <var>
    test $1 -ne 0 2>/dev/null;
    test $? -ne 2 || return 1;
}

isFullscreen() { # <wid>
    case "$(xprop -id $1 | grep _NET_WM_STATE | cut -d= -f2)" in
        *FULLSCREEN*) return 0; ;;
        *)
            if [ "$(wattr xywh $1)" = "$(wattr xywh $WRT)" ]; then
                return 0;
            else
                return 1;
            fi
            ;;
    esac
}

isFocused() { # <wid>
    test "$(pfw)" = "$1";
}

flag() { # <var>
    test $1 -eq 1;
}

usage() {
    err=$1; shift;
    test $# -gt 0 && echo $@;
    echo "Usage: $(basename $0) $ARGS"
    exit $err;
}

reads() { # <vars..> -- <func>
    # read multiple vars at one time
    read_vars="";
    while [ "$1" != "--" ]; do
        read_vars="$read_vars $1";
        shift;
    done
    shift;
    read $read_vars << END
    $($@)
END
}

trim() { # <length> <command>
    len=$1; shift;
    ${@} | head -c${len};
}
