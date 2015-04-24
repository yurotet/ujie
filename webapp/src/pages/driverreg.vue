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
				model: null,
				imgSrc: null
			};
		},
		methods: {
			onChoosePhoto: function() {
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	this.$data.imgSrc = localIds[0]
				        }
				    }.bind(this)
				});
			},
			onConfirm: function() {
				this._submit();
				return;
				var localId = this.$data.imgSrc;
				if(localId) {
					wx.uploadImage({
						localId: localId,
						isShowProgressTips: 0,
						success: function(res) {
							var wxMediaId = res.serverId; // 返回图片的服务器端ID
							_uploadAvatar(wxMediaId, function(err, res) {
								if(!err) {
									this._submit(res.body);
								}
							}.bind(this));
						}.bind(this)
					});
				}
				console.log(this.$data);
			},
			_submit: function(avatarInfo) {
				var payload = {
				    "driver_name": this.$data.name,
				    "mobile": this.$data.mobile,
				    // "driver_status": "0",
				    "driver_contact": "test",
				    "driver_account_no": "account_no",
				    "driver_account_name": "account_name",
				    "driver_account_bank": "bank",
				    "driver_account_bsb_no": "bsb",
				    "driver_driving_license": "license"
				};
				ajax.put('/service/rest/driver/profile/')
				.send(payload)
				.end(function(err, res) {
				});


				var payload = {
		    		"brand": "chevelot",
		    		"model_id": 1602,
		    		"plate_no": "966r9"
				};
				ajax.post('/service/rest/driver/vehicles/')
				.send(payload)
				.end(function(err, res) {
				});
			},
			_uploadAvatar: function(wxMediaId, cb) {
				ajax.post('/service/rest/common/wxstaticupload/')
				.type('form')
				.send({
					wx_media_id: wxMediaId,
					upload_to: 'avatar'
				})
				.end(cb);
			},
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

<style lang="less">
	.driver-reg {
		.avatar {
			width: 120px;
			height: 120px;
		}
		.avatar-row {
			height: auto;
		}
	}
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
		<div class="input-row avatar-row">
			<label>Avatar</label>
			<img class="avatar" src={{imgSrc}} />
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