# coding:utf-8
import json
from xml.etree import ElementTree
import uuid
from django.http import JsonResponse, HttpResponse
import requests
from PIL import Image
from StringIO import StringIO
from rest_framework import viewsets
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
import time
from ujie import settings
from ujieservice import models
from ujieservice.rest import serializers
from ujieservice.wechat import token


class ManufactuerList(APIView):
    permission_classes = ()

    def get(self, request):
        queryset = models.Manufactuer.objects.all()
        serializer = serializers.ManufactuerListSerializer(queryset, many=True)
        return Response(serializer.data)


class ManufactuerDetail(APIView):
    permission_classes = ()

    def get(self, request, pk=None):
        result = models.Manufactuer.objects.get(pk=pk)
        serializer = serializers.ManufactuerDetailSerializer(result)
        return Response(serializer.data)


class ModelList(APIView):
    permission_classes = ()

    def get(self, request, pk=None):
        queryset = models.Model.objects.filter(manufactuer_id=pk)
        serializer = serializers.ModelListSerializer(queryset, many=True)
        return Response(serializer.data)


class Avatar(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        uploaded_file = None
        for key in request.FILES:
            uploaded_file = request.FILES[key]
            break
        if uploaded_file != None:
            uploaded_file.name = str(uuid) + '.jpg'
            request.user.profile.driver_avatar = uploaded_file
            return Response(status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class WxStaticUpload(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        wx_media_id = request.REQUEST.get("wx_media_id")
        upload_to = request.REQUEST.get("upload_to")
        req = requests.get('http://file.api.weixin.qq.com/cgi-bin/media/get', params={
            'access_token': token.ACCESS_TOKEN,
            'media_id': wx_media_id
        })

        if req.headers['content-type'] == 'image/jpeg':
            image = Image.open(StringIO(req.content))
            filename = str(uuid.uuid1()) + '.jpg'
            upload_dir = settings.MEDIA_ROOT + upload_to + '/'
            image.save(upload_dir + filename)
            static_url = settings.MEDIA_URL + upload_to + '/' + filename
            return JsonResponse({
                'static_url': static_url
            }, status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class WxUserUpload(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        wx_media_id = request.REQUEST.get("wx_media_id")
        req = requests.get('http://file.api.weixin.qq.com/cgi-bin/media/get', params={
            'access_token': token.ACCESS_TOKEN,
            'media_id': wx_media_id
        })

        if req.headers['content-type'] == 'image/jpeg':
            image = Image.open(StringIO(req.content))
            filename = str(uuid.uuid1()) + '.jpg'
            upload_dir = settings.USER_MEDIA_ROOT
            image.save(upload_dir + filename)
            r = models.Resource.objects.create(user=request.user, img_path=filename)
            #resource url is like: /service/rest/common/resource/1
            static_url = settings.USER_MEDIA_URL + str(r.pk)
            return JsonResponse({
                'static_url': static_url
            }, status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class Resource(APIView):
    # permission_classes = (IsAuthenticated,)
    permission_classes = ()

    def get(self, request, pk=None):
        result = models.Resource.objects.filter(pk=pk, user=request.user)
        if len(result):
            r = result[0]
            file_path = settings.USER_MEDIA_ROOT + r.img_path
            im = Image.open(file_path)
            response = HttpResponse(content_type="image/jpeg")
            im.save(response, 'JPEG')
            return response
        else:
            return Response(status=status.HTTP_404_NOT_FOUND)


class User(APIView):
    # permission_classes = (IsAuthenticated,)
    permission_classes = (IsAuthenticated,)

    def get(self, request, pk=None):
        serializer = serializers.UserSerializer(request.user)
        return Response(serializer.data)


class FlightNoSug(APIView):
    permission_classes = ()

    def get(self, request, keyword=None):
        req = requests.get('http://car.ctrip.com/carhome/json/flightno', params={
            'keyword': keyword,
            '_': str(int(time.time()))
        })
        result = json.loads(req.text)
        s = serializers.FlightNoSug(result)
        return Response(s.data)


# districtname: "甲米"
# price: "1159"
# star: "高档型"
# type: "hotel"
# url: "http://m.ctrip.com/webapp/hotel/oversea/hoteldetail/709793.html?atime=20150430"
# word: "Baan Kan Tiang See Villa Resort(芭坎天希别墅度假村酒店)"
# zonename: " "
class RestaurantSug(APIView):
    permission_classes = ()

    def get(self, request, keyword=None):
        # keyword = "酒店 " + keyword
        req = requests.get('http://m.ctrip.com/restapi/h5api/searchapp/search', params={
            'source': 'mobileweb',
            'action': 'autocomplete',
            'contentType': 'json',
            'keyword': keyword
        })
        result = json.loads(req.text)
        s = serializers.RestaurantSug(result["data"], many=True)
        return Response(s.data)


class RestaurantDetail(APIView):
    permission_classes = ()

    def get(self, request):
        detail_url = request.REQUEST.get('url')
        #request SEO page
        detail_url = detail_url.replace('/webapp', '/html5')
        req = requests.get(detail_url)
        html = req.text

        #extract data
        root = ElementTree.fromstring(html)
        for i in root.itertext("酒店地址"):
            pass

        return Response("")