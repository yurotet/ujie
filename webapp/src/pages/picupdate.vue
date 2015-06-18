<script>
	var BasePage = require('common/basepage');	
	var wxutil = require('common/wxutil');	
	var picUpload= require('pages/picUploadCmp');
	var steps = require('pages/regSteps');
	var nav = require('common/navigator');
	var lockr = require('common/localstorageutil');
	var util = require('common/util');

	var View = BasePage.extend({
		title: '上传认证图片',
		data:function(){			
			return {	
				curStep:3,

				hasGuideCer: false,

				passportPic:{
					title:'上传护照 (必传)',
					url:''
				},

				licensePic: {
					title:'上传驾照 (必传)',
					url:''
				},						
								
				guidePic: {
					title:'导游证照片 (必传)',
					url:''
				}			
			}
		},

		watch: {
			'passportPic.url':this.checkSubmitBtn,
			'licensePic.url': this.checkSubmitBtn,			
			'guidePic.url': this.checkSubmitBtn
		},

		methods: {
			checkSubmitBtn:function(){
				var disabled = !this.$data.passportPic.url || !this.$data.licensePic.url || (this.$data.hasGuideCer && !this.guidePic.url);

				var btn = $('#picUploadBtn');
				if (disabled) {
					btn.attr('disabled','disabled');
				} else {
					btn.removeAttr('disabled');
				}
			},

			onChoosePassportPic: function() {								
				wx.chooseImage({
				    success: function (res) {alert(res);
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	var wxMediaId = localIds[0];
				        	this.$data.user.driver_avatar = wxMediaId;
				        	this.$data.user.driver_avatar_updated = true;

				        	this.showLoading();
				        	wx.uploadImage({
								localId: wxMediaId,
								isShowProgressTips: 0,
								success: function(res) {
									var wxMediaId = res.serverId; // 返回图片的服务器端ID
									this._uploadAvatar(wxMediaId, function(err, res) {
										this.hideLoading();
										if(!err) {
											this.$data.user.driver_avatar = res.body.static_url;
											var payload = {
											    "driver_avatar": res.body.static_url,
											};
											this.showLoading();
											ajax.put('/service/rest/driver/user/')
											.send(payload)
											.end(function(err, res) {
						        				this.hideLoading();
											}.bind(this));
										}
									}.bind(this));
								}.bind(this),
								fail: function() {
									this.hideLoading();
								}
							});
				        }
				    }.bind(this)
				});
			},
			onChooseDriverLicense: function() {
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	var wxMediaId = localIds[0];
				        	this.$data.user.driver_driver_license = wxMediaId;
				        	this.$data.user.driver_driver_license_updated = true;

				        	this.showLoading();
				        	wx.uploadImage({
								localId: wxMediaId,
								isShowProgressTips: 0,
								success: function(res) {
									var wxMediaId = res.serverId; // 返回图片的服务器端ID
									this._uploadDriverLisence(wxMediaId, function(err, res) {
										this.hideLoading();
						        		if(!err) {
						        			this.$data.user.driver_driver_license = res.body.static_url;
						        			var payload = {
											    "driver_driver_license": res.body.static_url,
											};
											this.showLoading();
											ajax.put('/service/rest/driver/user/')
											.send(payload)
											.end(function(err, res) {
						        				this.hideLoading();
											}.bind(this));
						        		}
						        	}.bind(this));
								}.bind(this),
								fail: function() {
									this.hideLoading();
								}.bind(this)
							});
				        }
				    }.bind(this)
				});
			},
			onSubmit: function() {
				// nav.goTo('paper');
				// this.showLoading();
				// this._submit().then(function() {
				// 	this._loadUser().then(function() {
				// 		this.hideLoading();
				// 	}.bind(this));
				// }.bind(this));
			},
			_submit: function() {
				var promise1 = new Promise(function(resolve, reject) {
					var payload = {
					    "driver_name": this.$data.user.driver_name,
					    "mobile": this.$data.user.mobile,
					    "driver_avatar": this.$data.user.driver_avatar,
					    "driver_driver_license": this.$data.user.driver_driver_license,
					    // "driver_status": "0",
					    "driver_contact": this.$data.user.mobile,
					    "driver_account_no": "account_no",
					    "driver_account_name": "account_name",
					    "driver_account_bank": "bank",
					    "driver_account_bsb_no": "bsb",
					    "driver_driving_license": "license"
					};
					ajax.put('/service/rest/driver/user/')
					.send(payload)
					.end(function(err, res) {
						resolve();
					});
				}.bind(this));

				var promise2 = new Promise(function(resolve, reject) {
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
							resolve();
						});
					} else {
						ajax.post('/service/rest/driver/vehicles/')
						.send(payload)
						.end(function(err, res) {
							resolve();
						});
					}
				}.bind(this));

				return Promise.all([promise1, promise2]);
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
				return new Promise(function(resolve, reject) {
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
							// if(list.length && !this.$data.vehicle.vehicle_id) {
							// 	this.$data.vehicle.model.manufactuer.manufactuer_id = list[0].value;
							// }
							resolve(body);
						} else {
							reject();
						}
					}.bind(this));
				}.bind(this));
			},
			_loadModelList: function(manufactuerId) {
				return new Promise(function(resolve, reject) {
					ajax.get('/service/rest/common/manufactuers/' + manufactuerId + '/models/')
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
							// if(list.length) {
							// 	this.$data.vehicle.model.model_id = list[0].value;
							// }
							resolve(body);
						} else {
							reject();
						}
					}.bind(this));
				}.bind(this));
			},
			_startWatchManufactuer: function() {
				this.$watch('vehicle.model.manufactuer.manufactuer_id', function(newVal, oldVal) {
					this.$data.modelList = [];
					this.showLoading();
					ajax.get('/service/rest/common/manufactuers/' + newVal + '/models/')
					.end(function(err, res) {
						this.hideLoading();
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
			},
			_loadUser: function() {
				return new Promise(function(resolve, reject) {
					ajax.get('/service/rest/driver/user/')
					.end(function(err, res) {
						if(!err) {
							var body = res.body;
							this.$data.user = body;
							this.$data.user.driver_avatar = this.$data.user.driver_avatar || null;
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
							resolve(body);
						} else {
							reject();
						}
					}.bind(this));
				}.bind(this));
			},

			setHeader:function(){
				var selText = '.stepsContainer.index3 .step3' ;
								
				var ela=$(selText+' a'),
					eltext=$(selText+ ' .text');		
		 		
		 		ela.css('width','170px');	  		
		  		ela.css('background-color','#77c2a5');

		  		eltext.css('display','inline-block');
		  		eltext.css('opacity','1');		
			},
			onPre:function () {
				nav.goTo('register');
			},

			refreshWX:function() {
				var nonceStr = util.uuid();
				var timestamp = +new Date();
				var url = location.href.split('#')[0];
				$.ajax({	 
					  type:'POST',				  
					  url: '/api/weixin_signature', 
					  // data to be added to query string:
					 data: {
						timestamp: timestamp,
						noncestr: nonceStr,
						url: url
					},
					  // type of data we are expecting in return:
					  dataType: 'json',
					  timeout: 10000,
					  context: this,
					  success: function(body){	
					  	if (body.err_code == 0 ) {
					  		var data = body.data;					  		
					  		var wxConfig = {
								// debug: true,
								appId: data.appId,
								timestamp: data.timestamp,
								nonceStr: data.nonceStr,
								signature: data.signature,
								jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']
							}

					  		wx.config(wxConfig);
					  		alert(JSON.stringify(wxConfig));
					  	} else {

					  	}					  						   
					  },
					  complete:function() {
					  					  	
					  },
					
					  error: function(xhr, type){
					   	
					  }
				})	
			}
		},
		created: function() {
			
		},
		resume:function() {alert('resumed');
			// this.refreshWX();		
			this.setHeader();

			var savedUser = lockr.get('user');
			if (savedUser) {
				this.$data.hasGuideCer = savedUser.hasGuideCer == 'yes';
			}
						
		},
		pause:function(){

		}			
	});

	module.exports = View;
</script>

<style>
	#userInfo .input-row input{
		width: 65%;
	}
	#userInfo select {
		margin-top: 5px;
		width:65%;
	}

	.input-row label.more{
		font-size: 14px;
	}

	.input-row button{
		margin-top: 5px;
		float:right;
		margin-right: 20px;
	}
	#picUploadPreBtn {
		display: 'inline-block';
		width : 35%;
	}
	#picUploadBtn {
		display: 'inline-block';
		width: 60%;
		float: right;
	}
</style>

<template>
	<div v-component="view/regSteps" v-with="step:curStep"></div>
	  <div>
	  	 <form class="input-group">
	  	 	<div  v-on="click:onChoosePassportPic" v-component="view/picUpload"  v-with="title: passportPic.title"></div>		
			<div  v-on="click:onChooselicencePic" v-component="view/picUpload"  v-with="title:licensePic.title"></div>	
			<div  style="display:{{hasGuideCer? 'block':'none'}}" v-on="click:onChooseGuideLicencePic" v-component="view/picUpload"  v-with="title:guidePic.title"></div>	
		</form>
	</div>

	
	<button id="picUploadBtn" class="btn btn-positive btn-block" disabled="disabled" v-on="click: onSubmit">下一步</button>
	<button id="picUploadPreBtn" class="btn btn-nagtive btn-block" v-on="click: onPre">上一步</button>

</template>