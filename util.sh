# Utility functions

setwb() { # <wid> <scheme>
    test $# -eq 2 || return $ERRARG;
    wattr $1 || return $ERRWIN;
    test "$(wattr xywh $1)" != "$(wattr xywh $WRT)" || {
        chwb -s 0 $1;
        return;
    }
    case $2 in
        Norm*) chwb -s $BW -c $CNorm $1 ;;
        Foc*)  chwb -s $BW -c $CFoc  $1 ;;
        Attn)  chwb -s $BW -c $CAttn $1 ;;
        None)  chwb -s 0                ;;
        *)     return $ERRARG           ;;
    esac
}

# getwpos() { # <var_prefix> <wid>
#     test $# -eq 2 || return $ERRARG;
#     test "$1" = "-" && pf="" || pf="$1";
#     read ${pf}x ${pf}y ${pf}w ${pf}h ${pf}id << END
#     $(wattr xywhi $2)
# END
# }

getwid() { # <regex>
    for wid in $(lsw); do
        printf '%s\t%s\n' "$wid" \
            "$(xprop -id "$wid" | sed -rn '
                /WM_CLASS/s/^.*"(.*)", "(.*)"$/\1\t\2/p;
                /_NET_WM_NAME/s/^.*"(.*)"$/\1/p;
                /_NET_WM_PID/s/^.*=\s+(.*)$/\1/p' |\
              tr '\n' '\t')"
    done | \
        grep -iE "$@" | cut -f1 | \
        while read -r result; do
            echo "$result"; # FIXME: exit failure for empty
        done
}

isExecutable() { # <func|file>
    type $1 >/dev/null 2>&1;
}

isInt() { # <var>
    test $1 -ne 0 2>/dev/null;
    test $? -ne 2 || return 1;
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
