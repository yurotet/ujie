# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Driver',
            fields=[
                ('driver_id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, blank=True)),
                ('birth', models.DateField(null=True, blank=True)),
                ('timestamp', models.DateTimeField(null=True, blank=True)),
            ],
            options={
                'db_table': 'driver',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('order_id', models.IntegerField(serialize=False, primary_key=True)),
                ('driver_id', models.IntegerField(null=True, blank=True)),
                ('status', models.IntegerField(null=True, blank=True)),
                ('flight_no', models.CharField(max_length=45, blank=True)),
                ('passenger_number', models.IntegerField(null=True, blank=True)),
                ('target_district_name', models.CharField(max_length=100, blank=True)),
                ('departure_date', models.DateTimeField(null=True, blank=True)),
                ('departure_country_name', models.CharField(max_length=100, blank=True)),
                ('departure_city_name', models.CharField(max_length=100, blank=True)),
                ('departure_terminal_name', models.CharField(max_length=100, blank=True)),
                ('arrival_date', models.DateTimeField(null=True, blank=True)),
                ('arrival_country_name', models.CharField(max_length=100, blank=True)),
                ('arrival_city_name', models.CharField(max_length=100, blank=True)),
                ('arrival_terminal_name', models.CharField(max_length=100, blank=True)),
                ('timestamp', models.DateTimeField(null=True, blank=True)),
            ],
            options={
                'db_table': 'order',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
