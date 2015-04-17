from rest_framework import viewsets
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView
from ujieservice.models import Order, Manufactuer, Model
from ujieservice.rest.serializers import ManufactuerListSerializer, ManufactuerDetailSerializer, ModelListSerializer


class ManufactuerList(APIView):
    permission_classes = ()

    def get(self, request):
        queryset = Manufactuer.objects.all()
        serializer = ManufactuerListSerializer(queryset, many=True)
        return Response(serializer.data)


class ManufactuerDetail(APIView):
    permission_classes = ()

    def get(self, request, pk=None):
        result = Manufactuer.objects.get(pk=pk)
        serializer = ManufactuerDetailSerializer(result)
        return Response(serializer.data)


class ModelList(APIView):
    permission_classes = ()

    def get(self, request, pk=None):
        queryset = Model.objects.filter(manufactuer_id=pk)
        serializer = ModelListSerializer(queryset, many=True)
        return Response(serializer.data)