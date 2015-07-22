webpackJsonp([13],{

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

/***/ 87:
/***/ function(module, exports, __webpack_require__) {

	__webpack_require__(71)(".header{text-align:center;margin-top:20px;margin-bottom:20px}");
	var __vue_template__ = "<div v-show=\"part1\">\n\t<h4 class=\"header\">服务标准</h4>\n\t<p>1. 接单服务标准<br><br>\n1.1 登入软件开始接单，接单时看清楚需要服务的城市，产品类型，日期，时间，客户基本信息在接单。<br><br>\n1.2 接单后不允许退单的情况（除非有不可抗力的因素，如汽车被撞，身体不舒服，需要提供相关的文件证明）方可。<br><br>\n1.3 成功中标后，最晚在客户出发前3天（紧急订单保持实时联系），添加客户微信或 者致电，提前与客户保持联系。<br><br>\n1.4 认真查看客户信息，如果在接单后发现客户信息（如酒店地址不全，航班号待定）会造成接送客户存在困难的情况，请第一时间联系蜜柚司机端客服（微信：miutour_japan）。<br><br>\n2. 服务前订单服务标准<br><br>\n2.1认真查看客户是否有特殊需求（如需要婴儿座椅等）提前做好准备，检查车况确保车辆能够正常的运营。<br><br>\n2.2提前了解客户的酒店地址，景点路线，机场地址，做好大致的路线规划，做好上车地址的预估，避免不熟悉路况的情况发生。<br><br>\n2.3\t做好车内物料的放置（矿泉水，充电器，纸巾盒，接机牌），提前收拾好之前客户遗留的垃圾，保持车厢内清洁，无异味。<br><br>\n2.4根据天气情况，调整车厢内的温度，保持车内温度适宜。<br><br>\n2.5司机穿着正常，整洁，干净，普通用车订单尽量穿深色有领有袖，长裤。商务用车必须穿着正常，白色衬衫，深色西服，深色裤子和皮鞋。<br><br>\n3. 服务中（出车前）订单服务标准<br><br>\n3.1 接机：航班到达口迎接客户，举蜜柚接机牌，主动等待客户，客户出现时，主动上前拿行李，同时保证手机联系通畅。<br><br>\n   送机：在酒店大堂等待客户，带蜜柚接送证，协助办理退房并帮客户拿行李。<br><br>\n   包车：在酒店大堂或者约定好的地址等待客户，举起蜜柚牌耐心等待。<br><br>\n   如果在机场等待1个半小时，在酒店等待半个小时的情况，客户电话打不通，请第一时间联系蜜柚司导客服（电话：+86 181 1757 4508；微信：miutour_japan），客服同意后方可自行离开机场，并同时拍照取证。<br><br>\n3.2 客户上车后，主动问好并自我介绍，介绍车内的物品可以免费试用。提醒客户寄好安全带，和客户确定可以出发后，开始发车。<br><br>\n4. 服务中（出车中）订单服务标准<br><br>\n4.1 遵守交通规则，安全平稳行驶；严禁酒驾、吸烟，不随意接电话； 不可谈论公司、业务、收入、价格等相关问题； <br><br>\n4.2 认真解答客人关于旅游途中的相关问题(行程，景点，餐饮，酒店等)<br><br>\n4.3 包车订单：到达景点后先把客户放置到景点门口，司导停好车在于客户汇合。如果客户要求的停车地点不允许停车时，应该耐心与客户解释，取得客户的谅解。<br><br>\n4.4 包车订单：为客户进行对景点的简单讲解，对景点，风景，名胜古迹的讲解<br><br>\n5. 服务结束订单服务标准<br><br>\n5.1 接机：提醒乘客带好随身携带物品，主动帮助客人提行李到酒店大堂，帮助客户办理入住手续。<br><br>\n5.2 送机：帮助客人拿行李。<br><br>\n5.3 包车：服务结束后让客户等待于景点门口，自己先行开车接客户，下车时提醒客人带好随身携带物品，如果有行李帮助客户提至酒店。<br><br>\n5.4 礼貌道别，提醒客户可以对订单进行评价。如果在服务结束后对本次的服务中费用产品差异，请及时拨打司导客服端电话（电话：+86 181 1757 4508；微信：miutour_japan）进行处理。<br><br>\n二、车内物资基本配置<br><br>\n普通用车必备：<br><br>\n1. 饮用瓶装水 4瓶以上，按照实际的游客人数自行添加<br><br>\n2. 纸巾1盒<br><br>\n3. 雨伞2把<br><br>\n4. 接机牌1个<br><br>\n5. 车载多头充电线 1根<br><br>\n6. 垃圾袋4个 放置汽车靠背后侧<br><br>\n商务用车必备：<br><br>\n1. 饮用瓶装水 4瓶以上，按照实际的游客人数自行添加<br><br>\n2. 纸巾1盒<br><br>\n3. 雨伞2把<br><br>\n4. 接机牌1个<br><br>\n5. 车载多头充电线 1根<br><br>\n6. 垃圾袋4个 放置汽车靠背后侧<br><br>\n三、收费标准<br><br>\n1. 基础的服务费用如：油费，高速费，司导服务费，过路费，司导的餐补，入场料，住宿费，保险费均包含在我们的竞标价格中，在接单时按照自己的成本预估严格审核订单价格，谨慎接单。<br><br>\n2. 增值费用：如果客户在服务过程中，由于路线行程修改，涉及的费用增加，请第一时间联系司导客服进行协助，帮助客户在线做差额支付。<br><br>\n四、退订结算规则<br><br>\n1. 客户距离出行前48小时（含）免费退订，无结算金额<br><br>\n2. 客户在距离出行前48-24小时（含）退订订单，将订单金额的50%作为补偿给予结算<br><br>\n3. 客户在距离出行前24小时退订订单，将订单金额的100%的作为补偿给予结算</p><br><br>\n</div>\n<div v-show=\"part2\">\n\t<h4 class=\"header\">派单规则</h4>\n\t<p>收到订单：<br><br>\n客户通过蜜柚平台下单，订单通过蜜柚导游APP发布至大家的手机上<br><br>\n订单内容：<br><br>\n订单内容包括客户基础信息（姓名，手机号，微信号、出行人数等），接送地址、行程信息<br><br>\n发单时间：<br><br>\n常规订单是离出行前15天的订单每天早上8:00（北京时间）准时发单，紧急订单（出行前小于48小时）每天实时发单<br><br>\n提醒方式：<br><br>\n新订单以系统推送消息的方式进行推送提醒，司导可点击订单进行评估后竞标<br><br>\n订单流程：<br><br>\n常规订单司导在竞标后每晚20:00系统自动截标，成功中标的订单会以邮件方式和系统推送消息，司导需进入《确认订单》中点击确认<br><br>\n离出行前2天之内的紧急订单，按照第一个司导竞标后直接中标，同时需点击确认。&nbsp;1小时不点击确认的订单，将视为放弃，自动将开始第二轮发标<br><br>\n派单规则：<br><br>\n派单将按照价格+服务等级的系数进行系统估算，同价格竞标的司导按照服务等级的高低，将自动派发服务等级高司导</p><br><br>\n</div>\n<div v-show=\"part3\">\n\t<h4 class=\"header\">评级规则</h4>\n\t<p>\n规则：<br><br>\n1. 考试评级：<br><br>\n初级考试--接送机及点对点接送用车<br><br>\n二级考试—其他所有订单类型<br><br>\n2. 接单服务评级：<br><br>\n通过考试后皆为70分<br><br>\n通过服务累加记分：好评+0.5/单<br><br>\n3. 活跃度评级<br><br>\n通过竞标及接单提升活跃度，竞标+0.05/单，接单服务+0.1/单<br><br>\n   在此基础之上，我们拥有一套公平合理的算法，使得积极竞标、完善服务的人们获得更多、更优质的订单</p><br><br>\n</div>\n<div v-show=\"part4\">\n\t<h4 class=\"header\">处罚规则</h4>\n\t<p>1. 一级违规处罚<br><br>\n1.1 车辆不整洁，车内物料不齐全<br><br>\n1.2 行前三天未提前联系客户，导致客户担忧<br><br>\n1.3 行驶过程中，频繁使用手机造成不安全驾驶<br><br>\n1.4 未提前了解订单信息（不购买午餐，不提供婴儿座椅）等情况<br><br>\n1.5 不按照要求举接机牌，不帮客户拿行李 <br><br>\n处罚办法：<br><br>\n1. 服务分数每发现一次，直接扣除1分，锁定账号7天不能体现<br><br>\n2. 按照订单金额的比列，扣除50%订单金额<br><br>\n3. 累计30天之内发生3次常规违规，直接沉默账号10天不能接单提现<br><br><br>\n2．二级违规处罚<br><br>\n2.1 推荐客户去不法商铺用餐，收收回扣<br><br>\n2.2 迟到并且引起客户投诉<br><br>\n2.3 提前未安排好路线，造成路线不熟悉，绕路等情况行车时间增加20分钟及以上<br><br>\n2.4 走错目的地，造成客户行程无法正常完成<br><br>\n2.5 商品不熟悉，额外收取客户费用<br><br>\n2.6 拒绝客户有理需求<br><br>\n处罚办法：<br><br>\n1. 服务分数每发现一次，直接扣除2分，锁定账号7天不能体现<br><br>\n2. 按照订单金额的比列，扣除100%订单金额<br><br>\n3. 累计30天之内发生2次常规违规，直接沉默账号15天不能接单提现<br><br><br>\n3 .三级违规处罚<br><br>\n3.1 酒驾<br><br>\n3.2 爽约<br><br>\n3.3 私自更换车辆（桥车/商务车/面包车）降级服务<br><br>\n3.4 暴露订单价格<br><br>\n3.5 没有安排指定服务（如：专职导游）<br><br>\n3.6 与乘客发生冲突<br><br>\n3.7 事后骚扰乘客<br><br>\n3.8 线下揽私活<br><br>\n处罚办法：<br><br>\n1. 服务分数没发现一次，直接扣除3分，锁定账号15天不可提现<br><br>\n2. 按照订单金额的比例，扣除200%订单金额<br><br>\n3. 累计15天发生2次违规，直接解除合作。</p>\n</div>\n\n<div v-show=\"part5\">\n\t<h4 class=\"header\">常见问题 </h4>\n\t<p>Q：提前联系客人未能接通<br>\n1.1 提前三天，截屏取证（电话呼出记录3次，微信等在线工具好友申请及发送文字记录截屏，须有明确日期时间，且须在联系未果后当天反馈至客服处（微信：miutour_japan），请予协助）<br><br>\n1.2 提前一天，截屏取证（同提前三天标准操作）<br><br>\n1.3 当天，按照订单信息及服务标准，准时到达接待地点，抵达后立即拍照取证（或APP签到），要求拍照具有明显时间地点标识（地点为酒店推荐在前台取景，画面中有司机本人、酒店名称及时间；地点为机场推荐在接机门取景，画面中包含司机本人、接机门号码全景及时间，时间信息以墙面挂钟等公众设施或该照片发送信息时间为准）<br><br>\n\nQ：披露信息错误/不全<br>\nA：截止至行前24小时仍未得到客人或蜜柚客服通知详细信息，严格按照订单披露信息标准执行，拍照取证（或APP签到），等待达到要求时间后默认完成服务，发送信息告知客服，订单金额按正常结算。 <br><br>\n\nQ：如何了解公司近期的奖励政策（含活动补贴、服务奖励等）？<br>\nA：导游端新闻活动。<br><br>\n\nQ：准时性如何证明：<br>\nA：请司导抵达后即刻拍照取证（或APP签到），以避免后续与客人产生纠纷无法为自己举证<br><br>\n\nQ：纠纷处理：<br>\nA：因各种原因客人在游玩过程中产生不良情绪后，司导当面进行解决安抚，客人接受后，为避免客人回国后反悔继续投诉，请客人在安抚获得接受后留字为据（可通过现场纸质书写签字或微信等信息发送获得客人回复同意），具体模板见下：<br><br>\n\n尊敬的游客：<br><br>\n你好！<br><br>\n因特殊情况造成游客：            一行的游玩受损，现特提出给予如下解决方案<br><br>\n1.      <br><br>                    \n2.       <br><br>                   \n3.         <br><br>                \n请客人予以谅解，并献上本司诚挚的歉意<br><br>\n\n游客：             （签字）接受致歉方案<br><br>\n日期：     年    月    日<br><br>\n\n\n\nQ：如果服务过程中，游客要更改路线，该如何处理？<br>\nA：如果是包车订单，客户的路线更改不超过300KM，司导需要提供直接的服务，无需联系客服，按照客户的需求操作。如果路程超过300km，费用会有增加，需要第一时间联系司导客服进行在线协助下单，帮助客户在线支付。 <br><br>如果设计到商品变更你（接送机变为半日游+接送机）也需要第一时间司导客服，进行在线协助客户付款。<br><br>\n\nQ：如果在服务过程中，客人的行程和司导端的行程存在分歧，怎么办？<br>\nA：我们按照客户最大的理念为客户提供服务，并第一时间致电司导客服进行在线咨询，一起帮助客户解决难题。<br><br>\n\nQ：我们的订单服务结束后，多久可以收到服务款？<br>\nA：我们在服务结束后8天内，财务会把你之前的款项打到你的账户信息中填写的银行账户中。<br><br>\n\nQ：如果收到的款项有异议，怎么办？<br>\nA：如果你收到的款项存在差距，请联系司导客服进行咨询，3个工作日内会给到满意的答复。<br><br>\n\nQ：如果客户在出行前取消订单，那司导是否有补偿金？<br>\nA： 距离出行前48之前，无补偿金。24-48H 之间客户取消订单，补偿金为竞价金额40%, 24H之内取消订单，90%按照竞价金额支付。<br><br>\n\n\nQ：如果客户需要提供当地订餐的服务，但是又违约没有前往，违约金部分由谁承担？<br>\nA：有这种情况，客服会第一时间联系客户，让客户承担。如果客户不同意的情况下，有公司和司机共同对半承担。</p>\n</div>";
	var BasePage = __webpack_require__(72);
		var Vue = __webpack_require__(6);
		var nav = __webpack_require__(68);

		var View = BasePage.extend({
			title: '司导指南',
			data: function() {
				return {
					part1:0,
					part2:0,
					part3:0,
					part4:0,
					part5:0
				}
			},
			methods: {
				
			},
			resume: function(){
				this.$data.part1=this.getParam('c')  ==1;
				this.$data.part2=this.getParam('c')  ==2;
				this.$data.part3=this.getParam('c')  ==3;
				this.$data.part4=this.getParam('c')  ==4;
				this.$data.part5=this.getParam('c')  ==5;
			},
			pause: function(){

			},
			created: function() {			
			},		

		});

		module.exports = View;
	;(typeof module.exports === "function"? module.exports.options: module.exports).template = __vue_template__;


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