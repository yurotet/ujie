# coding:utf-8
import json
from igetui.template.igt_transmission_template import TransmissionTemplate
from igt_push import IGeTui
from igetui.igt_message import IGtSingleMessage
from igetui.igt_target import *
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

    # def _sendMsg(self, target):
    #     template = TransmissionTemplate()
    #     template.transmissionType = 1
    #     template.appId = settings.IGT_APPID
    #     template.appKey = settings.IGT_APPKEY
    #     template.transmissionContent = target["msg"]
    #     template.setPushInfo("PLAY", 1, target["msg"], "", "", "", "", "")
    #
    #     HOST = 'http://sdk.open.api.igexin.com/apiex.htm'
    #     push = IGeTui(HOST, settings.IGT_APPKEY, settings.IGT_MASTERSECRET)
    #     message = IGtSingleMessage()
    #     message.isOffline = True
    #     message.offlineExpireTime = 1000 * 3600 * 12
    #     message.data = template
    #     message.pushNetWorkType = 0 #设置是否根据WIFI推送消息，1为wifi推送，0为不限制推送
    #     gt_target = Target()
    #     gt_target.appId = settings.IGT_APPID
    #     gt_target.clientId = target["user"].gt_clientid
    #     ret = push.pushMessageToSingle(message, gt_target)
    #     print ret