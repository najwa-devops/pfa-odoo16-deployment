# Dockerfile pour Odoo 16 + Postgres

FROM odoo:16.0

# Passer en root pour installer des paquets
USER root

# Mettre à jour pip et installer les dépendances nécessaires
RUN pip3 install --upgrade pip \
    && pip3 install --upgrade werkzeug==2.3.7 \
    && pip3 install --upgrade psycopg2-binary \
    && pip3 install "MarkupSafe<2.1.0"

# Définir le répertoire de travail
WORKDIR /var/lib/odoo

# Revenir à l'utilisateur odoo pour plus de sécurité
USER odoo
