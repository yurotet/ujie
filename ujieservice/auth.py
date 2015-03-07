from django.conf import settings
from django.contrib.auth.backends import ModelBackend
from django.core.exceptions import ImproperlyConfigured
from ujieservice.models import UjieUser


class UjieUserModelBackend(ModelBackend):
    def authenticate(self, open_id):
        try:
            user = self.user_class.objects.get(open_id=open_id)
            return user
        except self.user_class.DoesNotExist:
            return None

    def get_user(self, user_id):
        try:
            return self.user_class.objects.get(pk=user_id)
        except self.user_class.DoesNotExist:
            return None

    @property
    def user_class(self):
        if not hasattr(self, '_user_class'):
            self._user_class = UjieUser
            if not self._user_class:
                raise ImproperlyConfigured('Could not get custom user model')
        return self._user_class
