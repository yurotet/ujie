from django.contrib import admin
from ujieservice.models import Order, Driver

# Register your models here.
admin.site.register([Order, Driver])