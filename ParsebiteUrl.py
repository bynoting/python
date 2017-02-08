#todo: about json file operaiton
import urllib2,HTMLParser
import re
from lxml import etree
import pexpect
import OperaPexpectDemo


from bs4 import BeautifulSoup # pip install BeautifulSoup4
import sys
import json
# do with decode error
reload(sys)
sys.setdefaultencoding('utf-8')


def crawl():
	url = "https://freevpnss.cc/"
	content = ( urllib2.urlopen(url)).read()
	# print content
	htmlElement = etree.HTML(content)
	#objectElement = htmlElement.find(".//body/div[1]/div[5]/div[3]/div/div[2]/p[3]/text()[2]") # error can't parse text()!
	elist = htmlElement.xpath(".//body/div[1]/div[5]/div[3]/div/div[2]/p[3]/text()[2]")

	keystr = str(elist[0])
	keys= judgekey1(keystr)
	return keys

def judgekey(keystr):
    key = ''
    for a in keystr:
        if a.isdigit():
		    keys = key + a
    return key

def judgekey1(keystr):
    key = ''
    for a in keystr:
        if re.match(r"\d",a):
            key = key + a
    return key

def loadconfig(file,key):
    data = {}
    isChanged = False
    with open(file,"r") as f:
        jdata = json.load(f)
        print "key:" + key

        pd = jdata["password"]
        print "pd: "+pd
        if pd != key :
            jdata["password"] = key
            isChanged = True

        data={"jdata":jdata,"isChanged":isChanged}
    return data

def saveconfig(file ,data):
    if data["isChanged"] :
        with open(file,"w") as f:
            f.write(json.dumps(data["jdata"]))

        restartShadowserv()

def restartShadowserv():
    OperaPexpectDemo.restartShadow()

if __name__ == '__main__':
    key = crawl()
    file = "/etc/shadowsocks.json"
    #file = "e:/shadowsocks.json"
    data = loadconfig(file,key)
    saveconfig(file,data)



# class parseLink(HTMLParser.HTMLParser):
#     def parse_starttag(self, i):
#         return HTMLParser.HTMLParser.parse_starttag(self, i)


