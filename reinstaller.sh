#!/bin/bash

read -p "<path to backup_dir>" BACKUP_DIR

echo "=== REINSTALL PACKAGE ==="

# Aggiorna sistema e chiavi
echo "Aggiornamento sistema"
sudo pacman -Syy --noconfirm #Più sicuro mettercelo
sudo pacman -Syu --noconfirm

# Installa yay se necessario
if ! command -v yay &> /dev/null; then
    echo "Installazione yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Reinstalla pacchetti repo
if [ ! -f "$BACKUP_DIR/pkglist-repo.txt" ]; then
    echo "File pkglist-repo.txt non trovato, skip"
else
    sudo pacman -S --needed --noconfirm - < "$BACKUP_DIR/pkglist-repo.txt"
fi

# Reinstalla pacchetti AUR
if [ ! -f "$BACKUP_DIR/pkglist-aur.txt" ]; then
    echo "File pkglist-aur.txt non trovato, skip"
else
    yay -S --needed --noconfirm - < "$BACKUP_DIR/pkglist-aur.txt"
fi

echo "Reinstallazione pacchetti completata"

echo "Ripristino dotfiles..."
if [ ! -f "$BACKUP_DIR/dotfiles-backup.tar.gz" ]; then
    echo "File dotfiles-backup.tar.gz non trovato, skip"
else
    tar -xzf "$BACKUP_DIR/dotfiles-backup.tar.gz" -C ~/
fi

if [ ! -f "$BACKUP_DIR/system-configs.tar.gz" ]; then
    echo "File system-configs.tar.gz non trovato, skip"
else
    read -p "Ripristinare file di sistema in /etc? (s/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sudo tar -xzpvf "$BACKUP_DIR/system-configs.tar.gz" -C / --same-owner
        echo "Ripristino completato"
    else
        echo "Ripristino annullato"
    fi
fi

echo "=== RIPRISTINO COMPLETATO! ==="
echo "Consigliato reboot del sistema"