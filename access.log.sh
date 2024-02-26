#!/bin/bash

# Nom du conteneur nginx_reverse_proxy
NGINX_CONTAINER="nginx_reverse_proxy"

# Chemin des logs à l'intérieur du conteneur
LOG_PATH="/var/log/nginx/"

# Vérifier si le conteneur est en cours d'exécution
if [ "$(docker inspect -f '{{.State.Running}}' $NGINX_CONTAINER 2>/dev/null)" != "true" ]; then
  echo "Le conteneur nginx_reverse_proxy n'est pas en cours d'exécution."
  exit 1
fi

# Liste des fichiers de log disponibles
LOG_FILES=$(docker exec $NGINX_CONTAINER ls $LOG_PATH)

# Afficher la liste des fichiers de log
echo "Serveurs disponibles :"
select LOG_FILE in $LOG_FILES "Quitter"; do
  case $LOG_FILE in
    "Quitter")
      echo "Sortie du script."
      exit 0
      ;;
    *)
      if [ -n "$LOG_FILE" ]; then
        # Afficher les logs en temps réel
        docker exec -it $NGINX_CONTAINER tail -f $LOG_PATH$LOG_FILE
      else
        echo "Choix invalide."
      fi
      ;;
  esac
done
