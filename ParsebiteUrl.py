import urllib2,HTMLParser
import re
from lxml import etree

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
    keys = ''
    for a in keystr:
        if a.isdigit():
		    keys = keys + a
    return keys

def judgekey1(keystr):
    keys = ''
    for a in keystr:
        if re.match(r"\d",a):
            keys = keys + a
    return keys

def loadconfig(file):

    with open(file,"r") as f:
        jdata = json.load(f)
        pd = jdata["password"]
        print pd
        return jdata

def saveconfig(fname ,jdata):

    with open(file,"w") as f:
        f.write(json.dumps(jdata))


if __name__ == '__main__':
    keys = crawl()
    file = "/etc/shadowsocks.json"

    data = loadconfig(file)
    saveconfig(file,data)



# class parseLink(HTMLParser.HTMLParser):
#     def parse_starttag(self, i):
#         return HTMLParser.HTMLParser.parse_starttag(self, i)


