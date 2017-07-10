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
  window.webkit.messageHandlers.KaKa.postMessage(message);
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
  
  _showAlert = function(param){_invoke({action:"showAlert",param:param});};
  _showConfirm = function(param){_invoke({action:"showConfirm",param:param});};
  _showPrompt = function(param){_invoke({action:"showPrompt",param:param});};
  _showActionSheet = function(param){_invoke({action:"showActionSheet",param:param});};
  _vibrate = function(param){_invoke({action:"vibrate",param:param});};
  _showToast = function(param){_invoke({action:"showToast",param:param});};
  _showLoading = function(param){_invoke({action:"showLoading",param:param});};
  _hideLoading = function(param){_invoke({action:"hideLoading",param:param});};
  _getNetworkType = function(param){_invoke({action:"getNetworkType",param:param});};
  _checkInstallApps = function(param){_invoke({action:"checkInstallApps",param:param});};
  _launchApp = function(param){_invoke({action:"launchApp",param:param});};
  _openLink = function(param){_invoke({action:"openLink",param:param});};
  _previewImages = function(param){_invoke({action:"previewImages",param:param});};
  
  _setNavigationTitle = function(param){_invoke({action:"setNavigationTitle",param:param});};
  _setNavigationLeftTitle = function(param){_invoke({action:"setNavigationLeftTitle",param:param});};
  _goBack = function(){_invoke({action:"goBack"});};
  _closeWebView = function(){_invoke({action:"closeWebView"});};
  _telephone = function(param){_invoke({action:"telephone",param:param});};
  
  KaKaApp.init = function(){
  readyQueue = readyQueue || [];
  for (var i = 0; i < readyQueue.length; i++) {
  var func = readyQueue[i];
  func.call(window);
  }
  isReady = true;
  delete this.init;
  }
  KaKaApp.ready = function(func) {
  _ready(func);
  }
  KaKaApp.hideMenu = function() {
  _hideMenu();
  }
  KaKaApp.showMenu = function() {
  _showMenu();
  }
  KaKaApp.setTitle = function(title) {
  _setTitle(title);
  }
  KaKaApp.setShare = function(shareConfig) {
  _setShare(shareConfig);
  }
  KaKaApp.share = function(shareConfig) {
  _share(shareConfig);
  }
  KaKaApp.loginWithWechat = function(state) {
  _loginWithWechat(state);
  }
  
  KaKaApp.showNativePage = function(pageMessage) {
  _showNativePage(pageMessage);
  }
  
  KaKaApp.hideCloseButton = function() {
  
  _hideCloseButton();
  
  }
  
  KaKaApp.setUserInfo = function(userInfo) {
  
  _setUserInfo(userInfo);
  
  }
  
  KaKaApp.showAlert =  function(param)
  {
  _showAlert(param);
  }
  
  KaKaApp.showConfirm =  function(param)
  {
  _showConfirm(param);
  }
  
  KaKaApp.showPrompt =  function(param)
  {
  _showPrompt(param);
  }
  
  KaKaApp.showActionSheet = function(param)
  {
  _showActionSheet(param);
  }
  
  KaKaApp.vibrate = function()
  {
  _vibrate();
  }
  
  KaKaApp.showToast = function(param)
  {
  _showToast(param);
  }
  
  KaKaApp.showLoading = function(param)
  {
  _showLoading(param);
  }
  
  KaKaApp.hideLoading = function(param)
  {
  _hideLoading(param);
  }
  
  KaKaApp.getNetworkType = function(param)
  {
  _getNetworkType(param);
  }
  
  KaKaApp.checkInstallApps = function(param)
  {
  _checkInstallApps(param);
  }
  
  KaKaApp.launchApp = function(param)
  {
  _launchApp(param);
  }
  
  KaKaApp.openLink = function(param)
  {
  _openLink(param);
  }
  
  KaKaApp.previewImages = function(param)
  {
  _previewImages(param);
  }
  
  KaKaApp.setNavigationTitle = function(param)
  {
  _setNavigationTitle(param);
  }
  
  KaKaApp.setNavigationLeftTitle = function(param)
  {
  _setNavigationLeftTitle(param);
  }
  
  KaKaApp.goBack = function()
  {
  _goBack();
  }

  KaKaApp.closeWebView = function()
  {
  _closeWebView();
  }
  KaKaApp.telephone = function(param)
  {
  _telephone(param);
  }
  
  KaKaApp.pullToRefreshEnable = function()
  {
  _invoke({action:"pullToRefreshEnable"});
  }
  
  KaKaApp.pullToRefreshDisable = function()
  {
  _invoke({action:"pullToRefreshDisable"});
  }
  
  KaKaApp.pullToRefreshStop = function()
  {
  _invoke({action:"pullToRefreshStop"});
  }
  
  KaKaApp.webViewBounceEnable = function()
  {
  _invoke({action:"webViewBounceEnable"});
  }
  
  KaKaApp.webViewBounceDisable = function()
  {
  _invoke({action:"webViewBounceDisable"});
  }

}
  
)();
