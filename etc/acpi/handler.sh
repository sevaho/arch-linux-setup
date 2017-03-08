#!/bin/bash

case "$1" in
    button/volumeup)
        case "$2" in
            VOLUP)
                logger 'volumeup pressed'
                 amixer -c1 -q sset Master 5%+  
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/volumedown)
        case "$2" in
            VOLDN)
                logger 'volumedown pressed'
                 amixer -c1 -q sset Master 5%-
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    jack/headphone)
        case "$3" in
            plug)
                logger 'headphone jack plugged'
                amixer -c1 -q sset Speaker mute
                ;;
            unplug)
                logger 'headphone jack unplugged'
                amixer -c1 -q sset Speaker unmute
                ;;
        esac
        ;;

   button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;

    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                ;;
            open)
                logger 'LID opened'
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
    esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et: