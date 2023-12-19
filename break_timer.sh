#!/bin/bash

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/break_timer.cfg || exit
absolute_dir=`pwd $0`
script_name=`basename $0`

waittime=$worktime

# Enables user systemd unit to auto-start break timer.
function enable_systemd() {
    user_systemd_dir=$HOME/.config/systemd/user
    mkdir -p $user_systemd_dir
    cp $SCRIPT_DIR/breaktimer.service $user_systemd_dir
    sed -i "s|<script>|$absolute_dir/$script_name|g" $user_systemd_dir/breaktimer.service
    systemctl --user enable breaktimer.service
}

if [ -n "$1" ]; then
    case "$1" in
        enable_systemd )
            enable_systemd
            ;;
        help )
            echo "Commands: enable_systemd"
            ;;
        * )
            echo "unknown command"
            ;;
    esac
    exit
fi

while true
do
    sleep $waittime
    answer=$(zenity --info --text='<span font="26" foreground="Green">Time for a break!</span>' \
        --extra-button "Snooze (${snoozetime})" --extra-button "Restart" --modal \
    )
    if [[ $answer == "" ]]; then
        sleep $breaktime
        zenity --info --text='<span font="26" foreground="Green">Time to focus.</span>' --modal
        waittime=$worktime
        continue
    elif [[ $answer == Snooze* ]]; then # Snooze button.
        waittime=$snoozetime
        continue
    else # Restart button. Restarts focus period.
        waittime=$worktime
        continue
    fi
done
