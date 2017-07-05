//
//  KKWebViewBridge.h
//  kakatrip
//
//  Created by CaiMing on 2016/12/29.
//  Copyright © 2016年 kakatrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>



@class KKWebViewBridge;
@class KKScriptMessage;

@protocol KKWebViewBridgeDelegate <NSObject>

@optional

- (void)kkWebvView:(KKWebViewBridge*)kkWebView webViewTitle:(NSString *)title;
- (void)kkWebvView:(KKWebViewBridge*)kkWebView documentTitle:(NSString *)title;
- (void)kkWebvView:(KKWebViewBridge*)kkWebView didReceiveScriptMessage:(KKScriptMessage *)message;

@end

@interface KKWebViewBridge : UIView

@property(nonatomic,weak)id<KKWebViewBridgeDelegate> delegate;
@property(nonatomic, readonly)WKWebView *webView;
@property(nonatomic,copy)NSURL *url;
@property (nonatomic, readonly) BOOL canGoBack;
@property(nonatomic, strong) NSArray *loadJSBridge;
@property(nonatomic, strong) NSString *JSBridgeConfig;


- (void)goBack;
- (void)setProgressColor:(UIColor*)color;
- (void)installUserScript:(NSString*)js;
- (void)removeUserScript;
- (void)reload;

@end

//@interface KKScriptMessage : NSObject
///*! @abstract The body of the message.
// @discussion Allowed types are NSNumber, NSString, NSDate, NSArray,
// NSDictionary, and NSNull.
// */
//@property (nonatomic, readonly, copy) id body;
//
///*! @abstract The name of the message handler to which the message is sent.
// */
//@property (nonatomic, readonly, copy) NSString *name;
//
//@end
