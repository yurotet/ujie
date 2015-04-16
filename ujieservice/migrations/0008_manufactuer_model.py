# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ujieservice', '0007_remove_profile_user_type'),
    ]

    operations = [
        migrations.CreateModel(
            name='Manufactuer',
            fields=[
                ('manufactuer_id', models.AutoField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, null=True, blank=True)),
            ],
            options={
                'db_table': 'manufactuer',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Model',
            fields=[
                ('model_id', models.AutoField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=100, null=True, blank=True)),
                ('manufactuer', models.ForeignKey(related_name='models', to='ujieservice.Manufactuer', null=True)),
            ],
            options={
                'db_table': 'model',
            },
            bases=(models.Model,),
        ),
    ]
