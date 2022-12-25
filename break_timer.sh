#!/bin/bash

SCRIPT_DIR=`dirname $0`
source $SCRIPT_DIR/break_timer.cfg || exit

waittime=$worktime

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
