from rest_framework import serializers
from ujieservice.models import Profile, Manufactuer, Model, Vehicle


class VehicleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Vehicle
        depth = 1
        # read_only_fields = ("vehicle_id", "brand", "vehicle_licence", "plate_no", "created_time", "model")
        fields = ("vehicle_id", "brand", "vehicle_licence", "plate_no", "created_time", "model")


class DriverProfileSerializer(serializers.ModelSerializer):
    driver_vehicles = VehicleSerializer(many=True)

    class Meta:
        model = Profile
        read_only_fields = ('driver_status',)
        fields = ('driver_name', 'mobile', 'driver_status', 'driver_name', 'driver_contact', 'driver_account_no', 'driver_account_name', 'driver_account_bank', 'driver_account_bsb_no', 'driver_driving_license', 'driver_vehicles')



class CustomerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        # read_only_fields = ('user.username',)
        fields = ('mobile',)


class ManufactuerListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Manufactuer
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('manufactuer_id', 'name')


class ManufactuerDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Manufactuer
        # depth = 1
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('manufactuer_id', 'name', 'models')


class ModelListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Model
        # read_only_fields = ('user.username',)
        # read_only_fields = ('manufactuer_id', 'name')
        fields = ('model_id', 'name')