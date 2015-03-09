from django.contrib import admin
from django.contrib.auth.models import User
from ujieservice.models import Order, Profile
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

# Register your models here.

class UserProfileInline(admin.TabularInline):
    model = Profile


class UserAdmin(DjangoUserAdmin):
    inlines = (UserProfileInline,)


admin.site.unregister(User)
admin.site.register(User, UserAdmin)
admin.site.register([Order])