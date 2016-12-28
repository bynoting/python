from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.
from django.shortcuts import render_to_response, get_object_or_404
from django.db.models import Q
from models import Story, Category

from django.views.generic.list import ListView
from django.views.generic.detail import DetailView
import logging

def tt(request):
    return HttpResponse("test")

def search(request):
    logging.info("@@@@@@@@@@@@@@")

    if 'q' in request.GET:
        term = request.GET['q']
        story_list = Story.objects.filter(Q(title__contains=term) | Q(markdown_content__contains=term))
        heading = "Search results"
    return render_to_response("story_list.html", locals())

    # story_list = Story.objects.all()
    # t = get_template(story_list.html)
    # c = RequestContext (request,locals())
    # return HttpResponse(t.render(c))
    # return HttpResponseRedirect('base.html')

def category(request, slug):
    """Given a category slug, display all items in a category."""
    category = get_object_or_404(Category, slug=slug)
    story_list = Story.objects.filter(category=category)
    heading = "Category: %s" % category.label
    return render_to_response("story_list.html", locals())


class CmsListView(ListView):
    logging.info("^^^^^^^^^^^^^^^^^^^^")
    template_name = "story_list.html"
    model = Story
    context_object_name = "story_list"

class CmsDetailView(DetailView):
    template_name = "story_detail.html"
    model = Story
    context_object_name = "story_detail"
