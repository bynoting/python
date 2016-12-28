#coding=utf-8
from django.conf.urls import patterns, include, url

from models import Update
from views import *

urlpatterns = patterns('',
    url(r'^$', UpdateListView.as_view(), name="update_list_url"),
    url(r'^updates-after/(?P<id>\d+)/$', "liveupdate.views.updates_after"),  #虽然有了 import， 但还要对引用字符串写全包路径名
)