from django.conf import settings
from django.contrib.auth.backends import ModelBackend
from django.core.exceptions import ImproperlyConfigured
from ujieservice.models import Profile


class UjieUserModelBackend(ModelBackend):
    def authenticate(self, open_id):
        try:
            profile = Profile.objects.get(open_id=open_id)
            return profile.user
        except self.user_class.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            return self.user_class.objects.get(pk=user_id)
        except self.user_class.DoesNotExist:
            return None