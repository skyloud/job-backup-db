#!/usr/bin/env sh
set -e
export BAGCLI_WORKDIR="/backup-cli"
. "$BAGCLI_WORKDIR/common"

cli_help() {
  cli_name=${0##*/}
  echo "
$cli_name
Brot and Games CLI
Version: $(cat $BAGCLI_WORKDIR/VERSION)
Usage: $cli_name [command]
Commands:
  postgres  Postgres dump
  *         Help
"
  exit 1
}

cli_log "Exporting config ..."
export $(cat "$BAGCLI_WORKDIR/config" | xargs)

case "$1" in
  postgres|p)
    "$BAGCLI_WORKDIR/commands/postgres" "$2" | tee -ia "$BAGCLI_WORKDIR/postgres_${2}.log"
    ;;
  *)
    cli_help
    ;;
esac