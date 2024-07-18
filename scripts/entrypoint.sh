#!/bin/bash

set -e

STEAMCMD=/home/steam/Steam/steamcmd.sh
INSTALL_DIR="${INSTALL_DIR:-/palworld}"
SERVER_OPTS="$SERVER_OPTS"
MULTITHREADING="false"

install_server() {
  FEXBash "$STEAMCMD +force_install_dir $INSTALL_DIR +login anonymous +app_update 2394010 validate +quit"
}

is_server_installed() {
    if [[ -e "$INSTALL_DIR/PalServer.sh" ]]; then
        return 0
    fi
    return 1
}

log() {
    severity="$1"
    message="$2"
    printf "[%s] %s\n" "${severity^^}" "$message"
}

if ! is_server_installed; then
    log info "The server hasn't been installed yet."
    install_server
fi

log info "Starting the server..."

if [[ "$MULTITHREADING" == "true" ]]; then
    SERVER_OPTS+=("-useperfthreads" "-NoAsyncLoadingThread" "-UseMultithreadForDS")
fi

FEXBash "$INSTALL_DIR/PalServer.sh $SERVER_OPTS"
