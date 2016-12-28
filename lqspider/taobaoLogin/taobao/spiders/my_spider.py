# coding=gbk
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.selector import Selector
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.http import Request, FormRequest
from taobao.items import TaobaoItem
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor as sle

class MySpider(CrawlSpider):
    name = "taobao"
    allowed_domains = ["taobao.com"]
    start_urls = [
        "https://www.taobao.com",
    ]
    #Todo: summary rules 中 定义爬取URL的规则 在起始页面的下一级进行查找。此例中发现可以逐级向下设置规则。
    rules = [
        Rule(sle(allow=("https://www\.taobao\.com/market/.+"))),
        Rule(sle(allow=("item\.taobao\.com/item\.htm\?spm=.+")), follow=True, callback='parse_item')

    ]

    headers = {
    "Accept": "image/webp,*/*;q=0.8",
    "Accept-Encoding": "gzip,deflate",
    "Accept-Language": "zh-CN,zh;q=0.8",
    "Connection": "keep-alive",
    "Cookie":"cna=sfALDX8PMXcCAToeHIMb2jeE; cnaui=1933142197; sca=c13b3f1d; aimx=2yQMDaeIvw8CAToeHIODaZgA_1439867793; tbsa=549644d567425db8ce5bbfcd_1439868084_6; aui=1933142197; atpsida=10075f1d054df0c91f79dd4b_1439868318",
    "User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.122 Safari/537.36",
    "Referer": "https://login.taobao.com/member/login.jhtml",
    "Host":"log.mmstat.com"
    }
    def start_requests(self):
        return [Request("https://login.taobao.com", meta={'cookiejar': 1}, callback=self.post_login)]

    def post_login(self,response):
        print 'Preparing login'
        #下面这句话用于抓取请求网页后返回网页中的_xsrf字段的文字, 用于成功提交表单
        # xsrf = Selector(response).xpath('//input[@name="_xsrf"]/@value').extract()[0]
        # print xsrf
        #FormRequeset.from_response是Scrapy提供的一个函数, 用于post表单
        #登陆成功后, 会调用after_login回调函数

        # Todo: 淘宝登录失败！！
        return [FormRequest.from_response(response,
                            meta = {'cookiejar' : response.meta['cookiejar']},
                            headers = self.headers,  #注意此处的headers
                            formdata = {
                            'ua': '186UW5TcyMNYQwiAiwTR3tCf0J/QnhEcUpkMmQ=|Um5Ockt1QXRPe09zTXdNeS8=|U2xMHDJ+H2QJZwBxX39RaFV7W3UpSC5CJVshD1kP|VGhXd1llXGJWY1hsWGRaYFpuWWRGe0V+Rn9EcUp/SnBFfkR9SXNIZjA=|VWldfS0QMAgxDy8TLg4gGj8JeUUgU3RTdlgOWA==|VmNDbUMV|V2NDbUMV|WGRYeCgGZhtmH2VScVI2UT5fORtmD2gCawwuRSJHZAFsCWMOdVYyVTpbPR99HWAFYVMoRSlIM141SBZPCTlZJFkgWnNMdEoBKBcvEFx1SnJNAWBCP1YxWzJVdxx7HjcIMA9DJlYCfxZxG3IVN1cqT2ZZYV8TdRh7HGFId09xP20LbxN5Rx5nDWgDfTp0HzYJMQ42CEZ6Q31JfEdyRnxEf0F4VnZYdiB2|WWdHFzYJMxMyDjEEORklGiEfPwo+ACAcIxYrCzcKNQwsEC8aJwczBj9pPw==|WmZYeCgGWjtdMVYoUn5EakpkOHs/Ey8aOgcnGjoFOwQqfCo=|W2FBET9gO30pUDlDOUcgWzdjX3FRbU13SB5I|XGZGFjhnPHouVz5EPkAnXDBkWHZWa0t3SnAmcA==|XWdHFzkXNwoqFioRRxE=|XmJff1EBPQk9CDcXQG5Sa1dsU2dTZllnWm9VIB0/BD4KNQs3DDILNQ03DzUPNWJMbFAGKH4=|X2dHFzlmPXsvVj9FP0EmXTFlWXdXBzIHOhokHSVzU25OYE5uVmxZZDJk|QHpaCiQKKhY2DjsEPWs9|QXtbCyV6IWczSiNZI106QS15RWtLd1dvWm9TBVM=|QnpaCiRkMGgUfht6B18iSzZXPBIyYlZqV3dOd0sdPQAgDiAAPAA4ATVjNQ==|Q3lZCSd4I2UxSCFbIV84Qy97R2lJdFRoVGxXbDps|RH5eDiBgNGwQeh9+A1smTzJTOBY2CioWKhInGkwa|RX9fDyFhNW0Rex5/AlonTjNSORc3CioWKhEqFEIU|RnxcDCIMLBExDTEKMQVTBQ==|R35Dfl5jQ3xcYFllRXtDeVlhVXVPd1drV25OclJuVWhIdkJiXGlJd01tWGJCfkJiXGVFe0VlUHBOclJsUXFOelplUAY=',
                            'TPL_username': 'bynoting007',
                            'TPL_password':'',
                            "TPL_checkcode":'',
                            'loginsite':'0',
                            'newlogin':'0',
                            "TPL_redirect_url":"https://i.taobao.com/my_taobao.htm?nekot=Ynlub3RpbmcwMDc%3D1439868975634",
                            'from':'tb',
                            'fc':'default',
                            'style':'default',
                            # 'css_style':'',
                            'keyLogin':'false',
                            'qrLogin':'true',
                            'newMini':'false',
                            # 'tid':'',
                            'support':'000001',
                            'CtrVersion':"1,0,0,7",
                            'loginType':'3',
                            # 'minititle':'',
                            # 'minipara':'',
                            # 'umto':'NaN',
                            # 'pstrong':'',
                            # 'llnick':'',
                            # 'sign':'',
                            # 'need_sign':'',
                            # 'isIgnore':'',
                            # 'full_redirect':'',
                            # 'popid':'',
                            # 'callback':'',
                            # 'not_duplite_str':'',
                            # 'need_user_id':'',
                            # 'poy':'',
                            'gvfdcname':'10',
                            # 'gvfdcre':'',
                            'sub':'false',
                            "TPL_password_2":'78450762bf2ea732820891b6346fd56c27ec4583308b2dbaf16f4bb803a06212f05bc99709d180160afff48af21e2ddf03de57eb632d3da475a0f3ccd2b7a3b8e6d66cfe64cb2ad28ba695530013de25159d5ac4db3eb1a6f6dcb0d793659dfbda1ee679ccad7e224ecdb7d54e964c2cf822385ed083e8652c858551e9257996',
                            'loginASR':'1',
                            'loginASRSuc':'1',
                            # 'alip':'',
                            'oslanguage':'zh-CN',
                            'sr':'1600*900',
                            'osVer':'windows|6.1',
                            'naviVer':'firefox|40'
                            },
                            callback = self.after_login,
                            dont_filter = True
                            )]
    def after_login(self, response) :
        print "after_login--------------------%s"%response.url
        print response
        # for url in self.start_urls : # 下面方式同样能实现登陆后的页面跳转 替代start_urls。。
        yield self.make_requests_from_url(response.url)
    def parse_item(self, response):
        items = []
        # // filename = response.url.split("/")[-2]
        print "taobao =========================%s"%response.url
        return items


