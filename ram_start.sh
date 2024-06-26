#!/bin/bash

#Fonction pour obtenir l'utilisation de la mémoire
get_memory_usage() {
    local total_mem=$(free | awk '/^Mem:/{print $2}')
    local used_mem=$(free | awk '/^Mem:/{print $3}')
    local mem_usage=$(( 100 * used_mem / total_mem ))
    echo $mem_usage
}

#Fonction pour arrêter le Node
stop_script() {
#Nom de la session screen à tuer
SCREEN_NAME="nodequil"

#Lister les sessions et trouver l'ID de la session nommée
SESSION_ID=$(screen -ls | grep "$SCREEN_NAME" | awk -F. '{print $1}' | awk '{print $1}')

#Vérifier si la session existe et la tuer
if [ -n "$SESSION_ID" ]; then
    screen -S "$SESSION_ID" -X quit
    echo "La session screen '$SCREEN_NAME' (ID: $SESSION_ID) a été stopée."
else
    echo "Aucune session screen nommée '$SCREEN_NAME' n'a été trouvée."
fi
}

#Fonction pour vider la mémoire cache
clear_memory() {
    sync; echo 3 > /proc/sys/vm/drop_caches
}

#Fonction pour démarrer le Node
start_script() {
    cd /root/ceremonyclient/node && screen -dmS nodequil release_autorun.sh &
}

#Surveillance de la mémoire
while true; do
    current_mem_usage=$(get_memory_usage)
    echo "Utilisation actuelle de la mémoire: $current_mem_usage%"

    if [ $current_mem_usage -gt 85 ]; then
        echo "La mémoire utilisée est supérieure à 85% ($current_mem_usage%). Arrêt du script..."
        stop_script
        echo "Vidage de la mémoire RAM."
        clear_memory
        echo "Redémarrage du Node."
        start_script
    fi

    #Sleep 1 min avant de relancer la boucle.
    sleep 60
done
