#coding:utf-8
import re
from django.http import HttpRequest, HttpResponse


class UjieMiddleware(object):
    def process_request(self, request):
        assert isinstance(request, HttpRequest)
        if re.match(r'^h5', request.path) is None:
            return HttpResponse("请在微信内部访问")
        else:
            return None