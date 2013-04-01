#!/bin/sh

##
# usage:
#   question "Are you good?"
#   answer=$?
#   if [ $answer -eq 1 ]; then
#     echo "ok"
#   fi
function question() {
    message=$1
    form_message="$message (y/n) "
    answer=0
    
    while true; do
        read -p "$form_message" yn
        case $yn in
            [Yy]* ) answer=1; break;;
            [Nn]* ) answer=0; break;;
            * ) echo "$form_message";;
        esac
    done

    return $answer
}

function t_cols {
    echo `tput cols`
}

function t_rows {
    echo `tput lines`
}

WIDTH=`t_cols`
HEIGHT=`t_rows`

function center() {
    offset=$1
    msg=$2
    len=${#msg}
    (( pos_w = ($WIDTH - $len) / 2 ))
    (( pos_h = $HEIGHT / 2 + $offset ))
    tput cup $pos_h $pos_w
    echo "$msg\c"
}

function right() {
    offset=$1
    msg=$2
    len=${#msg}
    (( pos_w = $WIDTH - $len ))
    (( pos_h = $HEIGHT / 2 + $offset ))
    tput cup $pos_h $pos_w
    echo "$msg\c"
}

function left() {
    offset=$1
    msg=$2
    len=${#msg}
    (( pos_w = 0 ))
    (( pos_h = $HEIGHT / 2 + $offset ))
    tput cup $pos_h $pos_w
    echo "$msg\c"
}

function cstr() {
    ESC="\033[0;"
    color=$1
    message=$2
    echo "${ESC}${color}m${message}${ESC}0m"
}

function red() {
    echo "`cstr 31 $1`"
}

function green() {
    echo "`cstr 32 $1`"
}

function yellow() {
    echo "`cstr 33 $1`"
}

function blue() {
    echo "`cstr 34 $1`"
}

function magenta() {
    echo "`cstr 35 $1`"
}

function cyan() {
    echo "`cstr 36 $1`"
}

function rep() {
    n=$1
    msg=$2
    ret=""
    for (( c=0; c<n; c++))
    do
        ret="${ret}${msg}"
    done
    echo "$ret"
}

function blink_str() {
    s=$1
    m=$2
    msg=$3
    doit=`expr $s / $m`

    (( doit = ($s / $m) % 2 ))
    
    ret=""
    if [ $doit -eq 1 ]; then
        ret="$msg"
    fi
    echo "$ret"
}

function slash_bar {
    p=$1
    m=$2
    
    (( percent = $p % $m ))
    (( len = $WIDTH * $p / 100 )) 

    msg=`rep $len "-"`
    echo "$msg"
}

function loading_message() {
    i=$1
    
    (( p = $i % 4 ))
    [ $p -eq 0 ] && car='/'
    [ $p -eq 1 ] && car='-'
    [ $p -eq 2 ] && car='\'
    [ $p -eq 3 ] && car='|'

    [ $p -eq 0 ] && load_msg='loading.    '
    [ $p -eq 1 ] && load_msg='loading..   '
    [ $p -eq 2 ] && load_msg='loading...  '
    [ $p -eq 3 ] && load_msg='loading.... '

    msg=`printf "$load_msg %s %3d" $car $i`
    echo "$msg%"
}

function animate() {
    i=0
    limit=200

    while true; do
        (( i += 1 ))
        echo "\r\c"
        clear

        (( pos = $i % 100 ))
        (( phase = $i / 100 ))

        if [ $phase -eq 0 ]; then
            msg=`loading_message $pos`
            center 0 "$msg"
        elif [ $phase -eq 1 ]; then
            msg=`blink_str $pos 5 "Welcome to System2 Club."`
            center 0 "$msg"
            msg=`slash_bar $pos 100`
            #msg=`red "$msg"`
            right 1 "$msg"
            left -1 "$msg"
        fi

        sleep 0.05

        if [ $i -gt $limit ]; then
            echo "\r\c"
            break;
        fi
    done

    echo "done."
}

##
# main
# 

animate
