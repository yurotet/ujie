angular.module('starter.services', [])

// document.addEventListener("jpush.receiveNotification", onReceiveNotification, false);
// document.addEventListener("jpush.receiveMessage", onReceiveMessage, false);
// var onGetRegistradionID = function(data) {
//     try{
//         alert("JPushPlugin:registrationID is "+data)
//     }
//     catch(exception){
//         alert(exception);
//     }
// };

// var onReceiveNotification = function(event){
//     try{
//         var eventContent="{";
//         for(var key in event){
//             if(key=="type"){
//                 break
//             }
//            eventContent+=key+":"+JSON.stringify(event[key])+"\n"
//         }
//         eventContent+="}";
//         alert(eventContent);
        
//     }
//     catch(exeption){
//         console.log(exception)
//     }
// }
// var onReceiveMessage = function(event){
//     try{
//          var message = window.plugins.jPushPlugin.receiveMessage.message;
//          //var extras = window.plugins.jPushPlugin.extras

//          alert(message);
         
//     }
//     catch(exception){
//         console.log("JPushPlugin:onReceiveMessage-->"+exception);
//     }
// }

.factory('Chats', ['$q', '$http', 'Account', function($q, $http, Account) {
    var isInited = false;
    return {
        init: function(success, error) {
            
        },
        sendMsg: function(username, msg) {
            var deferred = $q.defer();
            var req = {
                method: 'POST',
                url: 'http://wx.ujietrip.com/service/rest/chat/send/',
                headers: {
                    // "Authorization": "Token " + Account.getUserInfo().token
                    "Authorization": "Token 6d54bf74d9f30d1579446d3e1d56b40013d65672"
                },
                data: {
                    target_username: username,
                    msg: msg
                }
            };
            $http(req).success(function() {
                deferred.resolve();
            }).error(function() {
                deferred.reject();
            });
            return deferred.promise;
        }
    };
}])

.factory('Account', ['$q', '$http', function($q, $http) {
    var isInited;
    var jp_registration_id;
    var userInfo = {};
    return {
        _init: function() {
            var deferred = $q.defer();
            if(isInited) deferred.resolve();
            if (!isInited) {
                if(window.plugins && window.plugins.jPushPlugin) {
                    var jpush = window.plugins.jPushPlugin;
                    jpush.init();
                    jpush.getRegistrationID(function(data) {
                        if(data) {
                            jp_registration_id = data;
                            isInited = true;
                            deferred.resolve();
                        } else {
                            deferred.reject();
                        }
                    });
                } else {
                    deferred.resolve();
                }
            } else {
                deferred.reject();
            }
            return deferred.promise;
        },

        login: function(username, password) {
            var deferred = $q.defer();
            this._init().then(function() {
                $http.post('http://wx.ujietrip.com/service/rest/user/login/', {
                    username: username,
                    password: password,
                    jp_registration_id: jp_registration_id
                })
                .success(function(result) {
                    userInfo.username = username;
                    userInfo.token = result.token;
                    deferred.resolve(result);
                })
                .error(function() {
                    deferred.reject();
                });
            }.bind(this));
            return deferred.promise;
        },

        getUserInfo: function() {
            return userInfo;
        }
    }
}]);