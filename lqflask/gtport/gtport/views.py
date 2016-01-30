__author__ = 'lq'
from gtport import app
from flask import render_template
from flask import request,flash
from flask import jsonify
import sys
import os



sys.path.append(os.path.join(os.getcwd(),os.pardir,os.pardir,"gtportt"))

from gtportt import gtPortSS

@app.route('/', methods = ['GET', 'POST'])
#@app.route('/index')
def index1():
	ports=[8000,80,8094]
	print request.method
	if request.method == 'POST':
		if valid_login(request.form['port1']):
			flash("thanks")
	return render_template("porttest.html",ports = ports)

@app.route('/_add_numbers')
def cal():
	a=request.args.get('a',0,type=int)
	b=request.args.get('b',0,type=int)
	return jsonify(result=a+b)

def valid_login(port):
	return port

