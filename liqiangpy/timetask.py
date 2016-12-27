__author__ = 'Administrator'
import logging
import os

logging.basicConfig\
	(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='myapp.log',
                filemode='w')


os.system("sudo server redd restart")
logging.debug("very good")