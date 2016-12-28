# coding=gbk
from scrapy.spider import Spider
from scrapy.selector import Selector
from scrapy.http import Request


# Todo:summary 用firefox等工具采集登录后的页面中的请求header，及其中的cookies，携带登录信息直接访问登录后的界面
# 用gvim进行替换，其中回车换行有点奇怪，查找 是\n 替换是 \r
class MySpider(Spider):
    name = "train"
    allowed_domains = ["12306.com"]
    # start_urls = [
    #     "http://www.dmoz.org/Cosmputers/Programming/Languages/Python/Resources/"
    # ]
    def afterparse(self, response):
        open('xx.html','w').write(response.body)
        # print response.body
    def start_requests(self):
        url1 = "https://kyfw.12306.cn/otn/index/initMy12306"
        # return [Request(url=url1,method='GET',callback=self.afterparse,
        #                 cookies={"JSESSIONID":"0A01D738C439E4D89046B53A0E31A98EC566CD7307",
        #                             "__NRF":"B0471F29D0B1C1C7AB4591B8B1402068",
        #                             "BIGipServerotn":"953614602.50210.0000",},
        #                 headers={"Host":" kyfw.12306.cn",
        #                             "User-Agent":" Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0",
        #                             "Accept":" text/css,*/*;q=0.1",
        #                             "Accept-Language":" zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
        #                             "Accept-Encoding":" gzip, deflate",
        #                             "Referer":" https://kyfw.12306.cn/otn/index/initMy12306",
        #                             "Connection":" keep-alive",
        #                             "If-Modified-Since":" Sun, 16 Aug 2015 22:05:13 GMT",}
        #                             )]
        return [Request(url=url1,method='GET',callback=self.afterparse,
                        cookies={"JSESSIONID":"0A01D729FCF44CCA591E8D9BF0F56D06A1B8695155",
                                    "__NRF":"452EB0C226EA6E52FCBD2E21EC1DDE92",
                                    "BIGipServerotn":"701956362.64545.0000",},
                        headers={"Host":" kyfw.12306.cn",
                                    "User-Agent":" Mozilla/5.0 (Windows NT 6.1; WOW64; rv:40.0) Gecko/20100101 Firefox/40.0",
                                    "Accept":" text/css,*/*;q=0.1",
                                    "Accept-Language":" zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3",
                                    "Accept-Encoding":" gzip, deflate",
                                    "Referer":" https://kyfw.12306.cn/otn/index/initMy12306",
                                    "Connection":" keep-alive",
                                    "If-Modified-Since":" Fri, 21 Aug 2015 16:05:13 GMT",}
                                    )]



