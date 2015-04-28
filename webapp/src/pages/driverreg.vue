<script>
	var BasePage = require('common/basepage');
	var ajax = require('common/ajax');
	var wxutil = require('common/wxutil');

	var View = BasePage.extend({
		title: 'index',
		data: function() {
			return {
				profile: {},
				vehicle: {
					model: {
						model_id: null,
						manufactuer: {
							manufactuer_id: null
						}
					}
				},
				manufactuerList: [],
				modelList: []
			};
		},
		computed: {
			computedId: {
				// the getter should return the desired value
				get: function () {
				},
				// the setter is optional
				set: function (newValue) {
				}
			}
		},
		methods: {
			onChoosePhoto: function() {
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	this.$data.profile.driver_avatar = localIds[0];
				        	this.$data.profile.driver_avatar_updated = true;
				        }
				    }.bind(this)
				});
			},
			onChooseDriverLicense: function() {
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	this.$data.profile.driver_driver_license = localIds[0];
				        	this.$data.profile.driver_driver_license_updated = true;
				        }
				    }.bind(this)
				});
			},
			onConfirm: function() {
				if(this.$data.profile.driver_avatar_updated) {
					wx.uploadImage({
						localId: this.$data.profile.driver_avatar,
						isShowProgressTips: 0,
						success: function(res) {
							var wxMediaId = res.serverId; // 返回图片的服务器端ID
							this._uploadAvatar(wxMediaId, function(err, res) {
								if(!err) {
									this.$data.profile.driver_avatar = res.body.static_url;
									this._submit();
								}
							}.bind(this));
						}.bind(this)
					});
				}
				if(this.$data.profile.driver_driver_license_updated) {
					wx.uploadImage({
						localId: this.$data.profile.driver_driver_license,
						isShowProgressTips: 0,
						success: function(res) {
							var wxMediaId = res.serverId; // 返回图片的服务器端ID
							this._uploadDriverLisence(wxMediaId, function(err, res) {
								if(!err) {
									this.$data.profile.driver_driver_license = res.body.static_url;
									this._submit();
								}
							}.bind(this));
						}.bind(this)
					});
				}
			},
			_submit: function() {
				var payload = {
				    "driver_name": this.$data.profile.driver_name,
				    "mobile": this.$data.profile.mobile,
				    "driver_avatar": this.$data.profile.driver_avatar,
				    "driver_driver_license": this.$data.profile.driver_driver_license,
				    // "driver_status": "0",
				    "driver_contact": this.$data.profile.mobile,
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
		    		"brand": this.$data.vehicle.brand,
		    		"model": parseInt(this.$data.vehicle.model.model_id, 10),
		    		"plate_no": this.$data.vehicle.plate_no
				};
				var vehicleId = this.$data.vehicle.vehicle_id;
				if(vehicleId) {
					ajax.put('/service/rest/driver/vehicles/' + vehicleId + '/')
					.send(payload)
					.end(function(err, res) {
					});
				} else {
					ajax.post('/service/rest/driver/vehicles/')
					.send(payload)
					.end(function(err, res) {
					});
				}
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
			_uploadDriverLisence: function(wxMediaId, cb) {
				ajax.post('/service/rest/common/wxuserupload/')
				.type('form')
				.send({
					wx_media_id: wxMediaId
				})
				.end(cb);
			},
			_loadManufactuerList: function() {
				ajax.get('/service/rest/common/manufactuers/')
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
						if(list.length && !this.$data.vehicle.vehicle_id) {
							this.$data.vehicle.model.manufactuer.manufactuer_id = list[0].value;
						}
					}
				}.bind(this));
			}
		},
		created: function() {
			wxutil.config();
			this.$watch('vehicle.model.manufactuer.manufactuer_id', function(newVal, oldVal) {
				this.$data.modelList = [];
				ajax.get('/service/rest/common/manufactuers/' + newVal + '/models/')
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
							this.$data.vehicle.model.model_id = list[0].value;
						}
					}
				}.bind(this));
			});

			ajax.get('/service/rest/driver/profile/')
			.end(function(err, res) {
				if(!err) {
					var body = res.body;
					this.$data.profile = body;
					this.$data.profile.driver_avatar = this.$data.profile.driver_avatar || null;
					if(body.driver_vehicles.length) {
						this.$data.vehicle = body.driver_vehicles[0];
					} else {
						this.$data.vehicle = {
							model: {
								model_id: null,
								manufactuer: {
									manufactuer_id: null
								}
							}
						};
					}
					this._loadManufactuerList();
				}
			}.bind(this));
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
			<input type="text" placeholder="Name" v-model="profile.driver_name">
		</div>
		<div class="input-row">
			<label>Email</label>
			<input type="email" placeholder="abc@abc.com" v-model="email">
		</div>
		<div class="input-row">
			<label>Sex</label>
			<input type="radio" name="sex" value="male" v-model="profile.sex"> male
    		<input type="radio" name="sex" value="female" v-model="profile.sex"> female
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
			<img class="avatar" src={{profile.driver_avatar}} />
			<button class="btn btn-primary" v-on="click: onChoosePhoto">
			  	Choose Photo
			</button>
		</div>
		<div class="input-row avatar-row">
			<label>Driver Lisence</label>
			<img class="avatar" src={{profile.driver_driver_license}} />
			<button class="btn btn-primary" v-on="click: onChooseDriverLicense">
			  	Choose Driver License
			</button>
		</div>
		<div class="input-row">
			<label>Manufactuer</label>
			<select class="test" v-model="vehicle.model.manufactuer.manufactuer_id" options="manufactuerList"></select>
		</div>
		<div class="input-row">
			<label>Model</label>
			<select v-model="vehicle.model.model_id" options="modelList"></select>
		</div>
		<div class="input-row">
			<label>PlateNo</label>
			<input type="text" v-model="vehicle.plate_no">
		</div>
		<div class="input-row">
			<label>Brand</label>
			<input type="text" v-model="vehicle.brand">
		</div>
		<button class="btn btn-positive btn-block" v-on="click: onConfirm">Confirm</button>
	</section>
</template>