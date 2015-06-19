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
			'passportPic.url':function(val){
				var urlStr = 'url("'+val+'")';
				alert(urlStr);
				alert('steting img');
				alert('setting img:'+val);				
				$('.avatar-row .passport').css('background-image', urlStr);	
				$('.avatar-row .passport').css('background-image');		
				this.checkSubmitBtn();
			},
			'licensePic.url': function(val) {
				$('.avatar-row .license').css('background-image','url('+val+')');
				this.checkSubmitBtn();
			},
						
			'guidePic.url': function(val) {
				$('.avatar-row .guide').css('background-image','url('+val+')');
				this.checkSubmitBtn();
			}

		},

		methods: {
			saveData:function(){
				var savedUser = lockr.get('user');
				if (savedUser) {
					lockr.set('user.passportPic',this.$data.passportPic.url );
					lockr.set('user.guidePic',this.$data.guidePic.url );
					lockr.set('user.licensePic',this.$data.licensePic.url);
				}				
			},
			checkSubmitBtn:function(){
				this.saveData();

				var disabled = !this.$data.passportPic.url || !this.$data.licensePic.url || (this.$data.hasGuideCer && !this.guidePic.url);

				var btn = $('#picUploadBtn');
				if (disabled) {
					btn.attr('disabled','disabled');
				} else {
					btn.removeAttr('disabled');
				}
			},

			onChoosePassportPic:function () {
				this.onChoosePhoto('passport');
			},

			onChooselicencePic:function(){
				this.onChoosePhoto('license');
			},

			onChooseGuideLicencePic:function(){
				this.onChoosePhoto('guide');
			},
			
			onChoosePhoto: function(entity) {								
				wx.chooseImage({
				    success: function (res) {
				        var localIds = res.localIds;
				        if(localIds.length) {
				        	var wxMediaId = localIds[0];				        				        
alert(wxMediaId);
				        	this.showLoading();
				        	wx.uploadImage({
						localId: wxMediaId,
						isShowProgressTips: 0,
						success: function(res) {
							var wxMediaId = res.serverId; // 返回图片的服务器端ID
							alert('wx media id:'+wxMediaId);
							this._uploadPic(wxMediaId, function(url) {							
								this.hideLoading();
								if(url) {
									alert('remtoe urlr :'+url);
									switch (entity) {
										case 'passport':
										alert('settignj passprot');
											this.$data.passportPic.url = url;
										break ;
										case 'license':
											this.$data.licensePic.url = url;
										break;
										case 'guidePic':
											this.$data.guidePic.url = url;
										break;
									}
									// entity = url;
									// console.log(JSON.stringify(res));
									// picEntity.url = res.kld



									// this.$data.user.driver_avatar = res.body.static_url;
									// var payload = {
									//     "driver_avatar": res.body.static_url,
									// };
									// this.showLoading();
									// ajax.put('/service/rest/driver/user/')
									// .send(payload)
									// .end(function(err, res) {
				     //    						this.hideLoading();
									// }.bind(this));
								}
							}.bind(this));
						}.bind(this),
						fail: function() {
							alert(' wx pic update fail');
							this.hideLoading();
						}
					});
				        }
				    }.bind(this)
				});
			},
			
			onSubmit: function() {
				nav.goTo('accRegister');
				// this.showLoading();
				// this._submit().then(function() {
				// 	this._loadUser().then(function() {
				// 		this.hideLoading();
				// 	}.bind(this));
				// }.bind(this));
			},
			// _submit: function() {
			// 	var promise1 = new Promise(function(resolve, reject) {
			// 		var payload = {
			// 		    "driver_name": this.$data.user.driver_name,
			// 		    "mobile": this.$data.user.mobile,
			// 		    "driver_avatar": this.$data.user.driver_avatar,
			// 		    "driver_driver_license": this.$data.user.driver_driver_license,
			// 		    // "driver_status": "0",
			// 		    "driver_contact": this.$data.user.mobile,
			// 		    "driver_account_no": "account_no",
			// 		    "driver_account_name": "account_name",
			// 		    "driver_account_bank": "bank",
			// 		    "driver_account_bsb_no": "bsb",
			// 		    "driver_driving_license": "license"
			// 		};
			// 		ajax.put('/service/rest/driver/user/')
			// 		.send(payload)
			// 		.end(function(err, res) {
			// 			resolve();
			// 		});
			// 	}.bind(this));

			// 	var promise2 = new Promise(function(resolve, reject) {
			// 		var payload = {
			//     		"brand": this.$data.vehicle.brand,
			//     		"model": parseInt(this.$data.vehicle.model.model_id, 10),
			//     		"plate_no": this.$data.vehicle.plate_no
			// 		};
			// 		var vehicleId = this.$data.vehicle.vehicle_id;
			// 		if(vehicleId) {
			// 			ajax.put('/service/rest/driver/vehicles/' + vehicleId + '/')
			// 			.send(payload)
			// 			.end(function(err, res) {
			// 				resolve();
			// 			});
			// 		} else {
			// 			ajax.post('/service/rest/driver/vehicles/')
			// 			.send(payload)
			// 			.end(function(err, res) {
			// 				resolve();
			// 			});
			// 		}
			// 	}.bind(this));

			// 	return Promise.all([promise1, promise2]);
			// },
			// _uploadAvatar: function(wxMediaId, cb) {
			// 	ajax.post('/service/rest/common/wxstaticupload/')
			// 	.type('form')
			// 	.send({
			// 		wx_media_id: wxMediaId,
			// 		upload_to: 'avatar'
			// 	})
			// 	.end(cb);
			// },
			_uploadPic: function(wxMediaId, cb) {
				$.ajax({
					  type:'POST',				  
					  url: '/api/upload_img', 
					  data: {media_id: wxMediaId},				 
					  dataType: 'json',
					  timeout: 10000,
					  context: this,
					 success: function(res){	
					 alert(JSON.stringify(res));				  					
					  	if(res.err_code==0){					  		
					  		cb(res.data.img_url);	
					  	} else {			  		
					  		cb(); 
					  	}
					    
					  },
					  complete:function() {
					  	alert('pic upload complete')
					  	// this.hideLoading();					  	
					  },
					
					  error: function(xhr, type){
					   	alert('pic upload failed');
					   	cb();
					  }
				});					
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
			var savedUser = lockr.get('user');
			if (savedUser) {
				this.$data.passportPic.url = savedUser.passportPic;
				this.$data.guidePic.url = savedUser.guidePic;
				this.$data.licensePic.url = savedUser.licensePic;
			}

			setTimeout(this.checkSubmitBtn,0);
		},
		resume:function() {
			this.refreshWX();		
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
	  	 	<div  v-on="click:onChoosePassportPic" v-component="view/picUpload"  v-with="title: passportPic.title,cls:'passport'"></div>		
			<div  v-on="click:onChooselicencePic" v-component="view/picUpload"  v-with="title:licensePic.title, cls:'license'"></div>	
			<div  style="display:{{hasGuideCer? 'block':'none'}}" v-on="click:onChooseGuideLicencePic" v-component="view/picUpload"  v-with="title:guidePic.title, cls:'guide'"></div>	
		</form>
	</div>

	
	<button id="picUploadBtn" class="btn btn-positive btn-block"  disabled="disabled" v-on="click: onSubmit">下一步, 填写结算账户信息</button>
	<button id="picUploadPreBtn" class="btn btn-nagtive btn-block" v-on="click: onPre">上一步</button>

</template>