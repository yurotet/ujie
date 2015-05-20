angular.module('starter.controllers', [])

.controller('DashCtrl', function($scope) {})

.controller('ChatsCtrl', function($scope, Chats, Account) {
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

 	$scope.username = "sy890622";
 	$scope.password = "123456";

 	$scope.msg = "test msg";

 	$scope.login = function() {
 		Account.login(this.username, this.password).then(function() {
 			alert('login success');
 		}.bind(this));
 	};

 	$scope.send = function() {
 		Chats.sendMsg(this.username, this.msg).then(function() {
 			alert('msg sent');
 		}.bind(this));
 	};
})

.controller('ChatDetailCtrl', function($scope, $stateParams, Chats) {
  $scope.chat = Chats.get($stateParams.chatId);
})

.controller('AccountCtrl', function($scope) {
  $scope.settings = {
    enableFriends: true
  };
});
