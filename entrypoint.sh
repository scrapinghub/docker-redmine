#!/bin/bash
set -e
source ${REDMINE_RUNTIME_DIR}/functions

if [ -f "${REDMINE_CFGFILE}" ]; then
    source ${REDMINE_CFGFILE}
fi

EMAIL_IMPORTER_INTERVAL=${EMAIL_IMPORTER_INTERVAL:-120}
EMAIL_IMPORTER_HOSTNAME=${EMAIL_IMPORTER_HOSTNAME:-imap.gmail.com}
EMAIL_IMPORTER_USERNAME=${EMAIL_IMPORTER_USERNAME:-}
EMAIL_IMPORTER_PASSWORD=${EMAIL_IMPORTER_PASSWORD:-}
EMAIL_IMPORTER_PORT=${EMAIL_IMPORTER_PORT:-993}
EMAIL_IMPORTER_SSL=${EMAIL_IMPORTER_SSL:-false}
EMAIL_IMPORTER_STARTTLS=${EMAIL_IMPORTER_STARTTLS:-true}

[[ $DEBUG == true ]] && set -x

appEmailImporter () {
  echo "Starting email importer loop.."
  while true; do
      echo "Importing emails.."
      appRake redmine:email:receive_imap host=$EMAIL_IMPORTER_HOSTNAME \
          port=$EMAIL_IMPORTER_PORT \
          starttls=$EMAIL_IMPORTER_STARTTLS \
          ssl=$EMAIL_IMPORTER_SSL \
          username=$EMAIL_IMPORTER_USERNAME \
          password=$EMAIL_IMPORTER_PASSWORD
      echo "Sleeping $EMAIL_IMPORTER_INTERVAL seconds."
      sleep $EMAIL_IMPORTER_INTERVAL
  done
}

case ${1} in
  app:init|app:start|app:rake|app:backup:create|app:backup:restore|app:emailimporter)

    initialize_system
    configure_redmine
    configure_nginx

    case ${1} in
      app:start)
        migrate_database
        install_plugins
        install_themes

        if [[ -f ${REDMINE_DATA_DIR}/entrypoint.custom.sh ]]; then
          echo "Executing entrypoint.custom.sh..."
          . ${REDMINE_DATA_DIR}/entrypoint.custom.sh
        fi

        rm -rf /var/run/supervisor.sock
        exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
        ;;
      app:init)
        migrate_database
        install_plugins
        install_themes
        ;;
      app:rake)
        shift 1
        execute_raketask $@
        ;;
      app:backup:create)
        shift 1
        backup_create $@
        ;;
      app:backup:restore)
        shift 1
        backup_restore $@
        ;;
    esac
    ;;
  app:emailimporter)
    appEmailImporter
    ;;
  app:help)
    echo "Available options:"
    echo " app:start          - Starts the Redmine server (default)"
    echo " app:init           - Initialize the Redmine server (e.g. create databases, install plugins/themes), but don't start it."
    echo " app:rake <task>    - Execute a rake task."
    echo " app:emailimporter  - Starts a loop for importing emails to redmine"
    echo " app:backup:create  - Create a backup."
    echo " app:backup:restore - Restore an existing backup."
    echo " app:help           - Displays the help"
    echo " [command]          - Execute the specified command, eg. bash."
    ;;
  *)
    exec "$@"
    ;;
esac
