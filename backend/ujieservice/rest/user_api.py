# coding:utf-8
__author__ = 'yi.shen'

from ujieservice.rest.serializers import UserSerializer
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import get_user_model, authenticate, login


class UserLogin(APIView):
    permission_classes = ()

    def post(self, request):
        jp_registration_id = request.data.get("jp_registration_id")
        if request.user.is_authenticated():
            user = request.user
            if user.jp_registration_id != jp_registration_id:
                user.jp_registration_id = jp_registration_id
                user.save()
            serializer = UserSerializer(request.user)
            return Response(serializer.data)
        else:
            UserModel = get_user_model()
            username = request.data.get("username")
            password = request.data.get("password")
            # gt_clientid = request.data.get("gt_clientid")
            if username is None or password is None:
                return Response(status=status.HTTP_401_UNAUTHORIZED)
            try:
                UserModel.objects.get(username=username)
                user = authenticate(username=username, password=password)
                if user is None:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
                else:
                    if user.jp_registration_id != jp_registration_id:
                        user.jp_registration_id = jp_registration_id
                        user.save()
                    login(request, user)
                    serializer = UserSerializer(request.user)
                    return Response(serializer.data)
            except UserModel.DoesNotExist:
                UserModel.objects.create_user(username, password=password, jp_registrationid=jp_registration_id)
                user = authenticate(username=username, password=password)
                login(request, user)
                serializer = UserSerializer(request.user)
                return Response(serializer.data)

    def get(self, request):
        if request.user.is_authenticated():
            serializer = UserSerializer(request.user)
            return Response(serializer.data)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def put(self, request):
        if request.user.is_authenticated():
            serializer = UserSerializer(request.user, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            else:
                return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)