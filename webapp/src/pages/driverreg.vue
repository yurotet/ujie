<script>
	var BasePage = require('common/basepage');
	var ajax = require('common/ajax');
	var wxutil = require('common/wxutil');

	var View = BasePage.extend({
		title: 'index',
		data: function() {
			return {
				sex: 'male',
				manufactuerList: [],
				modelList: [],
				manufactuer: null,
				model: null
			};
		},
		methods: {
			onChoosePhoto: function() {
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        console.log(localIds);
				    }
				});
			},
			onConfirm: function() {
				console.log(this.$data);
			}
		},
		created: function() {
			wxutil.config();
			ajax
			.get('/service/rest/common/manufactuers/')
			.end(function(err, res) {
				if(!err) {
					var body = res.body;
					var list = body.map(function(item) {
						return {
							value: item.manufactuer_id,
							text: item.name
						};
					});
					this.$data.manufactuerList = list;
					if(list.length) {
						this.$data.manufactuer = list[0].value;
					}
				}
			}.bind(this));
			this.$watch('manufactuer', function(newVal, oldVal) {
				this.$data.modelList = [];
				ajax
				.get('/service/rest/common/manufactuers/' + newVal + '/models/')
				.end(function(err, res) {
					if(!err) {
						var body = res.body;
						var list = body.map(function(item) {
							return {
								value: item.model_id,
								text: item.name
							};
						});
						this.$data.modelList = list;
						if(list.length) {
							this.$data.model = list[0].value;
						}
					}
				}.bind(this));
			});
		},
		ready: function() {
		},
		attached: function() {
		},
		detached: function() {
		}
	});

	module.exports = View;
</script>

<style>
</style>

<template>
	<section class="driver-reg">
		<div class="input-row">
			<label>Name</label>
			<input type="text" placeholder="Name" v-model="name">
		</div>
		<div class="input-row">
			<label>Email</label>
			<input type="email" placeholder="abc@abc.com" v-model="email">
		</div>
		<div class="input-row">
			<label>Sex</label>
			<input type="radio" name="sex" value="male" v-model="sex"> male
    		<input type="radio" name="sex" value="female" v-model="sex"> female
		</div>
		<div class="input-row">
			<label>Birth</label>
			<input type="date" v-model="birth">
		</div>
		<div class="input-row">
			<label>Contact</label>
			<input type="text" v-model="mobile">
		</div>
		<div class="input-row">
			<label>Avatar</label>
			<button class="btn btn-primary" v-on="click: onChoosePhoto">
			  	Choose Photo
			</button>
		</div>
		<div class="input-row">
			<label>Manufactuer</label>
			<select class="test" v-model="manufactuer" options="manufactuerList"></select>
		</div>
		<div class="input-row">
			<label>Model</label>
			<select v-model="model" options="modelList"></select>
		</div>
		<button class="btn btn-positive btn-block" v-on="click: onConfirm">Confirm</button>
	</section>
</template>