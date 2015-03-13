from django.contrib.auth.models import User, Group
from rest_framework import viewsets
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from ujieservice.models import Order
from ujieservice.rest.serializers import DriverProfileSerializer


class DriverProfile(APIView):
    def get(self, request, format=None):
        serializer = DriverProfileSerializer(request.user.profile)
        return Response(serializer.data)

    def put(self, request, format=None):
        serializer = DriverProfileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)