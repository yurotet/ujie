# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0010_auto_20150423_1758'),
    ]

    operations = [
        migrations.AlterField(
            model_name='vehicle',
            name='model',
            field=models.ForeignKey(related_name='vehicles', to='ujieservice.Model', null=True),
            preserve_default=True,
        ),
    ]
