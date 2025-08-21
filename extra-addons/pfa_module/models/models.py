from odoo import models, fields

class PfaModel(models.Model):
    _name = 'pfa.model'
    _description = 'PFA Model Example'

    name = fields.Char(string="Name", required=True)
    description = fields.Text(string="Description")
