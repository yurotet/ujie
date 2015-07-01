webpackJsonp([2],{71:function(t,e,n){var i={};t.exports=function(t,e){if(!i[t]){i[t]=!0;var n=document.createElement("style");n.setAttribute("type","text/css"),"textContent"in n?n.textContent=t:n.styleSheet.cssText=t;var r=document.getElementsByTagName("head")[0];e&&e.prepend?r.insertBefore(n,r.childNodes[0]):r.appendChild(n)}}},72:function(t,e,n){(function(e){var i=n(68),r=n(6),o=n(86),s=r.extend({});o.mix(s.prototype,{name:"BagePage",startMode:"newinstance",intervalCounter:0,startPage:function(t){i.goTo(t)},startPageForResult:function(t,e){},back:function(){i.back()},hideToast:function(){var t=document.getElementById("toast");t&&(t.style.opacity=0,t.style.display="none",clearInterval(this.intervalCounter))},getParam:function(t){var e=window.location.hash,n=e.indexOf("?");if(-1!=n){var i=new RegExp("(^|&)"+t+"=([^&]*)(&|$)","i"),r=e.substr(n+1).match(i);if(null!=r)return unescape(r[2])}return null},showToast:function(t,n){if(t){this.hideToast();var i=document.getElementById("toast");if(null==i){var r='<div id="toast">'+t+"</div>";document.body.insertAdjacentHTML("beforeEnd",r)}else e(i).text(t),i.style.display="block",i.style.opacity=.9;intervalCounter=setInterval(this.hideToast,n?2200:1300)}},showLoading:function(){e(".m-load2").css("display","block"),e(".js-loading").addClass("active"),setTimeout(this.hideLoading,1e4)},hideLoading:function(){e(".m-load2").css("display","none"),e(".js-loading").removeClass("active")}}),t.exports=s}).call(e,n(2))},73:function(t,e,n){(function(e){n(71)(".paper ul{list-style-type:decimal}.paper li{margin-bottom:20px}.ques-des{font-size:18px;margin-bottom:8px}.ques-option{font-size:16px;width:45%;display:inline-block;height:40px;margin-right:4%}.ques-option input{margin-right:10px}.regHeader{text-align:center}.regHeader h3{margin:25px 25px 40px}");var i='<div class="regHeader">\n	<img src="logo.png">\n	<h3>{{paperName}}</h3>\n</div>\n  <section class="paper">\n    <ul>\n      <li v-repeat="q : paper.questions">\n      	<div v-if="q.type==1 || q.type==2">\n          <div class="ques-des">\n            {{q.question}}\n          </div>\n          <div>\n          	<span class="ques-option" v-repeat="o : q.options">\n          		<input type="radio" v-on="change:onInputChange" name="{{q.qid}}" value="{{$index}}" v-model="q._choices"><label>{{o._text}}</label>\n          	</span>\n          </div>\n        </div>\n        <div v-if="q.type==3">\n          <div class="ques-des">\n            {{q.question}}\n          </div>\n          <div>\n          	<span class="ques-option" v-repeat="o : q.options">\n          		<input type="checkbox" v-on="change:onInputChange" name="{{q.qid}}" value="{{$index}}" v-model="q._choices[$index]"><label>{{o._text}}</label>\n          	</span>\n          </div>\n        </div>\n      </li>\n    </ul>\n    <button id="paperSubmit" class="btn btn-positive btn-block" v-on="click: onSubmit">提交考卷</button>\n  </section>',r=n(72),o=(n(6),n(68)),s=(n(69),n(88)),a=r.extend({title:"私导初级考试",data:function(){return{paperName:"",paper:{}}},methods:{checkSubmitBtn:function(){var t,n=this._extractChoices().answers;for(t=0;t<n.length&&n[t].choices.length;t++);var i=t!=n.length,r=e("#paperSubmit");i?r.attr("disabled","disabled"):r.removeAttr("disabled")},onInputChange:function(){var t=this._extractChoices(),e={};e[t.paper_id]=t.answers,s.set("user.papers",e),this.checkSubmitBtn()},getPostAnswers:function(){var t=this.$data.paper.questions,n={};return n.id=this.$data.paper.id,e.each(t,function(t,i){var r=e.isArray(i._choices)?i._choices:[i._choices],o=e.map(r,function(t,e){return"3"==i.type&&"true"==t?i.options[e]._text:"1"==i.type||"2"==i.type?i.options[t]._text:void 0});n[i.qid]=o.join("|")}),n},_submit:function(){return new Promise(function(t,n){e.ajax({type:"POST",url:"/api/answer",data:this.getPostAnswers(),dataType:"json",timeout:1e4,context:this,success:function(e){0==e.err_code?e.is_pass?t("pass"):e.is_pass||t("fail"):n(e.err_msg)},error:function(){n()}})}.bind(this))},onSubmit:function(){this.showLoading(),this._submit().then(function(t){this.hideLoading(),"pass"==t?o.goTo("examResult?r=1"):"fail"==t&&o.goTo("examResult?r=0")}.bind(this))["catch"](function(t){this.hideLoading(),this.showToast(t,!0)}.bind(this))},_extractChoices:function(){var t={paper_id:this.$data.paper.id,answers:[]};return e.each(this.$data.paper.questions,function(e,n){var i={question_id:n.qid,choices:[]};if(1==n.type||2==n.type)n._choices&&i.choices.push(n._choices);else if(3==n.type)for(var r=0;r<n._choices.length;++r){var o=n._choices[r],s=r+1;o&&i.choices.push(s)}t.answers.push(i)}),t},initData:function(){var t=s.get("user.papers"),n=t&&t[this.$data.paper.id],i=this.$data.paper.questions;if(n)for(var r=0;r<i.length;r++)switch(i[r].type){case"1":case"2":n[r].choices.length&&(i[r]._choices=n[r].choices[0]);break;case"3":n[r].choices.length&&e.each(n[r].choices,function(t,e){i[r]._choices[e-1]="true"})}}},created:function(){},resume:function(){this.showLoading(),e.ajax({type:"POST",url:"/api/paper",dataType:"json",timeout:1e4,context:this,success:function(t){if(t.enable)if(0==t.err_code){var e=t.data;this.$data.paperName=e.name;for(var n=0;n<e.questions.length;++n){var i=e.questions[n];3==i.type?i._choices=[]:i._choices=null;for(var r=0;r<i.options.length;++r){var s=i.options[r],a=r;s.value=a+1,s._text=s.key}}this.$data.paper=e,this.initData(),this.checkSubmitBtn()}else this.showToast(e.err_msg,!0);else o.goTo("examResult?r=3")},complete:function(){this.hideLoading()},error:function(t,e){}})},pause:function(){}});t.exports=a,("function"==typeof t.exports?t.exports.options:t.exports).template=i}).call(e,n(2))},86:function(t,e,n){var i,r,o;!function(n,s){r=[],i=s,o="function"==typeof i?i.apply(e,r):i,!(void 0!==o&&(t.exports=o))}(this,function(t){function e(t,e){var n=h(t);return n.constructor=e,n}function n(t,e){for(var n in e)t[n]=e[n];return t}function i(t){return function(){var e=arguments.callee;if(this&&this instanceof e){var n=t.apply(this,arguments);return n&&c(n)?n:this}return p["new"](e,arguments)}}var r=0,o=Object.prototype.toString,s=function(t){return"[object String]"==o.call(t)},a=function(t){return"[object Function]"==o.call(t)},c=function(t){return"[object Object]"==o.call(t)},u=function(t){return"[object Array]"==o.call(t)},l={}.__proto__==Object.prototype,h=function(t){var e,n=function(){};return Object.create?e=Object.create(t):(n.prototype=t,e=new n),e},f={constructorName:"__",autoSuperConstructor:!1,notUseNew:!0,useExtend:!0,useMixin:!0,useSuper:!0,disguise:!1,useConstructor:!0},p={uuid:function(t){return(t||"cls_")+(+new Date).toString(32)+(r++).toString(32)},Base:null,config:function(t){return s(t)?f[t]:c(t)?f=n(f,t):f},create:function(t){return p.inherit(p.Base||Object,t)},"new":function(t,e){if(a(t)){var n=h(t.prototype),i=t.apply(n,e||[]);return i&&c(i)?i:n}throw new Error("fatal error: $Class.new expects a constructor of class.")},inherit:function(t,n,r){if(a(t)){n=n||{},r=r||f.autoSuperConstructor;var o=n[f.constructorName]||function(){};delete n[f.constructorName];var s=function(){r&&t.apply(this,arguments);var e=o.apply(this,arguments);return e&&c(e)?e:void 0};return f.notUseNew&&(s=i(s)),f.disguise&&(s.name=o.name,s.length=o.length,s.toString=function(){return o.toString()}),l?s.prototype.__proto__=t.prototype:s.prototype=e(t.prototype,s),this.include(s,n),f.useSuper&&(s.$super=e(t.prototype,t)),f.useSuper&&(s.$constructor=o),f.useExtend&&(s.$extend=function(t,e){return p.inherit(this,t,e)}),f.useMixin&&(s.$mixin=function(t){return p.include(this,t)}),s}},include:function(t,e){if(a(t)||(t=function(){}),c(e))n(t.prototype,e);else if(u(e))for(var i=0;i<e.length;i++)c(e[i])&&n(t.prototype,e[i]);return t},singleton:function(t){var e,i=t[f.constructorName]||function(){},r={};return r[f.constructorName]=function(){return i.apply(this,arguments),e.$instance instanceof e?e.$instance:e.$instance=this},e=p.create(n(t||{},r))},clone:h,member:function(t){if(a(t)){for(var e=[],n={constructor:1},i=t.prototype;i&&i.constructor;i=i.constructor.prototype){for(var r in i)n[r]=1;if(i.constructor==t||i.constructor==Object)break}for(var o in n)e.push(o);return e}},mix:n};return p.Base=p.inherit(Object),t&&(t.$Class=p),p})},88:function(t,e,n){!function(n,i){"undefined"!=typeof t&&t.exports&&(e=t.exports=i(n,e))}(this,function(t,e){"use strict";return Array.prototype.indexOf||(Array.prototype.indexOf=function(t){var e=this.length>>>0,n=Number(arguments[1])||0;for(n=0>n?Math.ceil(n):Math.floor(n),0>n&&(n+=e);e>n;n++)if(n in this&&this[n]===t)return n;return-1}),e.prefix="",e._getPrefixedKey=function(t,e){return e=e||{},e.noPrefix?t:this.prefix+t},e.set=function(t,e,n){var i=this._getPrefixedKey(t,n);try{localStorage.setItem(i,JSON.stringify({data:e}))}catch(r){console&&console.warn("Lockr didn't successfully save the '{"+t+": "+e+"}' pair, because the localStorage is full.")}},e.get=function(t,e,n){var i,r=this._getPrefixedKey(t,n);try{i=JSON.parse(localStorage.getItem(r))}catch(o){i=null}return null===i?e:i.data||e},e.sadd=function(t,n,i){var r,o=this._getPrefixedKey(t,i),s=e.smembers(t);if(s.indexOf(n)>-1)return null;try{s.push(n),r=JSON.stringify({data:s}),localStorage.setItem(o,r)}catch(a){console.log(a),console&&console.warn("Lockr didn't successfully add the "+n+" to "+t+" set, because the localStorage is full.")}},e.smembers=function(t,e){var n,i=this._getPrefixedKey(t,e);try{n=JSON.parse(localStorage.getItem(i))}catch(r){n=null}return null===n?[]:n.data||[]},e.sismember=function(t,n,i){this._getPrefixedKey(t,i);return e.smembers(t).indexOf(n)>-1},e.getAll=function(){var t=Object.keys(localStorage);return t.map(function(t){return e.get(t)})},e.srem=function(t,n,i){var r,o,s=this._getPrefixedKey(t,i),a=e.smembers(t,n);o=a.indexOf(n),o>-1&&a.splice(o,1),r=JSON.stringify({data:a});try{localStorage.setItem(s,r)}catch(c){console&&console.warn("Lockr couldn't remove the "+n+" from the set "+t)}},e.rm=function(t){localStorage.removeItem(t)},e.flush=function(){localStorage.clear()},e})}});