#!/bin/bash

set -e

STEAMCMD=/home/steam/Steam/steamcmd.sh
INSTALL_DIR="${INSTALL_DIR:-/palworld}"
SERVER_OPTS="$SERVER_OPTS"
UPDATE_ON_START="${UPDATE_ON_START:-false}"
ENABLE_MULTITHREAD="${ENABLE_MULTITHREAD:-true}"
ENABLE_ENGINE_OPTIMIZATION="${ENABLE_ENGINE_OPTIMIZATION:-false}"

steamdo() {
    cmd="$@"
    if [[ "$(uname -m)" = "x86_64" ]]; then
        su steam -c "$cmd"
    else
        su steam -c "FEXBash \"$cmd\""
    fi
}

install_server() {
  steamdo $STEAMCMD +force_install_dir $INSTALL_DIR +login anonymous +app_update 2394010 validate +quit
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

    message="$@"
    log_contents="$(printf "[%s] %s\n" "${severity^^}" "$message")"

    if [[ "$severity" = "ERROR" ]]; then
        echo "$log_contents" 2>&1
    else
        echo "$log_contents"
    fi
}

if ! steamdo touch "$INSTALL_DIR" 2>/dev/null; then
    log -e "$INSTALL_DIR is not writable. Trying to change the ownership..."
    chown -R steam: $INSTALL_DIR
fi

if ! is_server_installed; then
    log "The server hasn't been installed yet."
    install_server
    UPDATE_ON_START="false"
fi
if [[ "${UPDATE_ON_START,,}" = "true" ]]; then
    log "UPDATE_ON_START is true. steamcmd will be updated."
    install_server
fi

log "Generating PalWorldSettings.ini"
settings_ini_path="$INSTALL_DIR/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"
steamdo mkdir -p $(dirname $settings_ini_path)
steamdo confgen PalWorldSettings.ini > $settings_ini_path

if [[ "${ENABLE_ENGINE_OPTIMIZATION,,}" = "true" ]]; then
    log "Generating Engine.ini"
    engine_ini_path="$INSTALL_DIR/Pal/Saved/Config/LinuxServer/Engine.ini"
    steamdo mkdir -p $(dirname $engine_ini_path)
    steamdo confgen Engine.ini > $engine_ini_path
fi

log "Starting the server..."
if [[ "${ENABLE_MULTITHREAD,,}" = "true" ]]; then
    SERVER_OPTS+=("-useperfthreads" "-NoAsyncLoadingThread" "-UseMultithreadForDS")
fi
log "CMD: $INSTALL_DIR/PalServer.sh $SERVER_OPTS"
steamdo $INSTALL_DIR/PalServer.sh $SERVER_OPTS
