#!/bin/bash
# Homegear Datenbank Update & Push Script
# Sichert Änderungen der Homegear-Datenbank ins Git

echo "🔄 Homegear Datenbank Update & Push"
echo "===================================="

# Stoppe Homegear kurz für konsistente DB
echo "⏸️  Stoppe Homegear Container..."
docker-compose stop homegear
sleep 2

# Prüfe ob DB-Änderungen vorliegen
if git diff --quiet homegear/data/db.sql*; then
    echo "ℹ️  Keine Änderungen an der Datenbank"
    docker-compose up -d homegear
    exit 0
fi

# Zeige Änderungen
echo ""
echo "📊 Datenbank-Änderungen:"
ls -lh homegear/data/db.sql*

# Git Add
echo ""
echo "➕ Füge DB-Änderungen hinzu..."
git add homegear/data/db.sql homegear/data/db.sql-shm homegear/data/db.sql-wal

# Commit mit Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "💾 Committe Änderungen..."
git commit -m "Update Homegear DB - ${TIMESTAMP}"

# Push
echo "⬆️  Pushe zu GitHub..."
git push

# Starte Homegear wieder
echo "▶️  Starte Homegear Container..."
docker-compose up -d homegear

echo ""
echo "✅ Fertig! Datenbank gesichert und gepusht."
