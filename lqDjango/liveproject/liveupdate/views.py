from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
from django.core import serializers

from models import Update
from django.views.generic.list import ListView

def updates_after(request, id):
    response = HttpResponse()
    response['Content-Type'] = "text/javascript"
    response.write(serializers.serialize("json", Update.objects.filter(pk__gt=id)))
    return response



class UpdateListView(ListView):
	model = Update
	template_name = "update_list.html"
	context_object_name = "update_list_ctx"