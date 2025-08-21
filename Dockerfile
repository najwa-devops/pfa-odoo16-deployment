FROM odoo:16

# Copier config et addons persos
COPY ./odoo/config/odoo.conf /etc/odoo/
COPY ./odoo/addons /mnt/extra-addons

EXPOSE 8069
