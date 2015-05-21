# coding:utf-8
import json
import requests
import base64

__author__ = 'yi.shen'

from ujie import settings
from ujieservice.rest import serializers
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import get_user_model, authenticate, login


class Send(APIView):
    permission_classes = (IsAuthenticated,)

    def _getAuth(self):
        return 'Basic ' + base64.b64encode(settings.JP_APPKEY + ':' + settings.JP_MASTERSECRET)

    def post(self, request):
        UserModel = get_user_model()
        try:
            user = UserModel.objects.get(username=request.data.get('target_username'))
            msg = request.data.get('msg')
            if user.jp_registration_id is not None:
                payload = {
                    'platform': 'all',
                    'audience': {
                        'registration_id': [user.jp_registration_id]
                    },
                    'message': {
                        'msg_content': msg,
                        'extras': json.dumps({
                          'sender': user.username
                        })
                    }
                }
                req = requests.post('https://api.jpush.cn/v3/push', json.dumps(payload), headers={
                    'Authorization': self._getAuth()
                })
                return Response(status=status.HTTP_201_CREATED)
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST)
        except UserModel.DoesNotExist as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)