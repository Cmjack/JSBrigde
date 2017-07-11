//
//  KKWebView.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "KKJSBridgeConfigInfo.h"

@class KKWebView;
@class KKScriptMessage;

@protocol KKWebViewDelegate <NSObject>

@optional

- (void)kkWebvView:(KKWebView*)kkWebView didReceiveScriptMessage:(KKScriptMessage *)message;

@end

@interface KKWebView : WKWebView

@property(nonatomic,weak)id<KKWebViewDelegate>  KKDelegate;

+ (instancetype)webViewWithJSBridgeConfig:(KKJSBridgeConfigInfo*)config;
- (void)removeUserScript;
- (void)installUserScript;
- (void)loadLocalHtml:(NSString*)path;
- (void)loadWebURL:(NSURL*)url;
- (void)nativeCallJS:(NSDictionary*)param;

@end


@interface KKScriptMessage : NSObject
/*! @abstract The body of the message.
 @discussion Allowed types are NSNumber, NSString, NSDate, NSArray,
 NSDictionary, and NSNull.
 */
@property (nonatomic, readonly, copy) id body;

/*! @abstract The name of the message handler to which the message is sent.
 */
@property (nonatomic, readonly, copy) NSString *name;

@end
