#!/bin/sh
# Corner Window

. $WMRC
. util.sh

reads mw mh -- wattr wh $WRT;
SX=$(( LGAP ));
SY=$(( TGAP ));
SW=$(( mw - LGAP - RGAP ));
SH=$(( mh - TGAP - BGAP ));

swc() { # <hv|hh|q|m> <corner> <wid>
    case "$1" in
        hv)
            w=$(( mw/2 - GAP*2 - BW*2 ));
            h=$SH;
            y=$SY;
            case "$2" in
                tl|bl)
                    x=$SX
                    ;;
                tr|br)
                    x=$(( SX + w + BW*2 + GAP ))
                    ;;
            esac
            ;;
        hh)
            h=$(( mh/2 - GAP*2 - BW*2 ));
            w=$SW;
            x=$SX;
            case "$2" in
                tl|tr)
                    y=$SY
                    ;;
                bl|br)
                    y=$(( SY + h + BW*2 + GAP ))
                    ;;
            esac
            ;;
        q)
            w=$(( mw/2 - GAP*2 - BW*2 ));
            h=$(( mh/2 - GAP*2 - BW*2 ));
            x2=$((SX + w + BW*2 + GAP))
            y2=$((SY + h + BW*2 + GAP))
            case "$2" in
                tl)
                    x=$SX;
                    y=$SY;
                    ;;
                tr)
                    x=$x2;
                    y=$SY;
                    ;;
                bl)
                    x=$SX;
                    y=$y2;
                    ;;
                br)
                    x=$x2;
                    y=$y2;
                    ;;
            esac
            ;;
        m) x=$SX; y=$SY; w=$SW; h=$SH; ;;
    esac
    wtp $x $y $w $h $3;
}

getwindowcorner() { # <wid>
    case "$1" in
        0x*) reads wx wy ww wh -- wattr xywh "$1";          ;;
        *)   test $# -eq 2 && wx="$1"; wy="$2"; ww=0; wh=0; ;;
    esac
    cx=$((wx + ww / 2)); cy=$((wy + wh / 2));
    test $cx -lt $(( SW / 2 )) && {
        test $cy -lt $(( SH / 2 )) && {
            echo "tl";
        } || {
            echo "bl";
        }
    } || {
        test $cy -lt $(( SH / 2 )) && {
            echo "tr";
        } || {
            echo "br";
        }
    }
}

getwindowsize() { # <wid>
    reads ww wh -- wattr wh "$1";
    if [ $ww -le $((SW/2)) ] && [ $wh -le $((SH/2)) ]; then
        echo "q";
    elif [ $ww -ge $((SW/2)) ] && [ $wh -le $((SH/2)) ]; then
        echo "hh";
    elif [ $ww -le $((SW/2)) ] && [ $wh -ge $((SH/2)) ]; then
        echo "hv";
    else
        echo "m";
    fi
}

shiftw() { # <direction> <wid>
    wid="$2";
    cnr=$(getwindowcorner $wid);
    siz=$(getwindowsize $wid);
    case $1 in
        left|right)
            case $cnr in
                tl) swc $siz tr $wid ;;
                tr) swc $siz tl $wid ;;
                bl) swc $siz br $wid ;;
                br) swc $siz bl $wid ;;
            esac
            ;;
        up|down)
            case $cnr in
                tl) swc $siz bl $wid ;;
                tr) swc $siz br $wid ;;
                bl) swc $siz tl $wid ;;
                br) swc $siz tr $wid ;;
            esac
            ;;
    esac
}

resizew() { # <direction> <wid>
    wid="$2";
    cnr=$(getwindowcorner $wid);
    siz=$(getwindowsize $wid);
    case $1 in
        left)
            case $siz in
                q) swc hh ${cnr%?}l $wid ;;
                hh) swc q ${cnr%?}l $wid ;;
                hv) swc m ${cnr%?}l $wid ;;
                m) swc hv ${cnr%?}l $wid ;;
            esac
            ;;
        right)
            case $siz in
                q) swc hh ${cnr%?}r $wid ;;
                hh) swc q ${cnr%?}r $wid ;;
                hv) swc m ${cnr%?}r $wid ;;
                m) swc hv ${cnr%?}r $wid ;;
            esac
            ;;
        up)
            case $siz in
                q) swc hv t${cnr#?} $wid ;;
                hh) swc m t${cnr#?} $wid ;;
                hv) swc q t${cnr#?} $wid ;;
                m) swc hh t${cnr#?} $wid ;;
            esac
            ;;
        down)
            case $siz in
                q) swc hv b${cnr#?} $wid ;;
                hh) swc m b${cnr#?} $wid ;;
                hv) swc q b${cnr#?} $wid ;;
                m) swc hh b${cnr#?} $wid ;;
            esac
            ;;
    esac
}

case "$1" in
    -r) resizew $2 $3; fw -p $3 ;;
    -m) shiftw $2 $3; fw -p $3 ;;
    -c) swc q $2 $3; fw -p $3 ;;
    -p) swc q $(getwindowcorner $(wmp)) $2; fw -p $2;
esac
