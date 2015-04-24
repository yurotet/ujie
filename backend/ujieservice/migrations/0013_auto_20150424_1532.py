# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0012_auto_20150423_1846'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehicle',
            name='vehicle_licence',
            field=models.CharField(max_length=255, blank=True),
            preserve_default=True,
        ),
    ]
