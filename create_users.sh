#!/bin/bash
# skapar användare med hemkataloger och välkomstfil
# kör med: sudo ./create_users.sh Anna Björn Charlie

    # kontrollera att skriptet körs som root
if [ "$EUID" -ne 0 ]; then 
    echo "Du måste köra det här som root."
    echo "försök med: sudo ./create_users.sh"
    exit 1
fi

    # kontrollera att namn har angetts
if [ "$#" -eq 0 ]; then
    echo "du glömde skriva in några namn..."
    echo "exempel: sudo ./create_users.sh Anna Bjorn Charlie"
    exit 1
fi

for USERNAME in "$@"; do
    echo "Skapar $USERNAME..."

    # skapa användaren memd hemkatalog
    useradd -m "$USERNAME"

    HOMEDIR="/home/$USERNAME"
    WELCOMEFILE="$HOMEDIR/welcome.txt"


    # skapa mappar i hemkatalogen
    mkdir -p "$HOMEDIR/Documents"
    mkdir -p "$HOMEDIR/Downloads"
    mkdir -p "$HOMEDIR/Work"

    # ge användaren äganderätt over sin hemkatalog
    chown -R "$USERNAME:$USERNAME" "$HOMEDIR"
    
    # sätt rättigheter så bara ägaren kommer åt mappen
    chmod -R 700 "$HOMEDIR"
    
    # sätt välkomstfil med lista på andra användare
    echo "Välkommen $USERNAME" > "$WELCOMEFILE"
    echo "" >> "$WELCOMEFILE"
    echo "Andra användare:" >> "$WELCOMEFILE"
    awk -F: '$3 >= 1000 {print $1}' /etc/passwd | grep -v "$USERNAME" >> "$WELCOMEFILE"

    echo "$USERNAME är klar!"

done

echo "alla användare är skapade, ha en bra dag"