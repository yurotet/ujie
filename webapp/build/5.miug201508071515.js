webpackJsonp([5],{68:function(t,e,n){var i={};t.exports=function(t,e){if(!i[t]){i[t]=!0;var n=document.createElement("style");n.setAttribute("type","text/css"),"textContent"in n?n.textContent=t:n.styleSheet.cssText=t;var r=document.getElementsByTagName("head")[0];e&&e.prepend?r.insertBefore(n,r.childNodes[0]):r.appendChild(n)}}},69:function(t,e,n){(function(e){var i=n(65),r=n(3),o=n(86),s=r.extend({});o.mix(s.prototype,{name:"BagePage",startMode:"newinstance",intervalCounter:0,startPage:function(t){i.goTo(t)},startPageForResult:function(t,e){},back:function(){i.back()},hideToast:function(){var t=document.getElementById("toast");t&&(t.style.opacity=0,t.style.display="none",clearInterval(this.intervalCounter))},getParam:function(t){var e=window.location.hash,n=e.indexOf("?");if(-1!=n){var i=new RegExp("(^|&)"+t+"=([^&]*)(&|$)","i"),r=e.substr(n+1).match(i);if(null!=r)return unescape(r[2])}return null},showToast:function(t,n){if(t){this.hideToast();var i=document.getElementById("toast");if(null==i){var r='<div id="toast">'+t+"</div>";document.body.insertAdjacentHTML("beforeEnd",r)}else e(i).text(t),i.style.display="block",i.style.opacity=.9;intervalCounter=setInterval(this.hideToast,n?2200:1300)}},showLoading:function(){e(".m-load2").css("display","block"),e(".js-loading").addClass("active"),setTimeout(this.hideLoading,1e4)},hideLoading:function(){e(".m-load2").css("display","none"),e(".js-loading").removeClass("active")}}),t.exports=s}).call(e,n(2))},73:function(t,e,n){(function(e){n(68)(".userInfo .input-row input{width:65%;font-size:18px}.userInfo .input-row label{font-size:14px;color:#aaa}.userInfo select{margin-top:5px;width:65%;font-size:16px}#accSubPreBtn{display:'inline-block';width:35%}");var i='<div v-component="view/regSteps" v-with="step:curStep"></div>\n  <div class="userInfo">\n  	 <form class="input-group">  		\n\n		<div class="input-row">	\n			<label class="more">结算方式</label>		\n			<select v-on="change:onInputChange" options="payTypeList" v-model="user.payType"></select>	\n		</div>\n\n		<div class="input-row" style="display:{{user.payType == \'alipay\'? \'block\':\'none\'}}">	\n			<label class="more">支付宝</label>	\n			<input v-on="input:onInputChange" type="text" placeholder="支付宝账号 (必填)" v-model="user.alipayAcc">	\n		</div>\n\n		<div class="input-row" style="display:{{user.payType == \'bank\'? \'block\': \'none\'}}">	\n			<label class="more">开户银行</label>	\n			<input v-on="input:onInputChange" type="text" placeholder="开户银行名称 (必填)" v-model="user.bankName">	\n		</div>\n\n		<div class="input-row" style="display:{{user.payType == \'bank\'? \'block\': \'none\'}}">	\n			<label class="more">账户名称</label>	\n			<input v-on="input:onInputChange" type="text" placeholder="账户名称 (必填)" v-model="user.accName">	\n		</div>\n\n		<div class="input-row" style="display:{{user.payType == \'bank\'? \'block\': \'none\'}}">	\n			<label class="more">银行卡号</label>	\n			<input v-on="input:onInputChange" type="text" placeholder="银行卡号 (必填)" v-model="user.cardNo">	\n		</div>\n\n		<div class="input-row" style="display:{{user.payType == \'paypal\'? \'block\': \'none\'}}">	\n			<label>Paypal</label>	\n			<input v-on="input:onInputChange" type="text" placeholder="Paypal账号 (必填)" v-model="user.paypalAcc">	\n		</div>			\n	</form>\n</div>\n\n<button id="accSubBtn" class="btn btn-positive btn-block" disabled="disabled" v-on="click: onSubmit">下一步</button>',r=n(69),o=n(65),s=(n(74),n(78)),a=(n(88),r.extend({title:"结算账户",data:function(){var t=[{value:"alipay",text:"支付宝 "},{value:"bank",text:"银行"},{value:"paypal",text:"paypal"}];return s.set("accTransList",t),{curStep:4,payTypeList:t,user:{payType:"alipay",alipayAcc:"",bankName:"",paypalAcc:"",cardNo:"",accName:""}}},methods:{checkSubmitBtn:function(){var t=!0;switch(this.$data.user.payType){case"alipay":t="alipay"==this.$data.user.payType&&!this.$data.user.alipayAcc;break;case"bank":t=!("bank"!=this.$data.user.payType||this.$data.user.bankName&&this.$data.user.cardNo&&this.$data.user.accName);break;case"paypal":t="paypal"==this.$data.user.payType&&!this.$data.user.paypalAcc}var n=e("#accSubBtn");t?n.attr("disabled","disabled"):n.removeAttr("disabled")},onInputChange:function(){s.set("user",this.$data.user),this.checkSubmitBtn()},onSubmit:function(){o.goTo("confirmSubmit")},onPre:function(){o.goTo("picupdate")},setHeader:function(){e(".stepInfo").text("填写结算账户信息")},initData:function(){e.each(s.get("user"),function(t,e){""!=e&&(this.$data.user[t]=e)}.bind(this)),setTimeout(this.checkSubmitBtn,0)}},created:function(){this.initData()},resume:function(){this.setHeader(),s.get("isRegLegal")||o.goTo("notfound")},pause:function(){}}));t.exports=a,("function"==typeof t.exports?t.exports.options:t.exports).template=i}).call(e,n(2))},74:function(t,e,n){n(68)("ul.breadcrumb{display:inline-block;list-style:none;margin:0}ul.breadcrumb li{float:right;padding:5px;background-color:#fff;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;position:relative;margin-left:-50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;margin-top:3px}ul.breadcrumb li a{overflow:hidden;-webkit-border-radius:50px;-moz-border-radius:50px;-ms-border-radius:50px;-o-border-radius:50px;border-radius:50px;-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s;text-decoration:none;height:50px;color:#509378;background-color:#65ba99;text-align:center;min-width:50px;display:block;line-height:50px;padding-left:52px;padding-right:33.33px;width:50px}ul.breadcrumb li a .icon{font-size:14px;display:inline-block}ul.breadcrumb li a .text{font-size:16px;font-weight:700;display:none;opacity:0}ul.breadcrumb li:last-child a{padding:0}.stepsContainer{margin-top:20px;text-align:center}");var i='<div class="stepsContainer index{{step}}">\n	<h4 class="stepCounter"> 司导注册 ({{step}}/5)</h4>\n	<p class="stepInfo"></p>\n	<!-- <ul class="breadcrumb">\n	  <li class="step1"> \n	    <a>\n	      <span class="icon">4</span>\n	      <span class="text">确认提交</span>\n	    </a>\n	  </li>\n	  <li class="step2"> \n	    <a>\n	      <span class="icon">3</span>\n	      <span class="text">结算账户</span>\n	    </a>\n	  </li>\n	  <li class="step3">\n	    <a>\n	      <span class="icon ">2</span>\n	      <span class="text">认证照片</span>\n	    </a>\n	  </li>	  \n	  <li class="step4">\n	    <a>\n	      <span class="icon">1</span>\n	       <span class="text">我的资料</span>\n	    </a>\n	  </li>\n	</ul>	 -->\n\n</div>',r=n(75),o=n(3),s=r.extend({title:"regSteps",data:function(){return{step:1}},created:function(){}});t.exports=s,o.component("view/regSteps",s),("function"==typeof t.exports?t.exports.options:t.exports).template=i},75:function(t,e,n){var i=n(3),r=i.extend({onCreate:function(){},onResume:function(){},onPause:function(){}});t.exports=r},78:function(t,e,n){!function(n,i){"undefined"!=typeof t&&t.exports&&(e=t.exports=i(n,e))}(this,function(t,e){"use strict";return Array.prototype.indexOf||(Array.prototype.indexOf=function(t){var e=this.length>>>0,n=Number(arguments[1])||0;for(n=0>n?Math.ceil(n):Math.floor(n),0>n&&(n+=e);e>n;n++)if(n in this&&this[n]===t)return n;return-1}),e.prefix="",e._getPrefixedKey=function(t,e){return e=e||{},e.noPrefix?t:this.prefix+t},e.set=function(t,e,n){var i=this._getPrefixedKey(t,n);try{localStorage.setItem(i,JSON.stringify({data:e}))}catch(r){console&&console.warn("Lockr didn't successfully save the '{"+t+": "+e+"}' pair, because the localStorage is full.")}},e.get=function(t,e,n){var i,r=this._getPrefixedKey(t,n);try{i=JSON.parse(localStorage.getItem(r))}catch(o){i=null}return null===i?e:i.data||e},e.sadd=function(t,n,i){var r,o=this._getPrefixedKey(t,i),s=e.smembers(t);if(s.indexOf(n)>-1)return null;try{s.push(n),r=JSON.stringify({data:s}),localStorage.setItem(o,r)}catch(a){console.log(a),console&&console.warn("Lockr didn't successfully add the "+n+" to "+t+" set, because the localStorage is full.")}},e.smembers=function(t,e){var n,i=this._getPrefixedKey(t,e);try{n=JSON.parse(localStorage.getItem(i))}catch(r){n=null}return null===n?[]:n.data||[]},e.sismember=function(t,n,i){this._getPrefixedKey(t,i);return e.smembers(t).indexOf(n)>-1},e.getAll=function(){var t=Object.keys(localStorage);return t.map(function(t){return e.get(t)})},e.srem=function(t,n,i){var r,o,s=this._getPrefixedKey(t,i),a=e.smembers(t,n);o=a.indexOf(n),o>-1&&a.splice(o,1),r=JSON.stringify({data:a});try{localStorage.setItem(s,r)}catch(c){console&&console.warn("Lockr couldn't remove the "+n+" from the set "+t)}},e.rm=function(t){localStorage.removeItem(t)},e.flush=function(){localStorage.clear()},e})},86:function(t,e,n){var i,r,o;!function(n,s){r=[],i=s,o="function"==typeof i?i.apply(e,r):i,!(void 0!==o&&(t.exports=o))}(this,function(t){function e(t,e){var n=h(t);return n.constructor=e,n}function n(t,e){for(var n in e)t[n]=e[n];return t}function i(t){return function(){var e=arguments.callee;if(this&&this instanceof e){var n=t.apply(this,arguments);return n&&c(n)?n:this}return p["new"](e,arguments)}}var r=0,o=Object.prototype.toString,s=function(t){return"[object String]"==o.call(t)},a=function(t){return"[object Function]"==o.call(t)},c=function(t){return"[object Object]"==o.call(t)},u=function(t){return"[object Array]"==o.call(t)},l={}.__proto__==Object.prototype,h=function(t){var e,n=function(){};return Object.create?e=Object.create(t):(n.prototype=t,e=new n),e},f={constructorName:"__",autoSuperConstructor:!1,notUseNew:!0,useExtend:!0,useMixin:!0,useSuper:!0,disguise:!1,useConstructor:!0},p={uuid:function(t){return(t||"cls_")+(+new Date).toString(32)+(r++).toString(32)},Base:null,config:function(t){return s(t)?f[t]:c(t)?f=n(f,t):f},create:function(t){return p.inherit(p.Base||Object,t)},"new":function(t,e){if(a(t)){var n=h(t.prototype),i=t.apply(n,e||[]);return i&&c(i)?i:n}throw new Error("fatal error: $Class.new expects a constructor of class.")},inherit:function(t,n,r){if(a(t)){n=n||{},r=r||f.autoSuperConstructor;var o=n[f.constructorName]||function(){};delete n[f.constructorName];var s=function(){r&&t.apply(this,arguments);var e=o.apply(this,arguments);return e&&c(e)?e:void 0};return f.notUseNew&&(s=i(s)),f.disguise&&(s.name=o.name,s.length=o.length,s.toString=function(){return o.toString()}),l?s.prototype.__proto__=t.prototype:s.prototype=e(t.prototype,s),this.include(s,n),f.useSuper&&(s.$super=e(t.prototype,t)),f.useSuper&&(s.$constructor=o),f.useExtend&&(s.$extend=function(t,e){return p.inherit(this,t,e)}),f.useMixin&&(s.$mixin=function(t){return p.include(this,t)}),s}},include:function(t,e){if(a(t)||(t=function(){}),c(e))n(t.prototype,e);else if(u(e))for(var i=0;i<e.length;i++)c(e[i])&&n(t.prototype,e[i]);return t},singleton:function(t){var e,i=t[f.constructorName]||function(){},r={};return r[f.constructorName]=function(){return i.apply(this,arguments),e.$instance instanceof e?e.$instance:e.$instance=this},e=p.create(n(t||{},r))},clone:h,member:function(t){if(a(t)){for(var e=[],n={constructor:1},i=t.prototype;i&&i.constructor;i=i.constructor.prototype){for(var r in i)n[r]=1;if(i.constructor==t||i.constructor==Object)break}for(var o in n)e.push(o);return e}},mix:n};return p.Base=p.inherit(Object),t&&(t.$Class=p),p})}});