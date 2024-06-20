#!/bin/bash

set -e

STEAMCMD=/home/steam/Steam/steamcmd.sh
INSTALL_DIR="${INSTALL_DIR:-/palworld}"
SERVER_OPTS="$SERVER_OPTS"
MULTITHREADING="false"

install_server() {
  su steam -c "FEXBash \"$STEAMCMD +force_install_dir $INSTALL_DIR +login anonymous +app_update 2394010 validate +quit\""
}

is_server_installed() {
    if [[ -e "$INSTALL_DIR/PalServer.sh" ]]; then
        return 0
    fi
    return 1
}

log() {
    case "$1" in
        -i)
            severity="INFO"
            shift
            ;;
        -w)
            severity="WARN"
            shift
            ;;
        -e)
            severity="ERROR"
            shift
            ;;
        *)
            severity="INFO"
            ;;
    esac

    message="$1"
    log_contents="$(printf "[%s] %s\n" "${severity^^}" "$message")"

    if [[ "$severity" = "ERROR" ]]; then
        echo "$log_contents" 2>&1
    else
        echo "$log_contents"
    fi
}

if ! is_server_installed; then
    log "The server hasn't been installed yet."
    install_server
fi

log "Starting the server..."

if [[ "$MULTITHREADING" == "true" ]]; then
    SERVER_OPTS+=("-useperfthreads" "-NoAsyncLoadingThread" "-UseMultithreadForDS")
fi

su steam -c "FEXBash \"$INSTALL_DIR/PalServer.sh $SERVER_OPTS\""
