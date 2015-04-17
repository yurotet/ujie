# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0008_manufactuer_model'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='driver_avatar',
            field=models.ImageField(null=True, upload_to='driver_avatars'),
            preserve_default=True,
        ),
    ]
