webpackJsonp([9],{71:function(t,e,n){var i={};t.exports=function(t,e){if(!i[t]){i[t]=!0;var n=document.createElement("style");n.setAttribute("type","text/css"),"textContent"in n?n.textContent=t:n.styleSheet.cssText=t;var r=document.getElementsByTagName("head")[0];e&&e.prepend?r.insertBefore(n,r.childNodes[0]):r.appendChild(n)}}},72:function(t,e,n){(function(e){var i=n(68),r=n(6),o=n(89),s=r.extend({});o.mix(s.prototype,{name:"BagePage",startMode:"newinstance",intervalCounter:0,startPage:function(t){i.goTo(t)},startPageForResult:function(t,e){},back:function(){i.back()},hideToast:function(){var t=document.getElementById("toast");t&&(t.style.opacity=0,t.style.display="none",clearInterval(this.intervalCounter))},getParam:function(t){var e=window.location.hash,n=e.indexOf("?");if(-1!=n){var i=new RegExp("(^|&)"+t+"=([^&]*)(&|$)","i"),r=e.substr(n+1).match(i);if(null!=r)return unescape(r[2])}return null},showToast:function(t,n){if(t){this.hideToast();var i=document.getElementById("toast");if(null==i){var r='<div id="toast">'+t+"</div>";document.body.insertAdjacentHTML("beforeEnd",r)}else e(i).text(t),i.style.display="block",i.style.opacity=.9;intervalCounter=setInterval(this.hideToast,n?2200:1300)}},showLoading:function(){e(".m-load2").css("display","block"),e(".js-loading").addClass("active"),setTimeout(this.hideLoading,1e4)},hideLoading:function(){e(".m-load2").css("display","none"),e(".js-loading").removeClass("active")}}),t.exports=s}).call(e,n(2))},83:function(t,e,n){n(71)(".regHeader,.resContainer{text-align:center}.resContainer h3{margin:25px}.resContainer p{font-size:16px;margin:40px}");var i='<div class="regHeader">\n		<img src="logo.png">\n	</div>\n\n	<div class="resContainer" style="display:{{isPass==\'1\'? \'block\':\'none\'}}">\n		<h3 class="resultSummary">太厉害了，考试通过！</h3>\n		<p>恭喜您，成功通过考试，成为蜜柚小青，快去下载蜜柚接单APP开始接单了！</p>\n		<a href="http://m.miutour.com/qrcode/index.html" class="btn btn-positive btn-block">下载蜜柚接单APP</a>\n	</div>\n\n	<div class="resContainer" style="display:{{isPass==\'0\'? \'block\':\'none\'}}">\n		<h3 class="resultSummary">糗大了，居然没考过！</h3>\n		<p>很遗憾，这次考试没通过，不过别气馁，复习一下我们再来一次！</p>		\n	</div>\n\n	<div class="resContainer" style="display:{{isPass==\'3\'? \'block\':\'none\'}}">\n		<h3 class="resultSummary">不要急，再复习一下！</h3>\n		<p>很遗憾，今天的考试机会已用完，请复习一下，隔天再来考试！</p>		\n	</div>',r=n(72),o=(n(6),r.extend({title:"考试结果",data:function(){return{isPass:!1}},methods:{onPass:function(){},onFail:function(){}},created:function(){},resume:function(){this.$data.isPass=this.getParam("r")},pause:function(){}}));t.exports=o,("function"==typeof t.exports?t.exports.options:t.exports).template=i},89:function(t,e,n){var i,r,o;!function(n,s){r=[],i=s,o="function"==typeof i?i.apply(e,r):i,!(void 0!==o&&(t.exports=o))}(this,function(t){function e(t,e){var n=h(t);return n.constructor=e,n}function n(t,e){for(var n in e)t[n]=e[n];return t}function i(t){return function(){var e=arguments.callee;if(this&&this instanceof e){var n=t.apply(this,arguments);return n&&c(n)?n:this}return f["new"](e,arguments)}}var r=0,o=Object.prototype.toString,s=function(t){return"[object String]"==o.call(t)},a=function(t){return"[object Function]"==o.call(t)},c=function(t){return"[object Object]"==o.call(t)},u=function(t){return"[object Array]"==o.call(t)},l={}.__proto__==Object.prototype,h=function(t){var e,n=function(){};return Object.create?e=Object.create(t):(n.prototype=t,e=new n),e},p={constructorName:"__",autoSuperConstructor:!1,notUseNew:!0,useExtend:!0,useMixin:!0,useSuper:!0,disguise:!1,useConstructor:!0},f={uuid:function(t){return(t||"cls_")+(+new Date).toString(32)+(r++).toString(32)},Base:null,config:function(t){return s(t)?p[t]:c(t)?p=n(p,t):p},create:function(t){return f.inherit(f.Base||Object,t)},"new":function(t,e){if(a(t)){var n=h(t.prototype),i=t.apply(n,e||[]);return i&&c(i)?i:n}throw new Error("fatal error: $Class.new expects a constructor of class.")},inherit:function(t,n,r){if(a(t)){n=n||{},r=r||p.autoSuperConstructor;var o=n[p.constructorName]||function(){};delete n[p.constructorName];var s=function(){r&&t.apply(this,arguments);var e=o.apply(this,arguments);return e&&c(e)?e:void 0};return p.notUseNew&&(s=i(s)),p.disguise&&(s.name=o.name,s.length=o.length,s.toString=function(){return o.toString()}),l?s.prototype.__proto__=t.prototype:s.prototype=e(t.prototype,s),this.include(s,n),p.useSuper&&(s.$super=e(t.prototype,t)),p.useSuper&&(s.$constructor=o),p.useExtend&&(s.$extend=function(t,e){return f.inherit(this,t,e)}),p.useMixin&&(s.$mixin=function(t){return f.include(this,t)}),s}},include:function(t,e){if(a(t)||(t=function(){}),c(e))n(t.prototype,e);else if(u(e))for(var i=0;i<e.length;i++)c(e[i])&&n(t.prototype,e[i]);return t},singleton:function(t){var e,i=t[p.constructorName]||function(){},r={};return r[p.constructorName]=function(){return i.apply(this,arguments),e.$instance instanceof e?e.$instance:e.$instance=this},e=f.create(n(t||{},r))},clone:h,member:function(t){if(a(t)){for(var e=[],n={constructor:1},i=t.prototype;i&&i.constructor;i=i.constructor.prototype){for(var r in i)n[r]=1;if(i.constructor==t||i.constructor==Object)break}for(var o in n)e.push(o);return e}},mix:n};return f.Base=f.inherit(Object),t&&(t.$Class=f),f})}});