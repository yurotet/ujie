webpackJsonp([8],{

/***/ 68:
/***/ function(module, exports, __webpack_require__) {

	var inserted = {};

	module.exports = function (css, options) {
	    if (inserted[css]) return;
	    inserted[css] = true;
	    
	    var elem = document.createElement('style');
	    elem.setAttribute('type', 'text/css');

	    if ('textContent' in elem) {
	      elem.textContent = css;
	    } else {
	      elem.styleSheet.cssText = css;
	    }
	    
	    var head = document.getElementsByTagName('head')[0];
	    if (options && options.prepend) {
	        head.insertBefore(elem, head.childNodes[0]);
	    } else {
	        head.appendChild(elem);
	    }
	};


/***/ },

/***/ 69:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {var nav = __webpack_require__(65);
	var Vue = __webpack_require__(3);
	var $Class = __webpack_require__(81);

	var M = Vue.extend({
	});

	$Class.mix(M.prototype, {
		name: 'BagePage',
		// startMode: "singleton",
		startMode: "newinstance",

		intervalCounter : 0,

		startPage: function(route) {
			nav.goTo(route);
		},
		startPageForResult: function(route, cb) {
		},
		back: function() {
			nav.back();
		},	

		hideToast:function(){

			var alert = document.getElementById("toast");

			if (alert)  {
				alert.style.opacity = 0;
				alert.style.display='none';	
				clearInterval(this.intervalCounter);
			}
		},

		 showToast:function(message,isError){
			this.hideToast();

			var alert = document.getElementById("toast");		

			if (alert == null){
				var toastHTML = '<div id="toast">' + message + '</div>';
				document.body.insertAdjacentHTML('beforeEnd', toastHTML);

			}
			else{
				$(alert).text(message);
				alert.style.display='block';
				alert.style.opacity = .9;
			}		

			intervalCounter = setInterval(this.hideToast,  isError? 2200:1300);

		},

		showLoading: function() {		
			$('.m-load2').css('display','block');
			$('.js-loading').addClass('active');
			setTimeout(this.hideLoading, 10000); // 10 seconds timeout
		},

		hideLoading: function() {
			$('.m-load2').css('display','none');
			$('.js-loading').removeClass('active');
		}
	});

	module.exports = M;
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(2)))

/***/ },

/***/ 71:
/***/ function(module, exports, __webpack_require__) {

	var Vue = __webpack_require__(3);
	var M = Vue.extend({
		onCreate: function() {

		},
		onResume: function() {

		},
		onPause: function() {

		}
	});

	module.exports = M;

/***/ },

/***/ 77:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {__webpack_require__(68)("#userInfo .input-row input{width:65%}#userInfo select{margin-top:5px;width:65%}.input-row label.more{font-size:14px}.input-row button{margin-top:5px;float:right;margin-right:20px}#picUploadPreBtn{display:'inline-block';width:35%}#picUploadBtn{display:'inline-block';width:60%;float:right}");
	var __vue_template__ = "<div v-component=\"view/regSteps\" v-with=\"step:curStep\"></div>\n\t  <div>\n\t  \t <form class=\"input-group\">\n\t  \t \t<div v-on=\"click:onChoosePassportPic\" v-component=\"view/picUpload\" v-with=\"title: passportPic.title,cls:'passport'\"></div>\t\t\n\t\t\t<div v-on=\"click:onChooselicencePic\" v-component=\"view/picUpload\" v-with=\"title:licensePic.title, cls:'license'\"></div>\t\n\t\t\t<div style=\"display:{{hasGuideCer? 'block':'none'}}\" v-on=\"click:onChooseGuideLicencePic\" v-component=\"view/picUpload\" v-with=\"title:guidePic.title, cls:'guide'\"></div>\t\n\t\t</form>\n\t</div>\n\n\t\n\t<button id=\"picUploadBtn\" class=\"btn btn-positive btn-block\" disabled=\"disabled\" v-on=\"click: onSubmit\">下一步, 填写结算账户信息</button>\n\t<button id=\"picUploadPreBtn\" class=\"btn btn-nagtive btn-block\" v-on=\"click: onPre\">上一步</button>";
	var BasePage = __webpack_require__(69);	
		var wxutil = __webpack_require__(92);	
		var picUpload= __webpack_require__(94);
		var steps = __webpack_require__(78);
		var nav = __webpack_require__(65);
		var lockr = __webpack_require__(91);
		var util = __webpack_require__(93);

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
				'passportPic.url':function(imageUrl){
					 this.$data.passportPic.url = imageUrl;
					 alert('img:'+imageUrl);
					$('.avatar-row .passport').css('background-image', 'url(' + imageUrl + ')');	
					$('.avatar-row .passport').css('height','50px');			
					alert($('.avatar-row .passport').css('background-image'));		
					this.checkSubmitBtn();
				},
				'licensePic.url': function(imageUrl) {
					this.$data.guidePic.url  = imageUrl;
					$('.avatar-row .license').css('background-image', 'url(' + imageUrl + ')');	
					this.checkSubmitBtn();
				},
							
				'guidePic.url': function(imageUrl) {
					this.$data.licensePic.url  = imageUrl;
					$('.avatar-row .guide').css('background-image', 'url(' + imageUrl + ')');	
					this.checkSubmitBtn();
				}

			},

			methods: {
				saveData:function(){
					var savedUser = lockr.get('user');
					if (savedUser) {
						alert('dkggg:'+this.$data.passportPic.url);
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
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;

	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(2)))

/***/ },

/***/ 78:
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(68)("ul.breadcrumb{display:inline-block;list-style:none;margin:0}ul.breadcrumb li{float:right;padding:5px;background-color:#fff;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;position:relative;margin-left:-50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;margin-top:3px}ul.breadcrumb li a{overflow:hidden;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;text-decoration:none;height:50px;color:#509378;background-color:#65ba99;text-align:center;min-width:50px;display:block;line-height:50px;padding-left:52px;padding-right:33.33px;width:50px}ul.breadcrumb li a .icon{font-size:14px;display:inline-block}ul.breadcrumb li a .text{font-size:16px;font-weight:700;display:none;opacity:0}ul.breadcrumb li:last-child a{padding:0}.stepsContainer{text-align:center}");
	var __vue_template__ = "<div class=\"stepsContainer index{{step}}\">\n\t<ul class=\"breadcrumb\">\n\t  <li class=\"step1\"> \n\t    <a>\n\t      <span class=\"icon icon-check\"></span>\n\t      <span class=\"text\">提交审核</span>\n\t    </a>\n\t  </li>\n\t  <li class=\"step2\"> \n\t    <a>\n\t      <span class=\"icon icon-list\"></span>\n\t      <span class=\"text\">结算账户</span>\n\t    </a>\n\t  </li>\n\t  <li class=\"step3\">\n\t    <a>\n\t      <span class=\"icon icon-pages\"></span>\n\t      <span class=\"text\">认证照片</span>\n\t    </a>\n\t  </li>\t  \n\t  <li class=\"step4\">\n\t    <a>\n\t      <span class=\"icon icon-info\"></span>\n\t       <span class=\"text\">我的资料</span>\n\t    </a>\n\t  </li>\n\t</ul>\t\n</div>";
	var BaseComponent = __webpack_require__(71);
		var Vue = __webpack_require__(3);


		var View = BaseComponent.extend({
			title: 'regSteps',	
			data:  function(){
				return {
					step:1
				};
			},

			created:function(){
				
			}				
		});

		module.exports = View;

		Vue.component('view/regSteps', View);
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;


/***/ },

/***/ 81:
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;// Class.js 1.4.4
	// author Tangoboy
	// http://www.cnblogs.com/tangoboy/archive/2010/08/03/1790412.html
	// Dual licensed under the MIT or GPL Version 2 licenses.

	(function(root, factory) {

		// Set up $Class appropriately for the environment. Start with AMD or TMD(Im.js)
		if (true ) {

			!(__WEBPACK_AMD_DEFINE_ARRAY__ = [], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory), __WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ? (__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));

		// Next for Node.js or CommonJS.
		} else if (typeof exports !== 'undefined') {

			factory(exports);

		// Finally, as a browser global.
		} else {

			factory(root);

		}

	}(this, function(host){

		//不能在严谨代码模式 'use strict';

		var uuid = 0,
		opt = Object.prototype.toString,
		isStr = function(s){return opt.call(s)=="[object String]"},
		isFun = function(f){return opt.call(f)=="[object Function]"},
		isObj = function(o){return opt.call(o)=="[object Object]"},
		isArr = function(a){return opt.call(a)=="[object Array]"},
		isSupport__proto__ = ({}).__proto__ == Object.prototype,//检验__proto__特性
		clone = function(obj){
			var newObj,
				noop = function(){};
			if (Object.create) {
				newObj = Object.create(obj);
			} else {
				noop.prototype = obj;
				newObj = new noop();
			}
			return newObj;
		};
		//创建一个原型对象，创建的是一次克隆
		function createPrototype(proto, constructor) {
			var newProto = clone(proto);
			newProto.constructor = constructor;
			return newProto;
		}
		//混杂
		function mix(r, s) {
			for (var i in s) {
				r[i] = s[i];
			}
			return r;
		}
		//无new实例化 构造函数包裹 使类同时支持 new A() 或 A() 实例化
		function wrapConstructor(constructor){
			return function(){
				var selfConstructor = arguments.callee;
				if(this && this instanceof selfConstructor){// && this.constructor == selfConstructor
					var re = constructor.apply(this, arguments);
					return re&&isObj(re) ? re : this;
				} else {
					return $Class['new'](selfConstructor, arguments);
				}
			};
		}


		var config = {
			constructorName:'__',       //构造方法约定名称，默认约定为双下划线__
			autoSuperConstructor:false, //当子类被实例化时是否先执行父类构造函数 设置后仅对后面声明的类有效
			notUseNew:true,             //是否可以不使用关键字new 直接调用方法实例化对象 如：A()
			useExtend:true,             //是否使用让类拥有拓展继承的方法 如：B = A.$extend({})
			useMixin:true,              //是否使用让类拥有混入其他原型的方法 如：A.$mixin([C.prototype, D.prototype])
			useSuper:true,              //是否让类有$super属性访问父类成员 如：B.$super.foo()
			disguise:false,             //是否让代码生成的构造函数伪装成定义的__:function(){}
			useConstructor:true         //是否使用B.$constructor来保存定义的__构造函数，这里create inherit生成的构造函数是不等于__的
		};


		var $Class = {
			
			/**
			 * UUID方法 生成唯一的id字符串
			 *
			 * @param {String} [prefix] id前缀
			 * @return {String} 唯一的id字符串
			 * @doc
			 */
			uuid:function(prefix){
				return (prefix||"cls_") + (+new Date()).toString( 32 ) + (uuid++).toString( 32 );
			},

			
			Base:null,//作用见后面赋值

			/**
			 * 配置方法 对某些功能设置是否开启.  配置说明见config定义
			 *
			 * @param {String|Object|null} c 某个配置项名|设置配置项|空值
			 * @return {Mixed|Object|Object} 取出某个配置项|混合后的设置配置项|取出所有配置
			 * @doc
			 */
			config:function(c){
				if (isStr(c)){
					return config[c];
				} else if (isObj(c)){
					return config = mix(config, c);
				}
				return config;
			},
			/**
			 * 创建一个类  混合构造函数/原型方式.
			 *
			 * @param {Object} members 定义类成员的对象
			 * @return {Function(Class)} 返回创建的类
			 * @doc
			 */
			create: function(members) {
				return $Class.inherit($Class.Base||Object, members);
			},
			/**
			 * 实例化类 可以替代 new 操作符
			 *
			 * @param {Function(Class)} clas 类
			 * @param {Array} [args] 参数
			 * @return {Object} 返回构建的实例
			 * @doc
			 */
			"new":function(clas, args){
				if (isFun(clas)) {
					var instance = clone(clas.prototype);
					var re = clas.apply(instance, args||[]);
					return re&&isObj(re) ? re : instance;
				} else {
					throw new Error('fatal error: $Class.new expects a constructor of class.');  
				}
			},
			/**
			 * 继承  混合对象冒充原型链方式.
			 *       目前只对构造函数上加上某些属性（如：$super，$constructor，$extend）
			 *       但类的实例是没有任何污染的
			 *
			 * @param {Function(Class)} source 父类
			 * @param {Object} [extendMembers] 定义类成员的对象
			 * @param {Boolean} [autoSuperConstructor] 默认false 当子类被实例化时是否先执行父类构造函数
			 * @return {Function(Class)} 返回创建的子类
			 * @doc
			 *
			 * 差异：
			 *		1.返回类 !== extendMembers.__
			 *		2.不支持__proto__的浏览器下 for in 遍历实例会遍历出constructor
			 */
			inherit:function(source, extendMembers, autoSuperConstructor) {
				if (!isFun(source)) return;
				extendMembers = extendMembers || {};
				autoSuperConstructor = autoSuperConstructor||config.autoSuperConstructor;
				var defineConstructor = extendMembers[config.constructorName] || function(){};
				//过滤构造方法和原型方法
				delete extendMembers[config.constructorName];
				//对象冒充
				var _constructor = function(){
					if(autoSuperConstructor){
						source.apply(this, arguments);
					}
					var re = defineConstructor.apply(this, arguments);
					if(re && isObj(re))return re;
				};

				if (config.notUseNew) {
					//构造函数包裹 new A 和 A() 可以同时兼容
					_constructor = wrapConstructor(_constructor);
				}
				if (config.disguise) {
					_constructor.name = defineConstructor.name;
					_constructor.length = defineConstructor.length;
					_constructor.toString = function(){return defineConstructor.toString()};//屏蔽了构造函数的实现
				}
				//维持原型链 把父类原型赋值到给构造器原型，维持原型链
				if (isSupport__proto__) { 
					_constructor.prototype.__proto__ = source.prototype;
				} else {
					_constructor.prototype = createPrototype(source.prototype, _constructor);
				}
				
				//原型扩展 把最后配置的成员加入到原型上
				this.include(_constructor, extendMembers);

				if (config.useSuper) {
					//添加父类属性
					_constructor.$super = createPrototype(source.prototype, source);
				}

				if (config.useSuper) {
					//添加定义的构造函数
					_constructor.$constructor = defineConstructor;
				}

				if (config.useExtend) {
					_constructor.$extend = function(extendMembers, execsuperc){
						return $Class.inherit(this, extendMembers, execsuperc);
					};
				}
				
				if (config.useMixin) {
					_constructor.$mixin = function(protos){
						return $Class.include(this, protos);
					};
				}

				return _constructor;
			},
			/**
			 * 原型成员扩展.
			 *
			 * @param {Function(Class)} target 需要被原型拓展的类
			 * @param {Object|Array} [protos] 定义原型成员的对象或多个原型对象的数组
			 * @return {Function(Class)} 返回被拓展的类
			 * @doc
			 */
			include:function(target, protos){
				if (!isFun(target)) { target = function(){}; }
				if (isObj(protos)) {
					mix(target.prototype, protos);
				} else if (isArr(protos)) {
					for (var i = 0; i<protos.length; i++) {
						if (isObj(protos[i])) {
							mix(target.prototype, protos[i]);
						}
					}
				}
				return target;
			},
			/**
			 * 创建一个单例类   无论怎么实例化只有一个实例存在
			 *       此单例类与常用{}作为单例的区别：
			 *       有前者是标准function类，需要实例化，可以拓展原型，可以继承
			 *
			 * @param {Object} members 定义单例类成员的对象 
			 * @return {Object} singletonClass 单例类
			 * @doc
			 */
			singleton:function(members){
				var singletonClass;
				var _constructor = members[config.constructorName] || function(){};
				var newMembers = {};
				newMembers[config.constructorName] = function(){
					_constructor.apply(this, arguments);
					if (singletonClass.$instance instanceof singletonClass) {
						return singletonClass.$instance;
					} else {
						return singletonClass.$instance = this;
					}
				};
				return singletonClass = $Class.create(mix(members||{}, newMembers));
			},
			/**
			 * 克隆对象.
			 *
			 * @param {Object} o 需要克隆的对象
			 * @return {Object} 返回克隆后的对象
			 * @doc
			 */
			clone:clone,
			/**
			 * 获取某个类的成员 会从原型链上遍历获取.
			 *
			 * @param {Object} clas 类
			 * @return {Array} 返回该类整个原型链上的成员
			 * @doc
			 */
			member:function(clas){
				if (!isFun(clas)) return;
				var member = [];
				var m = {constructor:1};
				for (var chain = clas.prototype; chain && chain.constructor; chain = chain.constructor.prototype) {
					for (var k in chain) {
						m[k] = 1;
					}
					if (chain.constructor==clas || chain.constructor==Object) {
						//链为循环 或者 链到达Object 结束
						//不在Object原型上去循环了Object.prototype.constructor == Object
						break;
					}
				};
				for (var i in m) {
					member.push(i);
				}
				return member;
			},
			/**
			 * 混杂
			 *
			 * @param {Object} r 被混杂的Object
			 * @param {Object} s 参入的Object
			 * @return {Object} r 被混杂的Object
			 * @doc
			 */
			mix:mix
		};

		// Base
		// 所有$Class.create的类Foo都继承自$Class.Base     Foo <= Base <= Object
		// 因此你可以通过$Class.Base.prototype拓展所有create出来的类
		// 你也可以删除$Class.Base 或者 $Class.Base = null 这样就可以改变继承为 Foo <= Object
		$Class.Base = $Class.inherit(Object);

		if (host) {
			host.$Class = $Class;
		}

		return $Class;
		

	}));


/***/ },

/***/ 82:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	module.exports = __webpack_require__(83)


/***/ },

/***/ 83:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	module.exports = __webpack_require__(84);
	__webpack_require__(86);
	__webpack_require__(87);
	__webpack_require__(88);
	__webpack_require__(89);


/***/ },

/***/ 84:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var asap = __webpack_require__(85);

	function noop() {}

	// States:
	//
	// 0 - pending
	// 1 - fulfilled with _value
	// 2 - rejected with _value
	// 3 - adopted the state of another promise, _value
	//
	// once the state is no longer pending (0) it is immutable

	// All `_` prefixed properties will be reduced to `_{random number}`
	// at build time to obfuscate them and discourage their use.
	// We don't use symbols or Object.defineProperty to fully hide them
	// because the performance isn't good enough.


	// to avoid using try/catch inside critical functions, we
	// extract them to here.
	var LAST_ERROR = null;
	var IS_ERROR = {};
	function getThen(obj) {
	  try {
	    return obj.then;
	  } catch (ex) {
	    LAST_ERROR = ex;
	    return IS_ERROR;
	  }
	}

	function tryCallOne(fn, a) {
	  try {
	    return fn(a);
	  } catch (ex) {
	    LAST_ERROR = ex;
	    return IS_ERROR;
	  }
	}
	function tryCallTwo(fn, a, b) {
	  try {
	    fn(a, b);
	  } catch (ex) {
	    LAST_ERROR = ex;
	    return IS_ERROR;
	  }
	}

	module.exports = Promise;

	function Promise(fn) {
	  if (typeof this !== 'object') {
	    throw new TypeError('Promises must be constructed via new');
	  }
	  if (typeof fn !== 'function') {
	    throw new TypeError('not a function');
	  }
	  this._32 = 0;
	  this._8 = null;
	  this._89 = [];
	  if (fn === noop) return;
	  doResolve(fn, this);
	}
	Promise._83 = noop;

	Promise.prototype.then = function(onFulfilled, onRejected) {
	  if (this.constructor !== Promise) {
	    return safeThen(this, onFulfilled, onRejected);
	  }
	  var res = new Promise(noop);
	  handle(this, new Handler(onFulfilled, onRejected, res));
	  return res;
	};

	function safeThen(self, onFulfilled, onRejected) {
	  return new self.constructor(function (resolve, reject) {
	    var res = new Promise(noop);
	    res.then(resolve, reject);
	    handle(self, new Handler(onFulfilled, onRejected, res));
	  });
	};
	function handle(self, deferred) {
	  while (self._32 === 3) {
	    self = self._8;
	  }
	  if (self._32 === 0) {
	    self._89.push(deferred);
	    return;
	  }
	  asap(function() {
	    var cb = self._32 === 1 ? deferred.onFulfilled : deferred.onRejected;
	    if (cb === null) {
	      if (self._32 === 1) {
	        resolve(deferred.promise, self._8);
	      } else {
	        reject(deferred.promise, self._8);
	      }
	      return;
	    }
	    var ret = tryCallOne(cb, self._8);
	    if (ret === IS_ERROR) {
	      reject(deferred.promise, LAST_ERROR);
	    } else {
	      resolve(deferred.promise, ret);
	    }
	  });
	}
	function resolve(self, newValue) {
	  // Promise Resolution Procedure: https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
	  if (newValue === self) {
	    return reject(
	      self,
	      new TypeError('A promise cannot be resolved with itself.')
	    );
	  }
	  if (
	    newValue &&
	    (typeof newValue === 'object' || typeof newValue === 'function')
	  ) {
	    var then = getThen(newValue);
	    if (then === IS_ERROR) {
	      return reject(self, LAST_ERROR);
	    }
	    if (
	      then === self.then &&
	      newValue instanceof Promise
	    ) {
	      self._32 = 3;
	      self._8 = newValue;
	      finale(self);
	      return;
	    } else if (typeof then === 'function') {
	      doResolve(then.bind(newValue), self);
	      return;
	    }
	  }
	  self._32 = 1;
	  self._8 = newValue;
	  finale(self);
	}

	function reject(self, newValue) {
	  self._32 = 2;
	  self._8 = newValue;
	  finale(self);
	}
	function finale(self) {
	  for (var i = 0; i < self._89.length; i++) {
	    handle(self, self._89[i]);
	  }
	  self._89 = null;
	}

	function Handler(onFulfilled, onRejected, promise){
	  this.onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : null;
	  this.onRejected = typeof onRejected === 'function' ? onRejected : null;
	  this.promise = promise;
	}

	/**
	 * Take a potentially misbehaving resolver function and make sure
	 * onFulfilled and onRejected are only called once.
	 *
	 * Makes no guarantees about asynchrony.
	 */
	function doResolve(fn, promise) {
	  var done = false;
	  var res = tryCallTwo(fn, function (value) {
	    if (done) return;
	    done = true;
	    resolve(promise, value);
	  }, function (reason) {
	    if (done) return;
	    done = true;
	    reject(promise, reason);
	  })
	  if (!done && res === IS_ERROR) {
	    done = true;
	    reject(promise, LAST_ERROR);
	  }
	}


/***/ },

/***/ 85:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {"use strict";

	// Use the fastest means possible to execute a task in its own turn, with
	// priority over other events including IO, animation, reflow, and redraw
	// events in browsers.
	//
	// An exception thrown by a task will permanently interrupt the processing of
	// subsequent tasks. The higher level `asap` function ensures that if an
	// exception is thrown by a task, that the task queue will continue flushing as
	// soon as possible, but if you use `rawAsap` directly, you are responsible to
	// either ensure that no exceptions are thrown from your task, or to manually
	// call `rawAsap.requestFlush` if an exception is thrown.
	module.exports = rawAsap;
	function rawAsap(task) {
	    if (!queue.length) {
	        requestFlush();
	        flushing = true;
	    }
	    // Equivalent to push, but avoids a function call.
	    queue[queue.length] = task;
	}

	var queue = [];
	// Once a flush has been requested, no further calls to `requestFlush` are
	// necessary until the next `flush` completes.
	var flushing = false;
	// `requestFlush` is an implementation-specific method that attempts to kick
	// off a `flush` event as quickly as possible. `flush` will attempt to exhaust
	// the event queue before yielding to the browser's own event loop.
	var requestFlush;
	// The position of the next task to execute in the task queue. This is
	// preserved between calls to `flush` so that it can be resumed if
	// a task throws an exception.
	var index = 0;
	// If a task schedules additional tasks recursively, the task queue can grow
	// unbounded. To prevent memory exhaustion, the task queue will periodically
	// truncate already-completed tasks.
	var capacity = 1024;

	// The flush function processes all tasks that have been scheduled with
	// `rawAsap` unless and until one of those tasks throws an exception.
	// If a task throws an exception, `flush` ensures that its state will remain
	// consistent and will resume where it left off when called again.
	// However, `flush` does not make any arrangements to be called again if an
	// exception is thrown.
	function flush() {
	    while (index < queue.length) {
	        var currentIndex = index;
	        // Advance the index before calling the task. This ensures that we will
	        // begin flushing on the next task the task throws an error.
	        index = index + 1;
	        queue[currentIndex].call();
	        // Prevent leaking memory for long chains of recursive calls to `asap`.
	        // If we call `asap` within tasks scheduled by `asap`, the queue will
	        // grow, but to avoid an O(n) walk for every task we execute, we don't
	        // shift tasks off the queue after they have been executed.
	        // Instead, we periodically shift 1024 tasks off the queue.
	        if (index > capacity) {
	            // Manually shift all values starting at the index back to the
	            // beginning of the queue.
	            for (var scan = 0, newLength = queue.length - index; scan < newLength; scan++) {
	                queue[scan] = queue[scan + index];
	            }
	            queue.length -= index;
	            index = 0;
	        }
	    }
	    queue.length = 0;
	    index = 0;
	    flushing = false;
	}

	// `requestFlush` is implemented using a strategy based on data collected from
	// every available SauceLabs Selenium web driver worker at time of writing.
	// https://docs.google.com/spreadsheets/d/1mG-5UYGup5qxGdEMWkhP6BWCz053NUb2E1QoUTU16uA/edit#gid=783724593

	// Safari 6 and 6.1 for desktop, iPad, and iPhone are the only browsers that
	// have WebKitMutationObserver but not un-prefixed MutationObserver.
	// Must use `global` instead of `window` to work in both frames and web
	// workers. `global` is a provision of Browserify, Mr, Mrs, or Mop.
	var BrowserMutationObserver = global.MutationObserver || global.WebKitMutationObserver;

	// MutationObservers are desirable because they have high priority and work
	// reliably everywhere they are implemented.
	// They are implemented in all modern browsers.
	//
	// - Android 4-4.3
	// - Chrome 26-34
	// - Firefox 14-29
	// - Internet Explorer 11
	// - iPad Safari 6-7.1
	// - iPhone Safari 7-7.1
	// - Safari 6-7
	if (typeof BrowserMutationObserver === "function") {
	    requestFlush = makeRequestCallFromMutationObserver(flush);

	// MessageChannels are desirable because they give direct access to the HTML
	// task queue, are implemented in Internet Explorer 10, Safari 5.0-1, and Opera
	// 11-12, and in web workers in many engines.
	// Although message channels yield to any queued rendering and IO tasks, they
	// would be better than imposing the 4ms delay of timers.
	// However, they do not work reliably in Internet Explorer or Safari.

	// Internet Explorer 10 is the only browser that has setImmediate but does
	// not have MutationObservers.
	// Although setImmediate yields to the browser's renderer, it would be
	// preferrable to falling back to setTimeout since it does not have
	// the minimum 4ms penalty.
	// Unfortunately there appears to be a bug in Internet Explorer 10 Mobile (and
	// Desktop to a lesser extent) that renders both setImmediate and
	// MessageChannel useless for the purposes of ASAP.
	// https://github.com/kriskowal/q/issues/396

	// Timers are implemented universally.
	// We fall back to timers in workers in most engines, and in foreground
	// contexts in the following browsers.
	// However, note that even this simple case requires nuances to operate in a
	// broad spectrum of browsers.
	//
	// - Firefox 3-13
	// - Internet Explorer 6-9
	// - iPad Safari 4.3
	// - Lynx 2.8.7
	} else {
	    requestFlush = makeRequestCallFromTimer(flush);
	}

	// `requestFlush` requests that the high priority event queue be flushed as
	// soon as possible.
	// This is useful to prevent an error thrown in a task from stalling the event
	// queue if the exception handled by Node.js’s
	// `process.on("uncaughtException")` or by a domain.
	rawAsap.requestFlush = requestFlush;

	// To request a high priority event, we induce a mutation observer by toggling
	// the text of a text node between "1" and "-1".
	function makeRequestCallFromMutationObserver(callback) {
	    var toggle = 1;
	    var observer = new BrowserMutationObserver(callback);
	    var node = document.createTextNode("");
	    observer.observe(node, {characterData: true});
	    return function requestCall() {
	        toggle = -toggle;
	        node.data = toggle;
	    };
	}

	// The message channel technique was discovered by Malte Ubl and was the
	// original foundation for this library.
	// http://www.nonblocking.io/2011/06/windownexttick.html

	// Safari 6.0.5 (at least) intermittently fails to create message ports on a
	// page's first load. Thankfully, this version of Safari supports
	// MutationObservers, so we don't need to fall back in that case.

	// function makeRequestCallFromMessageChannel(callback) {
	//     var channel = new MessageChannel();
	//     channel.port1.onmessage = callback;
	//     return function requestCall() {
	//         channel.port2.postMessage(0);
	//     };
	// }

	// For reasons explained above, we are also unable to use `setImmediate`
	// under any circumstances.
	// Even if we were, there is another bug in Internet Explorer 10.
	// It is not sufficient to assign `setImmediate` to `requestFlush` because
	// `setImmediate` must be called *by name* and therefore must be wrapped in a
	// closure.
	// Never forget.

	// function makeRequestCallFromSetImmediate(callback) {
	//     return function requestCall() {
	//         setImmediate(callback);
	//     };
	// }

	// Safari 6.0 has a problem where timers will get lost while the user is
	// scrolling. This problem does not impact ASAP because Safari 6.0 supports
	// mutation observers, so that implementation is used instead.
	// However, if we ever elect to use timers in Safari, the prevalent work-around
	// is to add a scroll event listener that calls for a flush.

	// `setTimeout` does not call the passed callback if the delay is less than
	// approximately 7 in web workers in Firefox 8 through 18, and sometimes not
	// even then.

	function makeRequestCallFromTimer(callback) {
	    return function requestCall() {
	        // We dispatch a timeout with a specified delay of 0 for engines that
	        // can reliably accommodate that request. This will usually be snapped
	        // to a 4 milisecond delay, but once we're flushing, there's no delay
	        // between events.
	        var timeoutHandle = setTimeout(handleTimer, 0);
	        // However, since this timer gets frequently dropped in Firefox
	        // workers, we enlist an interval handle that will try to fire
	        // an event 20 times per second until it succeeds.
	        var intervalHandle = setInterval(handleTimer, 50);

	        function handleTimer() {
	            // Whichever timer succeeds will cancel both timers and
	            // execute the callback.
	            clearTimeout(timeoutHandle);
	            clearInterval(intervalHandle);
	            callback();
	        }
	    };
	}

	// This is for `asap.js` only.
	// Its name will be periodically randomized to break any code that depends on
	// its existence.
	rawAsap.makeRequestCallFromTimer = makeRequestCallFromTimer;

	// ASAP was originally a nextTick shim included in Q. This was factored out
	// into this ASAP package. It was later adapted to RSVP which made further
	// amendments. These decisions, particularly to marginalize MessageChannel and
	// to capture the MutationObserver implementation in a closure, were integrated
	// back into ASAP proper.
	// https://github.com/tildeio/rsvp.js/blob/cddf7232546a9cf858524b75cde6f9edf72620a7/lib/rsvp/asap.js

	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },

/***/ 86:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var Promise = __webpack_require__(84);

	module.exports = Promise;
	Promise.prototype.done = function (onFulfilled, onRejected) {
	  var self = arguments.length ? this.then.apply(this, arguments) : this;
	  self.then(null, function (err) {
	    setTimeout(function () {
	      throw err;
	    }, 0);
	  });
	};


/***/ },

/***/ 87:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	var Promise = __webpack_require__(84);

	module.exports = Promise;
	Promise.prototype['finally'] = function (f) {
	  return this.then(function (value) {
	    return Promise.resolve(f()).then(function () {
	      return value;
	    });
	  }, function (err) {
	    return Promise.resolve(f()).then(function () {
	      throw err;
	    });
	  });
	};


/***/ },

/***/ 88:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	//This file contains the ES6 extensions to the core Promises/A+ API

	var Promise = __webpack_require__(84);
	var asap = __webpack_require__(85);

	module.exports = Promise;

	/* Static Functions */

	var TRUE = valuePromise(true);
	var FALSE = valuePromise(false);
	var NULL = valuePromise(null);
	var UNDEFINED = valuePromise(undefined);
	var ZERO = valuePromise(0);
	var EMPTYSTRING = valuePromise('');

	function valuePromise(value) {
	  var p = new Promise(Promise._83);
	  p._32 = 1;
	  p._8 = value;
	  return p;
	}
	Promise.resolve = function (value) {
	  if (value instanceof Promise) return value;

	  if (value === null) return NULL;
	  if (value === undefined) return UNDEFINED;
	  if (value === true) return TRUE;
	  if (value === false) return FALSE;
	  if (value === 0) return ZERO;
	  if (value === '') return EMPTYSTRING;

	  if (typeof value === 'object' || typeof value === 'function') {
	    try {
	      var then = value.then;
	      if (typeof then === 'function') {
	        return new Promise(then.bind(value));
	      }
	    } catch (ex) {
	      return new Promise(function (resolve, reject) {
	        reject(ex);
	      });
	    }
	  }
	  return valuePromise(value);
	};

	Promise.all = function (arr) {
	  var args = Array.prototype.slice.call(arr);

	  return new Promise(function (resolve, reject) {
	    if (args.length === 0) return resolve([]);
	    var remaining = args.length;
	    function res(i, val) {
	      if (val && (typeof val === 'object' || typeof val === 'function')) {
	        if (val instanceof Promise && val.then === Promise.prototype.then) {
	          while (val._32 === 3) {
	            val = val._8;
	          }
	          if (val._32 === 1) return res(i, val._8);
	          if (val._32 === 2) reject(val._8);
	          val.then(function (val) {
	            res(i, val);
	          }, reject);
	          return;
	        } else {
	          var then = val.then;
	          if (typeof then === 'function') {
	            var p = new Promise(then.bind(val));
	            p.then(function (val) {
	              res(i, val);
	            }, reject);
	            return;
	          }
	        }
	      }
	      args[i] = val;
	      if (--remaining === 0) {
	        resolve(args);
	      }
	    }
	    for (var i = 0; i < args.length; i++) {
	      res(i, args[i]);
	    }
	  });
	};

	Promise.reject = function (value) {
	  return new Promise(function (resolve, reject) {
	    reject(value);
	  });
	};

	Promise.race = function (values) {
	  return new Promise(function (resolve, reject) {
	    values.forEach(function(value){
	      Promise.resolve(value).then(resolve, reject);
	    });
	  });
	};

	/* Prototype Methods */

	Promise.prototype['catch'] = function (onRejected) {
	  return this.then(null, onRejected);
	};


/***/ },

/***/ 89:
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	// This file contains then/promise specific extensions that are only useful
	// for node.js interop

	var Promise = __webpack_require__(84);
	var asap = __webpack_require__(90);

	module.exports = Promise;

	/* Static Functions */

	Promise.denodeify = function (fn, argumentCount) {
	  argumentCount = argumentCount || Infinity;
	  return function () {
	    var self = this;
	    var args = Array.prototype.slice.call(arguments);
	    return new Promise(function (resolve, reject) {
	      while (args.length && args.length > argumentCount) {
	        args.pop();
	      }
	      args.push(function (err, res) {
	        if (err) reject(err);
	        else resolve(res);
	      })
	      var res = fn.apply(self, args);
	      if (res &&
	        (
	          typeof res === 'object' ||
	          typeof res === 'function'
	        ) &&
	        typeof res.then === 'function'
	      ) {
	        resolve(res);
	      }
	    })
	  }
	}
	Promise.nodeify = function (fn) {
	  return function () {
	    var args = Array.prototype.slice.call(arguments);
	    var callback =
	      typeof args[args.length - 1] === 'function' ? args.pop() : null;
	    var ctx = this;
	    try {
	      return fn.apply(this, arguments).nodeify(callback, ctx);
	    } catch (ex) {
	      if (callback === null || typeof callback == 'undefined') {
	        return new Promise(function (resolve, reject) {
	          reject(ex);
	        });
	      } else {
	        asap(function () {
	          callback.call(ctx, ex);
	        })
	      }
	    }
	  }
	}

	Promise.prototype.nodeify = function (callback, ctx) {
	  if (typeof callback != 'function') return this;

	  this.then(function (value) {
	    asap(function () {
	      callback.call(ctx, null, value);
	    });
	  }, function (err) {
	    asap(function () {
	      callback.call(ctx, err);
	    });
	  });
	}


/***/ },

/***/ 90:
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	// rawAsap provides everything we need except exception management.
	var rawAsap = __webpack_require__(85);
	// RawTasks are recycled to reduce GC churn.
	var freeTasks = [];
	// We queue errors to ensure they are thrown in right order (FIFO).
	// Array-as-queue is good enough here, since we are just dealing with exceptions.
	var pendingErrors = [];
	var requestErrorThrow = rawAsap.makeRequestCallFromTimer(throwFirstError);

	function throwFirstError() {
	    if (pendingErrors.length) {
	        throw pendingErrors.shift();
	    }
	}

	/**
	 * Calls a task as soon as possible after returning, in its own event, with priority
	 * over other events like animation, reflow, and repaint. An error thrown from an
	 * event will not interrupt, nor even substantially slow down the processing of
	 * other events, but will be rather postponed to a lower priority event.
	 * @param {{call}} task A callable object, typically a function that takes no
	 * arguments.
	 */
	module.exports = asap;
	function asap(task) {
	    var rawTask;
	    if (freeTasks.length) {
	        rawTask = freeTasks.pop();
	    } else {
	        rawTask = new RawTask();
	    }
	    rawTask.task = task;
	    rawAsap(rawTask);
	}

	// We wrap tasks with recyclable task objects.  A task object implements
	// `call`, just like a function.
	function RawTask() {
	    this.task = null;
	}

	// The sole purpose of wrapping the task is to catch the exception and recycle
	// the task object after its single use.
	RawTask.prototype.call = function () {
	    try {
	        this.task.call();
	    } catch (error) {
	        if (asap.onerror) {
	            // This hook exists purely for testing purposes.
	            // Its name will be periodically randomized to break any code that
	            // depends on its existence.
	            asap.onerror(error);
	        } else {
	            // In a web browser, exceptions are not fatal. However, to avoid
	            // slowing down the queue of pending tasks, we rethrow the error in a
	            // lower priority turn.
	            pendingErrors.push(error);
	            requestErrorThrow();
	        }
	    } finally {
	        this.task = null;
	        freeTasks[freeTasks.length] = this;
	    }
	};


/***/ },

/***/ 91:
/***/ function(module, exports, __webpack_require__) {

	(function(root, factory) {

	  if (true) {
	    if (typeof module !== 'undefined' && module.exports) {
	      exports = module.exports = factory(root, exports);
	    }
	  } else if (typeof define === 'function' && define.amd) {
	    define(['exports'], function(exports) {
	      root.Lockr = factory(root, exports);
	    });
	  } else {
	    root.Lockr = factory(root, {});
	  }

	}(this, function(root, Lockr) {
	  'use strict';

	  if (!Array.prototype.indexOf) {
	    Array.prototype.indexOf = function(elt /*, from*/)
	    {
	      var len = this.length >>> 0;

	      var from = Number(arguments[1]) || 0;
	      from = (from < 0)
	      ? Math.ceil(from)
	      : Math.floor(from);
	      if (from < 0)
	        from += len;

	      for (; from < len; from++)
	      {
	        if (from in this &&
	            this[from] === elt)
	          return from;
	      }
	      return -1;
	    };
	  }

	  Lockr.prefix = "";

	  Lockr._getPrefixedKey = function(key, options) {
	    options = options || {};

	    if (options.noPrefix) {
	      return key;
	    } else {
	      return this.prefix + key;
	    }

	  };

	  Lockr.set = function (key, value, options) {
	    var query_key = this._getPrefixedKey(key, options);

	    try {
	      localStorage.setItem(query_key, JSON.stringify({"data": value}));
	    } catch (e) {
	      if (console) console.warn("Lockr didn't successfully save the '{"+ key +": "+ value +"}' pair, because the localStorage is full.");
	    }
	  };

	  Lockr.get = function (key, missing, options) {
	    var query_key = this._getPrefixedKey(key, options),
	        value;

	    try {
	      value = JSON.parse(localStorage.getItem(query_key));
	    } catch (e) {
	      value = null;
	    }
	    if(value === null)
	      return missing;
	    else
	      return (value.data || missing);
	  };

	  Lockr.sadd = function(key, value, options) {
	    var query_key = this._getPrefixedKey(key, options),
	        json;

	    var values = Lockr.smembers(key);

	    if (values.indexOf(value) > -1) {
	      return null;
	    }

	    try {
	      values.push(value);
	      json = JSON.stringify({"data": values});
	      localStorage.setItem(query_key, json);
	    } catch (e) {
	      console.log(e);
	      if (console) console.warn("Lockr didn't successfully add the "+ value +" to "+ key +" set, because the localStorage is full.");
	    }
	  };

	  Lockr.smembers = function(key, options) {
	    var query_key = this._getPrefixedKey(key, options),
	        value;

	    try {
	      value = JSON.parse(localStorage.getItem(query_key));
	    } catch (e) {
	      value = null;
	    }

	    if (value === null)
	      return [];
	    else
	      return (value.data || []);
	  };

	  Lockr.sismember = function(key, value, options) {
	    var query_key = this._getPrefixedKey(key, options);

	    return Lockr.smembers(key).indexOf(value) > -1;
	  };

	  Lockr.getAll = function () {
	    var keys = Object.keys(localStorage);

	    return keys.map(function (key) {
	      return Lockr.get(key);
	    });
	  };

	  Lockr.srem = function(key, value, options) {
	    var query_key = this._getPrefixedKey(key, options),
	        json,
	        index;

	    var values = Lockr.smembers(key, value);

	    index = values.indexOf(value);

	    if (index > -1)
	      values.splice(index, 1);

	    json = JSON.stringify({"data": values});

	    try {
	      localStorage.setItem(query_key, json);
	    } catch (e) {
	      if (console) console.warn("Lockr couldn't remove the "+ value +" from the set "+ key);
	    }
	  };

	  Lockr.rm =  function (key) {
	    localStorage.removeItem(key);
	  };

	  Lockr.flush = function () {
	    localStorage.clear();
	  };
	  return Lockr;

	}));

/***/ },

/***/ 92:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {var config = __webpack_require__(66);
	var util = __webpack_require__(93);
	var Promise = __webpack_require__(82);

	module.exports = {
		config: function() {
			return new Promise(function(resolve, reject) {
				var nonceStr = util.uuid();
				var timestamp = +new Date();
				var url = location.href.split('#')[0];

				$.ajax({
					type: 'GET',
					url: '/service/token/sign_jsapi/',
					data: {
						timestamp: timestamp,
						noncestr: nonceStr,
						url: url
					},
					dataType: 'json',
					success: function(data) {
						wx.config({
							// debug: true,
							appId: config.wxAppId,
							timestamp: timestamp,
							nonceStr: nonceStr,
							signature: data.signature,
							jsApiList: ['chooseImage', 'previewImage', 'uploadImage', 'downloadImage']
						});
						resolve();
						// wx.ready(function() {
						// });
					},
					error: function() {
						reject();
					}
				});
			});
				
		}
	};
	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(2)))

/***/ },

/***/ 93:
/***/ function(module, exports, __webpack_require__) {

	var uuid = 1;

	module.exports = {
		uuid:function(prefix){
			return (prefix||"") + (+new Date()).toString( 32 ) + (uuid++).toString( 32 );
		}	
	}

/***/ },

/***/ 94:
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(68)(".input-row .icon{width:50px;height:50px;margin:3px;font-size:24px;line-height:50px;text-align:center;background-color:#fff;border:1px solid #ddd;border-radius:25px}.input-row.avatar-row{height:150px;text-align:center}.avatar-row .uploadItem{margin-top:35px;opacity:.7}");
	var __vue_template__ = "<div class=\"input-row avatar-row {{cls}}\">\t\t\t\t\t\n\t\t<div class=\"uploadItem\">\n\t\t\t<span class=\"icon icon-plus\"></span>\n\t\t\t<p>{{title}}</p>\n\t\t</div>\n\t</div>";
	var BaseComponent = __webpack_require__(71);
		var Vue = __webpack_require__(3);

		var View = BaseComponent.extend({
			title: 'picupload',			
			created: function() {			
			},		
		});

		module.exports = View;

		Vue.component('view/picUpload', View);
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;


/***/ }

});