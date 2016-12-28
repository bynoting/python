#coding=utf-8
from django.db import models
from django.contrib import admin
from babygo.fields import ThumbnailImageField
from django.core.urlresolvers import reverse

# Create your mode
# ls here.
from django.db.models import permalink


class BabygoPost(models.Model):
    title = models.CharField(max_length=150)
    body = models.TextField()
    timestamp = models.DateTimeField()

    class Meta:
        ordering = ('-timestamp',)
    def __unicode__(self):
        return self.title

    def get_absolue_url(self): # Todo: 尝试在模板语言中引用，和通用视图detailview 一起用 无效。。。。
        return reverse('babygo.views.PostDetailView',args=[str(self.id)]) #@permalink
        #return 'postdetail.html'


class Photo(models.Model):
    postitem = models.ForeignKey(BabygoPost)
    title = models.CharField(max_length=20)
    capition = models.CharField(max_length=30, blank=True)
    image = ThumbnailImageField(upload_to='./upload')


    class Meta:
        ordering = ('-title',)
    def __unicode__(self):
        return self.title
    @permalink
    def get_absolue_url(self):
        return ("Photo_detail",None,{"object_id":self.id}) # 建立url 和实体的关联

class PhotoInline(admin.StackedInline):
    model = Photo


class BabygoPostAdmin(admin.ModelAdmin):

    list_display = ("title", "timestamp")
    inlines = [PhotoInline]

admin.site.register(BabygoPost, BabygoPostAdmin)
admin.site.register(Photo)
