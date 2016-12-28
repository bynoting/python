__author__ = 'lq'

from flask import Flask

app = Flask(__name__)
app.config.from_object('config')

import gtport.views


