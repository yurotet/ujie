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

.factory('Chats', function($q, Account) {
    var isInited = false;
    return {
        init: function(success, error) {
            
        },
        sendMsg: function(username, msg) {
            var deferred = $q.defer();
            $http.post('http://wx.ujietrip.com/service/rest/chat/send/', {
                target_username: username,
                msg: msg
            }).success(function() {
                deferred.resolve();
            }).error(function() {
                deferred.reject();
            });
        }
    };
})

.factory('Account', function($q, $http) {
    var isInited;
    var jp_registration_id;
    var userInfo;
    return {
        _init: function() {
            var deferred = $q.defer();
            if(isInited) deferred.resolve();
            if (!isInited && window.plugins && window.plugins.jPushPlugin) {
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
                deferred.reject();
            }
            return deferred.promise;
        },

        login: function(username, password) {
            $.ajax({
                url: 'http://wx.ujietrip.com/service/rest/common/manufactuers/',
                type: 'GET',
                success: function() {
                    alert("s");
                },
                error: function() {
                    alert("er");
                },
                complete: function() {
                    alert("comp");
                }
            })

            var deferred = $q.defer();
            this._init().then(function() {
                $http.post('http://wx.ujietrip.com/service/rest/user/', {
                    username: username,
                    password: password,
                    jp_registration_id: jp_registration_id
                })
                .success(function(result) {
                    userInfo = result;
                    deferred.resolve(result);
                })
                .error(function() {
                    alert(JSON.stringify(arguments));
                    deferred.reject();
                });
            }.bind(this));
            return deferred.promise;
        },

        getUserInfo: function() {
            return userInfo;
        }
    }
});

