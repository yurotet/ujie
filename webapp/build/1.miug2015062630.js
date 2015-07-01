webpackJsonp([1],{

/***/ 70:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {__webpack_require__(71)(".userInfo .input-row input{width:65%;font-size:18px}.userInfo .input-row label{font-size:14px;color:#666}.userInfo select{margin-top:5px;width:65%;font-size:16px}.userInfo .input-row label.more{font-size:14px}");
	var __vue_template__ = "<div v-component=\"view/regSteps\" v-with=\"step:curStep\"></div>\n  <div class=\"userInfo\">\n  \t <form class=\"input-group\">\n  \t\t <div class=\"input-row\">\t\t\t\n\t\t\t<label>姓名</label>\t\n\t\t\t<input type=\"text\" v-on=\"input:onInputChange\" placeholder=\"真实姓名 (必填)\" v-model=\"user.realname\">\t\t\t\n\t\t</div>\n  \t \t<div class=\"input-row\">\t\n\t\t\t<label>性别</label>\n\t\t\t<select v-on=\"change:onInputChange\" options=\"sexList\" v-model=\"user.sex\"></select>\t\t\t\n\t\t</div>\n  \t\t<div class=\"input-row\">\t\n  \t\t\t<label>年龄</label>\n\t\t\t<input v-on=\"input:onInputChange\" type=\"number\" min=\"18\" max=\"60\" placeholder=\"年龄 (必填)\" v-model=\"user.age\">\n\t\t</div>\n\t\t\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>地址</label>\t\t\n\t\t\t<input v-on=\"input:onInputChange\" type=\"text\" placeholder=\"地址 (必填)\" v-model=\"user.address\">\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>手机</label>\t\n\t\t\t<input v-on=\"input:onInputChange\" type=\"text\" placeholder=\"手机 (必填)\" v-model=\"user.mobile\">\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>邮箱</label>\t\n\t\t\t<input v-on=\"input:onInputChange\" type=\"text\" placeholder=\"邮箱 (必填)\" v-model=\"user.mailBox\">\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>微信</label>\t\n\t\t\t<input v-on=\"input:onInputChange\" type=\"text\" placeholder=\"微信 (必填)\" v-model=\"user.wechat\">\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\n\t\t\t<label>国家</label>\n\t\t\t<select v-on=\"change:onInputChange\" options=\"countryList\" v-model=\"user.country\"></select>\t\n\t\t</div>\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>城市</label>\t\t\n\t\t\t<select v-on=\"change:onInputChange\" options=\"cityList\" v-model=\"user.city\"></select>\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>导游证</label>\t\t\n\t\t\t<select v-on=\"change:onInputChange\" options=\"yesnoList\" v-model=\"user.hasGuideCer\"></select>\t\n\t\t</div>\t\t\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label>驾龄</label>\t\t\n\t\t\t<select v-on=\"change:onInputChange\" options=\"yearRangeList\" v-model=\"user.drivingExp\"></select>\t\n\t\t</div>\n\n\t\t<div class=\"input-row\">\t\n\t\t\t<label class=\"more\">从业时间</label>\t\t\n\t\t\t<select v-on=\"change:onInputChange\" options=\"yearRangeList\" v-model=\"user.workingExp\"></select>\t\n\t\t</div>\t\t\t\n\t</form>\n</div>\n\n<button id=\"userInfoBtn\" class=\"btn btn-positive btn-block\" disabled=\"disabled\" v-on=\"click: onSubmit\">下一步, 上传认证照片</button>";
	var BasePage = __webpack_require__(72);	
		var Promise = __webpack_require__(91);
		var nav = __webpack_require__(68);
		var steps = __webpack_require__(77);
		var lockr = __webpack_require__(88);
		var util = __webpack_require__(89);

		var REG_STATUS= {		
			NOT_REGED:1,
			GOTO_APP:2,
			READY_FOR_REG:3
		};

		var View = BasePage.extend({
			title: '我的认证',
			watch: {
				    'user.country': function (val) {
				      	this.$data.cityList  = this.$data.allCityList[val];			      	
				      	this.$data.user.city= this.$data.cityList[0].value;
				    }
			  },
			data: function() {
				
				var sexList = [{
					value:'male',
					text: '男'
				},{
					value:'female',
					text:'女'}],

				yesnoList =[{
					value:'no',
					text: '无'
				},{
					value:'yes',
					text: '有'
				}],

				yearRangeList =[{
					value:'1-3',
					text: '1-3年'
				},{
					value:'3-5',
					text: '3-5年'
				},{
					value:'5+',
					text:'5年以上'
				}];
			
				var listToSave = util.flatten([sexList, yesnoList, yearRangeList]);
				lockr.set('infoTransList',listToSave );		

				return {
					curStep:4,	

					allCityList:{},
					countryList:[],
					cityList:[],
					
					sexList:sexList,
					yesnoList:yesnoList,
					yearRangeList:yearRangeList,
					
					user:{					
						sex:'male',
						hasGuideCer:'no',
						drivingExp:'1-3',
						workingExp:'1-3',
						city:'',
						age:'',
						realname:'',
						country:'',
						address:'',
						mobile:'',
						wechat:'',					
						mailBox:'',
					}		
				};
			},
			
			methods: { 			
				checkSubmitBtn:function(){					
					var disabled  = !this.$data.user.realname || !this.$data.user.age || !this.$data.user.mobile || !this.$data.user.mailBox || ! this.$data.user.wechat;						

					var btn  = $('#userInfoBtn');

					if (disabled) {
						btn.attr('disabled','disabled');
					} else {
						btn.removeAttr('disabled');
					}
				},

				onInputChange:function() {				
					var savedUser = lockr.get('user') || {};
					alert(JSON.stringify(this.$data.user));
					$(this.$data.user,function(key, val) {
						savedUser[key] = val;
					});

					lockr.set('user', savedUser);

					this.checkSubmitBtn();
				},
				
				_loadCountryInfo:function() {
					return new Promise(function(resolve, reject) {
						this.showLoading();
			  			$.ajax({
							  type:'GET',				  
							  url: '/api/tags', 				 
							  dataType: 'json',
							  timeout: 10000,
							  context: this,
							  success: function(res){  
							  	if(res.err_code==0){
							  		var countryList = [];
							  		$.each(res.data, function(key,val) {					  			
							  			countryList.push({
							  				value:key,
							  				text:val.name
							  			});					  			

							  			var cList = [];
							  			$.each(val.children,function(cKey,cVal) {
							  				cList.push({
							  					value:cKey,
							  					text:cVal
							  				});					  				
							  			});
							  									  			
							  			this.$data.allCityList[key] =cList;
							  		}.bind(this));

							  		// save value/text mappings for cities
							  		var cityTrans = [];
							  		$.each(this.$data.allCityList,function (key, value) {
							  			cityTrans = util.flatten([cityTrans, value]);
							  		})
							  		lockr.set('cityTransList', cityTrans);

							  		// save value/text mappings for countries
							  		lockr.set('countryTransList', countryList);


							  		this.$data.countryList = countryList;	
							  		this.$data.user.country = this.$data.countryList [0].value;
							  		resolve();			  		
							  	} else {					  		
							  		this.showToast(res.err_msg,true);
							  		reject();
							  	}
							    
							  },
							  complete:function() {
							  	this.hideLoading();					  	
							  },
							
							  error: function(xhr, type){
							   	reject();
							  }
						})	

					}.bind(this));
					
				},
						
				onSubmit: function() {
					lockr.set('isRegLegal',true);
					nav.goTo('picupdate');				
				},


				setHeader:function() {
					var selText = '.stepsContainer.index4 .step4' ;			

					var el = $(selText),
						ela=$(selText+' a'),
						eltext=$(selText+' .text');
					
					el.css('padding','3px');
			 		el.css('margin-top','0');
			 		
			 		ela.css('width','100px');
			  		ela.css('height','60px');
			 		ela.css('line-height','60px');
			  		ela.css('background-color','#77c2a5');

			  		eltext.css('display','inline-block');
			  		eltext.css('opacity','1');
				},

				initData:function() {
					$.each(lockr.get('user'), function(key,val) {					
						if (val != '') {
							this.$data.user[key]=val;
						}							
					}.bind(this));
					
					this.checkSubmitBtn();
				},

				_loadAuthStauts:function() {
					return new Promise(function(resolve, reject) {					
						this.showLoading(); 
						 $.ajax({   
						            type:'GET', 
						            url: '/api/info', 					          
						            dataType: 'json',
						            timeout: 10000,
						            context: this,
						            success: function(body){  					            	
						              if (body.err_code == 0 ) {	
						              resolve(REG_STATUS.READY_FOR_REG);			               	
						               	// switch (body.data.guide_auth) {
						               	// 	case '1': 	// 审核通过
						               	// 	case '3': 	// 审核失败
						               	// 	case '2':             // 审核中
						               	// 		resolve(REG_STATUS.GOTO_APP);
						               	// 	break;

						               	// 	case '0'	:	//待审核
						               	// 		resolve(REG_STATUS.READY_FOR_REG);
						               	// 	break;
						               	// 	default:
						               	// 		resolve(REG_STATUS.NOT_REGED);
						               	// 	break;					               		
						               	// }					               	

						              } else {	
						              	resolve(REG_STATUS.NOT_REGED);					                  
						              }                          
						            }.bind(this),
						            complete:function() {
						                          this.hideLoading();
						            },
						          
						            error: function(err){
						              reject();
						            }
						        }) 
						}.bind(this));
				},
				

				 checkRegStatus : function() {
				 	this._loadAuthStauts().then(function(statusCode){ 		
				 		switch (statusCode) {
				 			case  REG_STATUS.NOT_REGED: 	//  还没有通过微信账号注册过
				 				nav.goTo('newUser');
				 			break;
				 			case REG_STATUS.GOTO_APP: 		//账号已经通过认证了, 引导下载APP补全或者修改认证信息
				 				nav.goTo('downloadAPP');
				 			break;	
				 			case REG_STATUS.READY_FOR_REG:
				 				nav.goTo("register");
				 			break;
				 			default:			 				
				 				nav.goTo('notfound');
				 			break;
				 		}
				 	}).catch(function(err) {
				 		nav.goTo('notfound');
				 	});
				 }	
			},
			
			created: function() {
				lockr.set('isRegLegal', false);
				this._loadCountryInfo().then(this.initData);
			},

			resume: function() {
				this.setHeader();
				this.checkRegStatus();					
			},
			pause:function(){

			}			
		});

		module.exports = View;
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;

	/* WEBPACK VAR INJECTION */}.call(exports, __webpack_require__(2)))

/***/ },

/***/ 71:
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

/***/ 72:
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function($) {var nav = __webpack_require__(68);
	var Vue = __webpack_require__(6);
	var $Class = __webpack_require__(86);

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

		getParam :function (name) {
			var hash = window.location.hash;
			var cutIndex = hash.indexOf('?');
			
			if (cutIndex!= -1) {
				 var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)', 'i');
				    var r = hash.substr(cutIndex +1).match(reg);
				    if (r != null) {
				        return unescape(r[2]);
				    }
			}
			
			 return null;
		},

		 showToast:function(message,isError){
		 	if (!message) return;

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

/***/ 77:
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(71)("ul.breadcrumb{display:inline-block;list-style:none;margin:0}ul.breadcrumb li{float:right;padding:5px;background-color:#fff;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;position:relative;margin-left:-50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;margin-top:3px}ul.breadcrumb li a{overflow:hidden;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;text-decoration:none;height:50px;color:#509378;background-color:#65ba99;text-align:center;min-width:50px;display:block;line-height:50px;padding-left:52px;padding-right:33.33px;width:50px}ul.breadcrumb li a .icon{font-size:14px;display:inline-block}ul.breadcrumb li a .text{font-size:16px;font-weight:700;display:none;opacity:0}ul.breadcrumb li:last-child a{padding:0}.stepsContainer{text-align:center}");
	var __vue_template__ = "<div class=\"stepsContainer index{{step}}\">\n\t<ul class=\"breadcrumb\">\n\t  <li class=\"step1\"> \n\t    <a>\n\t      <span class=\"icon\">4</span>\n\t      <span class=\"text\">确认提交</span>\n\t    </a>\n\t  </li>\n\t  <li class=\"step2\"> \n\t    <a>\n\t      <span class=\"icon\">3</span>\n\t      <span class=\"text\">结算账户</span>\n\t    </a>\n\t  </li>\n\t  <li class=\"step3\">\n\t    <a>\n\t      <span class=\"icon\">2</span>\n\t      <span class=\"text\">认证照片</span>\n\t    </a>\n\t  </li>\t  \n\t  <li class=\"step4\">\n\t    <a>\n\t      <span class=\"icon\">1</span>\n\t       <span class=\"text\">我的资料</span>\n\t    </a>\n\t  </li>\n\t</ul>\t\n</div>";
	var BaseComponent = __webpack_require__(78);
		var Vue = __webpack_require__(6);


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

/***/ 78:
/***/ function(module, exports, __webpack_require__) {

	var Vue = __webpack_require__(6);
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

/***/ 86:
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

/***/ 88:
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

/***/ }

});