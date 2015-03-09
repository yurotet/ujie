# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0003_auto_20150309_1901'),
    ]

    operations = [
        migrations.RenameField(
            model_name='order',
            old_name='timestamp',
            new_name='updated_time',
        ),
    ]
