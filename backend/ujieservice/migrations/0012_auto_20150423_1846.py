# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0011_auto_20150423_1807'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehicle',
            name='driver',
            field=models.ForeignKey(related_name='driver_vehicles', to='ujieservice.Profile'),
            preserve_default=True,
        ),
    ]
