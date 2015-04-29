from django.conf import settings
from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model
from django.core.exceptions import ImproperlyConfigured


class WxUserModelBackend(ModelBackend):
    def authenticate(self, wx_open_id):
        UserModel = get_user_model()
        try:
            user = UserModel.objects.get(wx_open_id=wx_open_id)
            return user
        except UserModel.DoesNotExist:
            user = UserModel.objects.create_user_by_wx_open_id(wx_open_id)
            return user

    def get_user(self, user_id):
        UserModel = get_user_model()
        try:
            return UserModel.objects.get(pk=user_id)
        except UserModel.DoesNotExist:
            return None