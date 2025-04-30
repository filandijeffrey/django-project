#from django.http import HttpResponse


#def index(request):
    #return HttpResponse("Hello World")
    

#def about(request):
    #return HttpResponse("About")

from django.shortcuts import render

def index(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')

def gallery(request):
    return render(request, 'gallery.html')

def contact(request):
    return render(request, 'contac.html')
   