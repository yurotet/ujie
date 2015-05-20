angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope) {})

.controller('ChatsCtrl', function($scope, Chats, Account) {
	var onReceiveMessage = function(event) {
	    try {
	    	var jpush = window.plugins.jPushPlugin;
	        var message = jpush.openNotification.message;
	        var extra = jpush.openNotification.extras ? jpush.openNotification.extras["cn.jpush.android.EXTRA"] : {};
	        $scope.chats.push({
	        	type: 'incoming',
	        	msg: message,
	        	sender: extra.sender
	        });

	    } catch (exception) {
	        console.log("JPushPlugin:onReceiveMessage-->" + exception);
	    }
	}

	document.addEventListener("jpush.receiveMessage", onReceiveMessage, false);

 	$scope.msg = "test msg";

 	$scope.chats = [
 		{
 			type: 'incoming',
 			msg: 'incoming-msg',
 			sender: 'Brian'
 		},
 		{
 			type: 'outcoming',
 			msg: 'outcoming-msg',
 			sender: 'Maseo'
 		}
 	];

 	$scope.send = function() {
 		var userInfo = Account.getUserInfo();
		$scope.chats.push({
        	type: 'outcoming',
        	msg: this.msg,
        	sender: userInfo.username
        });
 		Chats.sendMsg(userInfo.username, this.msg).then(function() {
 		}.bind(this));
 	};
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
})

.controller('AccountCtrl', function($scope, $ionicPopup, $ionicLoading, $state, Account) {
 	$scope.username = "sy890622";
 	$scope.password = "123456";

 	$scope.login = function() {
 		$ionicLoading.show({
 			template: 'Loading...'
 		});
 		Account.login(this.username, this.password)
 		.finally(function() {
 			$ionicLoading.hide();
 		})
 		.then(function() {
			$ionicPopup.alert({
				title: 'Notificaiton',
				template: 'Login Success!'
			})
			.then(function() {
				$state.go('tab.chats');
			});
 		}.bind(this))
 		.catch(function() {
 			var alertPopup = $ionicPopup.alert({
				title: 'Notificaiton',
				template: 'Login Failed!'
			});
 		});
 	};
});
