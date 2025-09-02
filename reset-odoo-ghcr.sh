#!/bin/bash

echo "=== Nettoyage complet des conteneurs et volumes existants ==="
docker compose down -v
docker rm -f odoo-test odoo-ghcr odoo-db 2>/dev/null
docker rmi ghcr.io/najwa-devops/odoo16-pfa:latest 2>/dev/null

echo "=== Création du fichier SQL pour initialiser la DB ==="
cat > init-odoo-db.sql <<EOF
CREATE DATABASE odoo OWNER odoo;
EOF

echo "=== Création du fichier docker-compose.yml ==="
cat > docker-compose.yml <<EOF
services:
  db:
    image: postgres:15
    container_name: odoo-db
    environment:
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo
      POSTGRES_DB: odoo
    volumes:
      - odoo-db-data:/var/lib/postgresql/data
      - ./init-odoo-db.sql:/docker-entrypoint-initdb.d/init-odoo-db.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U odoo"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  odoo:
    image: ghcr.io/najwa-devops/odoo16-pfa:latest
    container_name: odoo-ghcr
    depends_on:
      db:
        condition: service_healthy
    environment:
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: odoo
      DB_PASSWORD: odoo
    ports:
      - "8070:8069"
    volumes:
      - odoo-data:/var/lib/odoo
    restart: unless-stopped

volumes:
  odoo-db-data:
  odoo-data:
EOF

echo "=== Lancement des conteneurs ==="
docker compose up -d

echo "=== Vérification des conteneurs ==="
docker ps

echo "=== Vérification de la DB ==="
docker exec -it odoo-db psql -U odoo -d odoo -c '\l'

echo "=== Logs Odoo en temps réel (Ctrl+C pour quitter) ==="
docker compose logs -f odoo
