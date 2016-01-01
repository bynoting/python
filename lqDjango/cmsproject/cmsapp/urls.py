#coding=utf-8
from django.conf.urls import patterns, include, url
from views import category
from views import search
from views import CmsListView
from views import CmsDetailView

# Todo: 大坑。。。此处url中cms-story不能放在cms-search前，否则无法找到search的页面 not found。。。反复试验。。。未知原因。。
urlpatterns = patterns('',
                      url(r'^search/', search, name="cms-search"),
                       url(r'^(?P<slug>[-\w]+)/$', CmsDetailView.as_view(), name="cms-story"),
                       url(r'^$', CmsListView.as_view(), name="cms-home"),
                       url(r'^category/(?P<slug>[-\w]+)/$', category, name="cms-category"),


                       )

