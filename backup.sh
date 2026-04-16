#!/bin/bash

set -euo pipefail #error management
BACKUP_DIR="$HOME/arch-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

echo "=== INIZIO BACKUP ==="
echo "1. produzione liste di pacchetti..."
pacman -Qqen > "$BACKUP_DIR/pkglist-repo.txt" # pacchetti dai repository ufficiali
pacman -Qqm > "$BACKUP_DIR/pkglist-aur.txt" # pacchetti AUR

echo "2. produzione archivio dotfiles..."
tar -czf "$BACKUP_DIR/dotfiles-backup.tar.gz" \
    -C ~/ .bashrc .zshrc .config .local .face .ssh 2>/dev/null

sudo tar -czf "$BACKUP_DIR/system-configs.tar.gz" /etc/fstab /etc/pacman.conf /etc/default/grub

echo "=== BACKUP COMPLETATO ==="
echo "Tutti i file sono salvati in: $BACKUP_DIR"