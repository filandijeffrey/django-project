#from django.http import HttpResponse


#def index(request):
    #return HttpResponse("Hello World")
    

#def about(request):
    #return HttpResponse("About")

from django.shortcuts import render
from django.contrib import messages

def index(request):
    return render(request, 'index.html')

def about(request):
    return render(request, 'about.html')

def gallery(request):
    return render(request, 'gallery.html')

def contact(request):
    return render(request, 'contac.html')
   
def contact(request):
    if request.method == "POST":
        name = request.POST.get("name")
        email = request.POST.get("email")
        message = request.POST.get("message")
        # Handle the data here (e.g., save to DB, send email)
        messages.success(request, "Thank you for contacting us!")
    return render(request, "contact.html")