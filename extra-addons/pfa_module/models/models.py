from odoo import models, fields

class PfaStudent(models.Model):
    _name = 'pfa.student'
    _description = 'Étudiant PFA'

    name = fields.Char(string="Nom", required=True)
    age = fields.Integer(string="Âge")
    email = fields.Char(string="Email")
