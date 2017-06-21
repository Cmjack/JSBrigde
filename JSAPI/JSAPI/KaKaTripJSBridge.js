 (function(){
  var isReady = false, readyQueue = [], _ready = function(func) {
  readyQueue = readyQueue || [];
  if (typeof func === "function") {
  if (isReady) {
  func.call(window);
  } else {
  readyQueue.push(func);
  }
  }
  };
  _invoke = function(message) {
  if (typeof message === "object") message = JSON.stringify(message);
  window.webkit.messageHandlers.KaKaTrip.postMessage(message);
  };
  
  _hideMenu = function() { _invoke({action:"hideMenu"}); };
  _showMenu = function() { _invoke({action:"showMenu"}); };
  _setTitle = function(title) { _invoke({action:"setTitle", param:title}); };
  _setShare = function(shareConfig) { _invoke({action:"setShare", param:shareConfig}); };
  _share = function(shareConfig) { _invoke({action:"share", param:shareConfig}); };
  _loginWithWechat = function(state) { _invoke({action:"loginWithWechat", param:state}); };
  _showNativePage = function(pageMessage) { _invoke({action:"showNativePage", param:pageMessage}); };
  _hideCloseButton = function(){ _invoke({action:"hideCloseButton"}); };
  _setUserInfo = function(userInfo){ _invoke({action:"setUserInfo",param:userInfo}); };
  
  KaKaTripApp.init = function(){
  readyQueue = readyQueue || [];
  for (var i = 0; i < readyQueue.length; i++) {
  var func = readyQueue[i];
  func.call(window);
  }
  isReady = true;
  delete this.init;
  }
  KaKaTripApp.ready = function(func) {
  _ready(func);
  }
  KaKaTripApp.hideMenu = function() {
  _hideMenu();
  }
  KaKaTripApp.showMenu = function() {
  _showMenu();
  }
  KaKaTripApp.setTitle = function(title) {
  _setTitle(title);
  }
  KaKaTripApp.setShare = function(shareConfig) {
  _setShare(shareConfig);
  }
  KaKaTripApp.share = function(shareConfig) {
  _share(shareConfig);
  }
  KaKaTripApp.loginWithWechat = function(state) {
  _loginWithWechat(state);
  }
  
  KaKaTripApp.showNativePage = function(pageMessage) {
  _showNativePage(pageMessage);
  }
  
  KaKaTripApp.hideCloseButton = function() {
  
  _hideCloseButton();
  
  }
  KaKaTripApp.setUserInfo = function(userInfo) {
  
  _setUserInfo(userInfo);
  
  }
  })();
