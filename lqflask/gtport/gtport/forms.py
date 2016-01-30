# coding=gbk
__author__ = 'Administrator'

from wtforms imprt Form,TextField,BooleanField
from wtforms.validators import Required


class LoginForm(Form):
    openid = TextField('openid', validators = [Required()])
    remember_me = BooleanField('remember_me', default = False)

