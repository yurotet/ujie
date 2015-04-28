# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0014_resource'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='driver_driver_license',
            field=models.CharField(max_length=255, blank=True),
            preserve_default=True,
        ),
    ]
