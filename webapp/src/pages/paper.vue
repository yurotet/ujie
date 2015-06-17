<script>
	var BasePage = require('common/basepage');
	var Vue = require('vue');
	var nav = require('common/navigator');
	var config = require('config');	
	var lockr = require('common/localstorageutil');

	var View = BasePage.extend({
		title: '私导初级考试',
		data: function() {
			return {
				paper: {
					
				}
			};
		},
		
		methods: {	
			checkSubmitBtn:function () {
				var answers = this._extractChoices().answers, i;				

				for (i =0 ; i< answers.length; i++) {
					if (!answers[i].choices.length)
						break;
				}

				var disabled = (i != answers.length);

				var btn = $('#paperSubmit');
				if (!disabled) {
					btn.attr('disabled','disabled');
				}else {
					btn.removeAttr('disabled');
				}			
			},

			onInputChange :function() {
				var answers = this._extractChoices();
				console.log(answers);
				var paper = {};
				paper[answers.paper_id] = answers.answers;

				lockr.set('user.papers', paper)	
				
				this.checkSubmitBtn();
			},

			onSubmit: function() {				
				var answers = this._extractChoices();
				console.log(answers);
			}, 
			//extract answers from vm
			_extractChoices: function() {
				var paper = {
					paper_id: this.$data.paper.id,
					answers: []
				};
				this.$data.paper.questions.forEach(function(q) {
					var answer = {
						question_id: q.qid,
						choices: []
					};
					if(q.type == 1 || q.type == 2) {
						if(q._choices) {
							answer.choices.push(q._choices);
						}
					} else if(q.type == 3) {
						for(var i = 0; i < q._choices.length; ++i) {
							var choice = q._choices[i];
							var answerIdx = i + 1;
							if(choice) {
								answer.choices.push(answerIdx);
							}
						}
					}
					paper.answers.push(answer);
				});
				return paper;
			},
			_getABCFromIndex: function(idx) {
				// 'A' = 65
				return String.fromCharCode(65 + idx);
			},

			initData: function() {
				// var answers = lockr.get('user.paper' + this.$data.paper.paper_id + '.answers');
				var papers = lockr.get('user.papers');
				console.log(papers);
								
				var answers = papers && papers[this.$data.paper.id];
				console.log(answers);
				var questions = this.$data.paper.questions;
				
				if (answers) {				
					for (var i =0 ; i < questions.length; i ++) {
						switch (questions[i].type) {
							case '1':
							case '2':
								if (answers[i].choices.length) {
									questions[i]._choices = answers[i].choices[0];
								}								
							break;
							case '3':
								if (answers[i].choices.length) {
									$.each(answers[i].choices,function(key,index){	
										questions[i]._choices[index-1] = 'true';
									})									
								}
							break;
						}						
					}
				}												
			}
		},
		created: function() {
			this.showLoading();
			$.ajax({
				  type:'POST',				  
				  url: '/api/paper', 				 
				  dataType: 'json',
				  timeout: 10000,
				  context: this,
				  success: function(res){					  						  
				  	if(res.err_code==0){				  		
						var res = res.data;
						
						for(var i = 0; i < res.questions.length; ++i) {
							var q = res.questions[i];
							if(q.type == 3) {
								q._choices = [];
							} else {
								q._choices=null;
							}
							for(var j = 0; j < q.options.length; ++j) {
								var o = q.options[j];
								var idx = j;
								o.value = idx + 1;
								o._text = this._getABCFromIndex(idx) + ". " + o.key;
							}
						}
						this.$data.paper = res;	

						this.initData();
						// this.$data.paper.questions[0]._choices=1;

				  	} else {					  		
				  		this.showToast(res.err_msg,true);	  		
				  	}
				    
				  },
				  complete:function() {
				  	this.hideLoading();					  	
				  },
				
				  error: function(xhr, type){
				   	
				  }
			})		
		},
		resume: function() {
		},
		pause: function() {
		}
	});

	module.exports = View;
</script>

<style>
	.paper ul {
		list-style-type:decimal
	}

	.paper li{
		margin-bottom: 20px;
	}

	.ques-des {
		font-size: 18px;
		margin-bottom: 8px;
	}

	.ques-option {
		font-size:16px;
		width:45%;
		display: inline-block;
		height: 40px;
		margin-right: 4%;
	}

	.ques-option input{
		margin-right:10px;		
	}
</style>

<template>
  <section class="paper">
    <ul>
      <li v-repeat="q : paper.questions">
      	<div  v-if="q.type==1 || q.type==2">
          <div class="ques-des">
            {{q.question}}
          </div>
          <div >
          	<span  class="ques-option"   v-repeat="o : q.options">
          		<input type="radio" v-on="change:onInputChange" name="{{q.qid}}" value="{{$index}}" v-model="q._choices"><label>{{o._text}}</label>
          	</span>
          </div>
        </div>
        <div v-if="q.type==3">
          <div class="ques-des">
            {{q.question}}
          </div>
          <div>
          	<span  class="ques-option"  v-repeat="o : q.options">
          		<input type="checkbox"   v-on="change:onInputChange" name="{{q.qid}}" value="{{$index}}" v-model="q._choices[$index]"><label>{{o._text}}</label>
          	</span>
          </div>
        </div>
      </li>
    </ul>
    <button id='paperSubmit' class="btn btn-positive btn-block" v-on="click: onSubmit">提交考卷</button>
  </section>
</template>