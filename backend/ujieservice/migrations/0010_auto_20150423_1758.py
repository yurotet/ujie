# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0009_profile_driver_avatar'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='driver_avatar',
            field=models.CharField(max_length=255, null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='profile',
            name='driver_driving_license',
            field=models.CharField(max_length=255, blank=True),
            preserve_default=True,
        ),
    ]
