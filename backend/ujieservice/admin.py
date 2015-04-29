from django.contrib import admin
# from django.contrib.auth.models import User
from ujieservice.models import Order, User

admin.site.register([User, Order])