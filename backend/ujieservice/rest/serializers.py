from rest_framework import serializers
from ujie import settings
from ujieservice import models


class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Vehicle
        depth = 1
        # read_only_fields = ("vehicle_id", "brand", "vehicle_licence", "plate_no", "created_time", "model")
        fields = ("vehicle_id", "brand", "vehicle_licence", "plate_no", "created_time", "model")


class ManufactuerListSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Manufactuer
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('manufactuer_id', 'name')


class ManufactuerDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Manufactuer
        # depth = 1
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('manufactuer_id', 'name', 'models')


class ModelListSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Model
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('model_id', 'name')


class UserSerializer(serializers.ModelSerializer):
    driver_vehicles = VehicleSerializer(many=True)

    class Meta:
        model = models.User
        exclude = ('username', 'password', 'is_superuser', 'wx_open_id')


class StringSerializer(serializers.Serializer):
    def to_representation(self, instance):
        return instance


class FlightNoSug(serializers.Serializer):
    keyword = serializers.CharField(max_length=100)
    data = StringSerializer(many=True)


class RestaurantSug(serializers.Serializer):
    districtname = serializers.CharField(max_length=100, required=False)
    price = serializers.CharField(max_length=100, required=False)
    star = serializers.CharField(max_length=100, required=False)
    type = serializers.CharField(max_length=100, required=False)
    url = serializers.CharField(max_length=255, required=False)
    word = serializers.CharField(max_length=100, required=False)
    zonename = serializers.CharField(max_length=100, required=False)
