# coding=gbk
from scrapy.spider import Spider
from scrapy.selector import Selector
from scrapy.http import Request


# Todo: summary 用firefox等工具采集登录后的页面中的请求header，及其中的cookies，携带登录信息直接访问登录后的界面
#  3dm 的似乎不会失效
class MySpider(Spider):
    name = "thddm"
    allowed_domains = ["bbs.3dmgame.com"]
    # start_urls = [
    #     "http://www.dmoz.org/Cosmputers/Programming/Languages/Python/Resources/"
    # ]
    def afterparse(self, response):
        open('xx.html','w').write(response.body)
    def start_requests(self):
        url1 = "http://bbs.3dmgame.com/forum.php"
        return [Request(url=url1,method='GET',callback=self.afterparse,
                        cookies={"Hm_lvt_73bb7840179374670b6e59f014db2b3c":"1429068604",
                                    "pgv_pvi":"2751925494",
                                    " uchome_2132_saltkey":"gK3n3UuN",
                                    "uchome_2132_lastvisit":"1439948574",
                                    "uchome_2132_sid":"j4J4HZ",
                                    "uchome_2132_lastact":"1439952291%09home.php%09spacecp",
                                    "pgv_info":"ssi=s5820520037",
                                    "Hm_lvt_7feadc07fb18a8b06e227dafc8d93936":"1439952191",
                                    "Hm_lpvt_7feadc07fb18a8b06e227dafc8d93936":"1439952293",
                                    "uchome_2132_auth":"7ed4PFboKaAewZPMhUCwGzg7%2B1Vug9RycsK4IYCePPc7%2F8XmKSmzFNLf0VLS9a9hgEH06QKScNJTHoVbuL8jGLx%2FBQJ3",
                                    "uchome_2132_cookiereport":"7c09W2E%2B95LzNK5VpSbIcJlS9wNHUB3B%2F212glrpnHigLQT0NvZR",
                                    "uchome_2132_connect_is_bind":"0",
                                    "uchome_2132_noticeTitle":"1",},
                        headers={"Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                                    "Accept-Encoding":"gzip, deflate",
                                    "Accept-Language":"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
                                    "Cache-Control":"max-age=0",
                                    "Connection":"keep-alive",
                                    "Host":"bbs.3dmgame.com",
                                    "Referer":"http://bbs.3dmgame.com/forum.php",
                                    "User-Agent":"Mozilla/5.0 (Windows NT 6.1; rv:40.0) Gecko/20100101 Firefox/40.0",}
                                    )]



