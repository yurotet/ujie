webpackJsonp([10],{68:function(t,e,n){var i={};t.exports=function(t,e){if(!i[t]){i[t]=!0;var n=document.createElement("style");n.setAttribute("type","text/css"),"textContent"in n?n.textContent=t:n.styleSheet.cssText=t;var r=document.getElementsByTagName("head")[0];e&&e.prepend?r.insertBefore(n,r.childNodes[0]):r.appendChild(n)}}},69:function(t,e,n){(function(e){var i=n(65),r=n(3),o=n(86),s=r.extend({});o.mix(s.prototype,{name:"BagePage",startMode:"newinstance",intervalCounter:0,startPage:function(t){i.goTo(t)},startPageForResult:function(t,e){},back:function(){i.back()},hideToast:function(){var t=document.getElementById("toast");t&&(t.style.opacity=0,t.style.display="none",clearInterval(this.intervalCounter))},getParam:function(t){var e=window.location.hash,n=e.indexOf("?");if(-1!=n){var i=new RegExp("(^|&)"+t+"=([^&]*)(&|$)","i"),r=e.substr(n+1).match(i);if(null!=r)return unescape(r[2])}return null},showToast:function(t,n){if(t){this.hideToast();var i=document.getElementById("toast");if(null==i){var r='<div id="toast">'+t+"</div>";document.body.insertAdjacentHTML("beforeEnd",r)}else e(i).text(t),i.style.display="block",i.style.opacity=.9;intervalCounter=setInterval(this.hideToast,n?2200:1300)}},showLoading:function(){e(".m-load2").css("display","block"),e(".js-loading").addClass("active"),setTimeout(this.hideLoading,1e4)},hideLoading:function(){e(".m-load2").css("display","none"),e(".js-loading").removeClass("active")}}),t.exports=s}).call(e,n(2))},81:function(t,e,n){n(68)(".regHeader{text-align:center}.cntContainer{font-size:16px;margin:40px}.miu-text-end{float:right}.miu-text-p{text-indent:25px}.cntContainer .miu-title{text-align:center;margin-bottom:20px}");var i='<div class="regHeader">\n		<img src="logo.png">\n	</div>\n\n	<div class="cntContainer">\n		<div class="miu-title">\n			<h4>隐私协议</h4>\n		</div>\n		<p class="miu-text-p">蜜柚旅行公司依据本协议的规定提供服务，本协议具有合同效力。您必须完全同意以下所有条款并完成个人资料的填写，才能保证享受到更好的蜜柚旅行客服服务。您使用服务的行为将视为对本协议的接受，并同意接受本协议各项条款的约束。</p>\n		<p class="miu-text-p">用户必须合法使用网络服务，不作非法用途，自觉维护本网站的声誉，遵守所有使用网络服务的网络协议、规定、程序和惯例。</p>\n		<p class="miu-text-p">为更好的为用户服务，用户应向本网站提供真实、准确的个人资料，个人资料如有变更，应立即修正。如因用户提供的个人资料不实或不准确，给用户自身造成任何性质的损失，均由用户自行承担。</p>\n		<p class="miu-text-p">尊重个人隐私是蜜柚旅行公司的责任，蜜柚旅行公司在未经用户授权时不得向第三方（蜜柚旅行公司控股或关联、运营合作单位除外）公开、编辑或透露用户个人资料的内容，但由于政府要求、法律政策需要等原因除外。在用户发送信息的过程中和本网站收到信息后，本网站将遵守行业通用的标准来保护用户的私人信息。但是任何通过因特网发送的信息或电子版本的存储方式都无法确保100%的安全性。因此，本网站会尽力使用商业上可接受的方式来保护用户的个人信息，但不对用户信息的安全作任何担保。</p>\n		<p class="miu-text-p">本网站有权在必要时修改服务条例，本网站的服务条例一旦发生变动，将会在本网站的重要页面上提示修改内容，用户如不同意新的修改内容，须立即停止使用本协议约定的服务，否则视为用户完全同意并接受新的修改内容。根据客观情况及经营方针的变化，本网站有中断或停止服务的权利，用户对此表示理解并完全认同。\n		本保密协议的解释权归蜜柚旅行公司所有。</p>\n		\n		<div class="miu-text-end">\n			<p>蜜柚旅行公司</p>\n			<p>2004年09月</p>\n		</div>\n	</div>',r=n(69),o=(n(3),r.extend({title:"蜜柚隐私协议",methods:{},created:function(){}}));t.exports=o,("function"==typeof t.exports?t.exports.options:t.exports).template=i},86:function(t,e,n){var i,r,o;!function(n,s){r=[],i=s,o="function"==typeof i?i.apply(e,r):i,!(void 0!==o&&(t.exports=o))}(this,function(t){function e(t,e){var n=f(t);return n.constructor=e,n}function n(t,e){for(var n in e)t[n]=e[n];return t}function i(t){return function(){var e=arguments.callee;if(this&&this instanceof e){var n=t.apply(this,arguments);return n&&c(n)?n:this}return h["new"](e,arguments)}}var r=0,o=Object.prototype.toString,s=function(t){return"[object String]"==o.call(t)},a=function(t){return"[object Function]"==o.call(t)},c=function(t){return"[object Object]"==o.call(t)},u=function(t){return"[object Array]"==o.call(t)},l={}.__proto__==Object.prototype,f=function(t){var e,n=function(){};return Object.create?e=Object.create(t):(n.prototype=t,e=new n),e},p={constructorName:"__",autoSuperConstructor:!1,notUseNew:!0,useExtend:!0,useMixin:!0,useSuper:!0,disguise:!1,useConstructor:!0},h={uuid:function(t){return(t||"cls_")+(+new Date).toString(32)+(r++).toString(32)},Base:null,config:function(t){return s(t)?p[t]:c(t)?p=n(p,t):p},create:function(t){return h.inherit(h.Base||Object,t)},"new":function(t,e){if(a(t)){var n=f(t.prototype),i=t.apply(n,e||[]);return i&&c(i)?i:n}throw new Error("fatal error: $Class.new expects a constructor of class.")},inherit:function(t,n,r){if(a(t)){n=n||{},r=r||p.autoSuperConstructor;var o=n[p.constructorName]||function(){};delete n[p.constructorName];var s=function(){r&&t.apply(this,arguments);var e=o.apply(this,arguments);return e&&c(e)?e:void 0};return p.notUseNew&&(s=i(s)),p.disguise&&(s.name=o.name,s.length=o.length,s.toString=function(){return o.toString()}),l?s.prototype.__proto__=t.prototype:s.prototype=e(t.prototype,s),this.include(s,n),p.useSuper&&(s.$super=e(t.prototype,t)),p.useSuper&&(s.$constructor=o),p.useExtend&&(s.$extend=function(t,e){return h.inherit(this,t,e)}),p.useMixin&&(s.$mixin=function(t){return h.include(this,t)}),s}},include:function(t,e){if(a(t)||(t=function(){}),c(e))n(t.prototype,e);else if(u(e))for(var i=0;i<e.length;i++)c(e[i])&&n(t.prototype,e[i]);return t},singleton:function(t){var e,i=t[p.constructorName]||function(){},r={};return r[p.constructorName]=function(){return i.apply(this,arguments),e.$instance instanceof e?e.$instance:e.$instance=this},e=h.create(n(t||{},r))},clone:f,member:function(t){if(a(t)){for(var e=[],n={constructor:1},i=t.prototype;i&&i.constructor;i=i.constructor.prototype){for(var r in i)n[r]=1;if(i.constructor==t||i.constructor==Object)break}for(var o in n)e.push(o);return e}},mix:n};return h.Base=h.inherit(Object),t&&(t.$Class=h),h})}});