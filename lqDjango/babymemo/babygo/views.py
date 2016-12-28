# from django.shortcuts import render
#
# # Create your views here.
# from django.template import loader,Context
# from django.http import HttpResponse,Http404
# from django.shortcuts import render_to_response
# from babygo.models import BabygoPost
#
# def archive(request):
#     lists = BabygoPost.objects.all()
#     tem = loader.get_template("archive.html")
#     cot = Context({"lists":lists})
#     return HttpResponse(tem.render(cot))\
#
# def archive_detail(request,id):
#     try:
#         item = BabygoPost.objects.get(pk=id)
#     except item.DoesNotExist:
#         raise Http404
#     return render_to_response("templates/detail.html",{"item":item})

from babygo.models import BabygoPost,Photo
from django.views.generic.base import TemplateView
from django.views.generic.list import ListView
from django.views.generic.detail import DetailView

class IndexView(TemplateView):
	template_name = "index.html"
	def get_context_data(self, **kwargs):
		context = super(IndexView,self).get_context_data(**kwargs)
		context["post_list_context"] = BabygoPost.objects.all()[:5]
		return context

class PostListView(ListView):
	model = BabygoPost
	template_name = "postlist.html"
	context_object_name = "PostList_ctx"

class PostDetailView(DetailView):
	model = BabygoPost
	template_name = 'postdetail.html'
	context_object_name = "PostDetail_ctx"

class PhotoDetailView(DetailView):
	model = Photo
	template_name = 'photodetail.html'
	context_object_name = "PhotoDetail_ctx"
