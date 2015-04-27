from django.contrib.auth.models import User, Group
from rest_framework import viewsets
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from ujie import settings
from ujieservice.models import Order, Vehicle, Model
from ujieservice.rest.serializers import DriverProfileSerializer, VehicleSerializer


class DriverProfile(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        if request.user.has_perm('ujieservice.user_driver'):
            serializer = DriverProfileSerializer(request.user.profile)
            return Response(serializer.data)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def put(self, request, format=None):
        if request.user.has_perm('ujieservice.user_driver'):
            profile = request.user.profile
            serializer = DriverProfileSerializer(profile, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)


class VehiclesView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, format=None):
        if request.user.has_perm('ujieservice.user_driver'):
            profile = request.user.profile
            result = Vehicle.objects.filter(driver=profile)
            serializer = VehicleSerializer(result, many=True)
            return Response(serializer.data)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def post(self, request, format=None):
        if request.user.has_perm('ujieservice.user_driver'):
            profile = request.user.profile
            data = request.data
            serializer = VehicleSerializer(data=data)
            vehicle_model = Model.objects.get(pk=data['model'])
            if serializer.is_valid():
                serializer.save(driver=profile, model=vehicle_model)
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)


class VehicleDetailView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, pk=None):
        if request.user.has_perm('ujieservice.user_driver'):
            profile = request.user.profile
            result = Vehicle.objects.filter(pk=pk)
            if len(result):
                v = result[0]
                if v.driver == profile:
                    serializer = VehicleSerializer(v)
                    return Response(serializer.data)
                else:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
            else:
                return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def put(self, request, pk=None):
        if request.user.has_perm('ujieservice.user_driver'):
            vehicle = Vehicle.objects.get(pk=pk)
            vehicle_model = Model.objects.get(pk=request.data.get('model', vehicle.model.model_id))
            serializer = VehicleSerializer(vehicle, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save(model=vehicle_model)
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)

    def delete(self, request, pk=None):
        if request.user.has_perm('ujieservice.user_driver'):
            profile = request.user.profile
            result = Vehicle.objects.filter(pk=pk)
            if len(result):
                v = result[0]
                if v.driver == profile:
                    v.delete()
                    return Response(status=status.HTTP_200_OK)
                else:
                    return Response(status=status.HTTP_401_UNAUTHORIZED)
            else:
                return Response(status=status.HTTP_404_NOT_FOUND)
        else:
            return Response(status=status.HTTP_401_UNAUTHORIZED)