webpackJsonp([6],{

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
	var $Class = __webpack_require__(89);

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

/***/ 79:
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(71)(".cntContainer,.regHeader{text-align:center}.cntContainer h4{margin:15px 0}.cntContainer p{font-size:16px;margin:10px 10px 30px}");
	var __vue_template__ = "<div v-show=\"success\">\n\t\t<div class=\"regHeader\">\n\t\t\t<img src=\"finish.png\" alt=\"注册信息审核状态\">\n\t\t</div>\n\n\t\t<div class=\"cntContainer\">\t\t\n\t\t\t<h4>{{realname}}，您已成功通过审核！</h4>\n\t\t\t<p>下载蜜柚接单APP接可以开始接单了</p>\n\t\t\t<a href=\"http://m.miutour.com/qrcode/index.html\" class=\"btn btn-positive btn-block\">下载蜜柚接单APP</a>\n\t\t</div>\t\n\t\t\n\t</div>\n\n\t<div v-show=\"fail\">\n\t\t<div class=\"regHeader\">\n\t\t\t<img src=\"error.png\" alt=\"注册信息审核状态\">\n\t\t</div>\n\n\t\t<div class=\"cntContainer\">\t\t\n\t\t\t<h4>{{realname}}，您的注册信息还不完整</h4>\n\t\t\t<p>继续完善注册信息就可以重新提交审核了</p>\n\t\t\t<p>{{refuse_des}}</p>\n\t\t\t<button v-on=\"click:modify\" class=\"btn btn-positive btn-block\">完善注册信息</button>\n\t\t</div>\t\n\t</div>\n\n\t\n\t<div v-show=\"ing\">\n\t\t<div class=\"regHeader\">\n\t\t\t<img src=\"wait.png\" alt=\"注册信息审核状态\">\n\t\t</div>\n\n\t\t<div class=\"cntContainer\">\t\t\n\t\t\t<h4>{{realname}}，您的注册信息正在审核中</h4>\n\t\t\t<p>有审核结果了我们会第一时间通知您哦</p>\n\t\t</div>\t\t\t\n\t</div>";
	var BasePage = __webpack_require__(72);
		var Vue = __webpack_require__(6);
		var  lockr = __webpack_require__(81);
		var nav = __webpack_require__(68);


		var View = BasePage.extend({
			title: '下载APP',
			data: function() {
				var user = lockr.get('user'), realName;

				var realname = user? user.realname: '';
				var refuseDes = lockr.get('refuse_des') || '';

				return {
					realname:realname,
					refuse_des:refuseDes,	
					success:false,
					fail:false,
					ing:false			
				}
			},
			
			methods: {
				modify:function() {
					nav.goTo('register?s=true')
				}

			},
			created: function() {

			},
			resume:function() {
				var status = this.getParam('s');
				this.$data.success = status == 'success';
				this.$data.fail = status == 'fail';
				this.$data.ing = status == 'ing';			
			}
		});

		module.exports = View;
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;


/***/ },

/***/ 81:
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

/***/ 89:
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


/***/ }

});