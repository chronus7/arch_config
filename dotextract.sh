#!/bin/sh
# -*- coding: utf-8 -*-
# vim: tabstop=4 shiftwidth=4 softtabstop=4 nowrap expandtab

# dotextract.sh
#
# A small tool to quickly symlink dotfiles to their
# respective places.
#
# -- by Dave J (https://github.com/chronus7)

CE="\e[31;1m"
CI="\e[33;1m"
CD="\e[34;1m"
CB="\e[1m"
CC="\e[3m"
CN="\e[m"

DEFAULT_CONFIG="dots.config"
IS_DEBUG=false
IS_TEST=false
CONFIG=$DEFAULT_CONFIG
declare -A VARS
VARS_KEYS=""
SUDO_DIRS=""

function error() { echo -e "${CE}[ERR]${CN} $@" >&2; }
function info() { echo -e "${CI}[INF]${CN} $@"; }
function debug() { $IS_DEBUG && echo -e "${CD}[DBG]${CN} $@"; }
function addline() { echo -e "      $@"; }

function error_exit() { error $@; debug "Aborting because of error.";  exit 1; }

function array_has() { for var in ${@:2}; do if [[ "$var" == "$1" ]]; then return 0; fi; done; return 1; }

function usage() { echo "Usage: $0 [-h] [-d] [-t] [-m] [-c config]"; }
function print_help() { echo -e "
Options:
    -h          Display this message and exit.
    -d          Debug. Prints more stuff.
    -t          Testing. Only displays operations, that will
                be performed but does no actual execution.
                This option implies -d.
    -m          Mono. No colour-output.
    -c config   Use the given config instead of the default
                one ('$DEFAULT_CONFIG').

Configuration File:
    ${CB}[into=<dir>/,sudo=<true|false>]${CN}
        States the directory ${CC}dir${CN} as the target
        directory for the upcoming files and directories.

        ${CC}sudo${CN} indicates, whether the symlinks
        have to be made, using sudo.

        There are no alterations in the format allowed.
        This means, you cannot put spaces around '${CC}=${CN}'
        or '${CC},${CN}'.

    ${CB}#<text>|<empty line>${CN}
        Ignored. '${CC}#${CN}' introduces a comment, but only
        if it is the first character in line.

    ${CB}<text>${CN}
        The file to symlink.

        On symlinking, the given file will be taken from the
        directory, in which this executable lies. The filename
        will be concatenated with the directory, given by above
        statement. There will be no renaming of the file's name."
    exit 0
}

function read_config() {
    [[ -r $CONFIG ]] || error_exit "Not able to read config '$CONFIG'."

    debug "Starting to read configuration file '$CONFIG'"

    category=""
    while read line; do
        # tests like =~ ^# also work, but syntax-highlighting does not support them
        if [[ "${line:0:1}" == "#" || -z $line ]]; then
            debug "Ignoring line: '$line'"
        elif [[ "${line:0:1}" == "[" ]]; then
            category=$(echo $line | cut -d= -f2 | cut -d, -f1)
            has_sudo=$(echo $line | cut -d, -f2 | cut -d= -f2)
            VARS_KEYS="${VARS_KEYS} $category"
            debug "New category: '$category'"
            ${has_sudo:0:-1} && SUDO_DIRS="${SUDO_DIRS} $category" && debug "Category '$category' will be used with sudo"
        elif [[ -z $category ]]; then
            debug "Ignoring line '$line' as of non-existing category."
        else
            prev=${VARS["$category"]}
            VARS["$category"]="$prev $line"
            debug "Adding '$line' to '$category'"
        fi
    done < $CONFIG

    debug "Done, reading the configuration."

    if [[ -z $VARS_KEYS ]]; then
        error "Invalid configuration file."
        addline "No valid categories found."
        exit 1
    fi
}

function link(){
    debug "Starting to link stuff."
    $IS_TEST && addline "Not really: Testing mode only prints all this."

    for k in $VARS_KEYS; do
        s=""
        array_has $k $SUDO_DIRS && s="sudo "
        for f in ${VARS[$k]}; do
            cmdDir=''
            [ -d "${k/\~/${HOME}}" ] || cmdDir="${s}mkdir -p \"$k\""
            cmd="${s}ln -sfT $(pwd)/$f $k$(basename $f)"
            if $IS_TEST; then
                [ -n "$cmdDir" ] && debug $cmdDir
                debug $cmd
            else
                [ -n "$cmdDir" ] && debug $cmdDir
                eval $cmdDir
                debug $cmd
                eval $cmd
            fi
        done
    done

    debug "Done, linking."
    $IS_TEST && addline "Nothing done."
}


function parseargs() {
    while getopts ":hdtmc:" opt; do
        case $opt in
            h)
                usage
                print_help
                ;;
            d)
                IS_DEBUG=true
                ;;
            t)
                IS_TEST=true
                IS_DEBUG=true
                ;;
            m)
                CE=""; CI=""; CD=""; CN=""; CB=""; CC=""
                ;;
            c)
                CONFIG=$OPTARG
                ;;
            \?|*)
                error_exit "Invalid argument -$OPTARG"
                ;;
        esac
    done
}

parseargs "$@"

# moving into correct directory
if [[ ! -f $(basename $0) ]]; then
    debug "Directory of execution is not the directory,"
    $IS_DEBUG && addline "in which the executable lies!"
    prog_dir="$(dirname $0)"
    debug "Moving into directory '$prog_dir'."
    cd "$prog_dir" &> /dev/null
    [[ $? -ne 0 ]] && error_exit "Invalid directory of execution."
    debug "New directory: '$(pwd)'"
fi

# TODO spaces in path-names?!

info "Starting process"
addline "Using config-file: '$CONFIG'"
$IS_DEBUG && addline "Debug mode. Visualized with ${CD}[DBG]${CN}."
$IS_TEST && addline "Testing mode. Only displaying operations. No execution."

read_config

link

info "Done"
