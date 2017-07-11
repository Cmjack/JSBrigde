//
//  KKJSBridgeConfigInfo.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/4.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    KKUserScriptInjectionTimeAtDocumentStart,
    KKUserScriptInjectionTimeAtDocumentEnd,
} KKUserScriptInjectionTime;

@class KKJSInfo;

@interface KKJSBridgeConfigInfo : NSObject

@property(nonatomic, readonly) NSArray<NSString *> *loadJSBridgeDomainList;//加载JSBridge domain 列表
@property(nonatomic, readonly) NSArray<NSString *> *domainWhiteList;//应用内打开的domain白名单
@property(nonatomic, readonly) NSArray<KKJSInfo *> *JSBridgeConfigList;// JSBridge
@property(nonatomic, readonly) NSString *scriptMessageHandlerName;//scripteName. default KaKa

//默认
+(instancetype)defaultJSBridgeConfigInfo;

//自定义
+(instancetype)jsBridgeConfigInfo:(NSArray<NSString *>*)loadJSBridgeDomainList
                  domainWhiteList:(NSArray<NSString *>*)domainWhiteList
               JSBridgeConfigList:(NSArray<KKJSInfo*>*)JSBridgeConfigList
         scriptMessageHandlerName:(NSString*)scriptMessageHandlerName;

-(BOOL)inLoadJSBridgeDomainListOfDomain:(NSString*)domain;
-(BOOL)inWhiteDomainList:(NSString*)domain;

@end


@interface KKJSInfo : NSObject

@property(nonatomic, readonly) NSString *js;//js
@property(nonatomic, readonly) KKUserScriptInjectionTime injectionTime;//js 加载的时机
@property(nonatomic, readonly) BOOL forMainFrameOnly;

+(instancetype)jsInfo:(NSString*)js injectionTime:(KKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly;

@end
