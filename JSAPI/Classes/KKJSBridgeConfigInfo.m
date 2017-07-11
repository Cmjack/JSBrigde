//
//  KKJSBridgeConfigInfo.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/4.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKJSBridgeConfigInfo.h"

@interface KKJSBridgeConfigInfo ()

@property(nonatomic, strong) NSArray<NSString*> *loadJSBridgeDomainList;//加载JSBridge domain 列表
@property(nonatomic, strong) NSArray<NSString*> *domainWhiteList;//应用内打开的domain白名单
@property(nonatomic, strong) NSArray<KKJSInfo *> *JSBridgeConfigList;// JSBridge
@property(nonatomic, strong) NSString *scriptMessageHandlerName;//scripteName. default KaKa


@end

@implementation KKJSBridgeConfigInfo


+(instancetype)defaultJSBridgeConfigInfo
{
    KKJSBridgeConfigInfo *info = [[KKJSBridgeConfigInfo alloc]init];
    [info initData];
    return info;
}

+(instancetype)jsBridgeConfigInfo:(NSArray<NSString *>*)loadJSBridgeDomainList
                  domainWhiteList:(NSArray<NSString *>*)domainWhiteList
               JSBridgeConfigList:(NSArray<KKJSInfo*>*)JSBridgeConfigList
         scriptMessageHandlerName:(NSString*)scriptMessageHandlerName
{
    KKJSBridgeConfigInfo *info = [[KKJSBridgeConfigInfo alloc]init];
    info.loadJSBridgeDomainList = loadJSBridgeDomainList;
    info.domainWhiteList = domainWhiteList;
    info.JSBridgeConfigList = JSBridgeConfigList;
    info.scriptMessageHandlerName = scriptMessageHandlerName;
    return info;

}



- (void)initData{


    self.scriptMessageHandlerName = @"KaKa";
    self.domainWhiteList = @[@"https://s.kakatrip.cn",
                             @"https://btravel.kakatrip.cn",
                             @"https://btravel.kalv.mobi",
                             @"https://btravel-app.kalv.mobi",
                             @"https://btravel-app.kakatrip.cn",
                             @"https://h5.kalv.mobi",
                             @"https://h5.kakatrip.cn"];
    
    self.loadJSBridgeDomainList = @[@"https://btravel.kalv.mobi",
                                    @"https://btravel.kakatrip.cn",
                                    @"https://btravel-app.kalv.mobi",
                                    @"https://btravel-app.kakatrip.cn"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"KaKaJSBridge" ofType:@"js"];
    NSString *jsConfig = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *jsList = @[].mutableCopy;
    [jsList addObject: [KKJSInfo jsInfo:[NSString stringWithFormat:@"KaKaApp = %@;",[self JSData]] injectionTime:KKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [jsList addObject: [KKJSInfo jsInfo:jsConfig injectionTime:KKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [jsList addObject: [KKJSInfo jsInfo:@"KaKaApp.init();" injectionTime:KKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]];
    self.JSBridgeConfigList = jsList.copy;
}


- (NSString *)JSData
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setObject:@"iPhone" forKey:@"platform"];
    return [self jsonStringFromData:dict];
}

-(NSString *)jsonStringFromData:(id)data
{
    if (!data) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(BOOL)inLoadJSBridgeDomainListOfDomain:(NSString*)domain
{
    if (domain) {

        for (NSString *domain in self.loadJSBridgeDomainList)
        {
            NSRange range = [domain rangeOfString:domain];

            if (range.length>0)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)inWhiteDomainList:(NSString*)domain
{
    if (domain) {
        
        for (NSString *domain in self.domainWhiteList)
        {
            NSRange range = [domain rangeOfString:domain];
            
            if (range.length>0)
            {
                return YES;
            }
        }
    }
    return NO;

}

@end


@interface KKJSInfo ()

@property(nonatomic, strong) NSString *js;//js
@property(nonatomic, assign) KKUserScriptInjectionTime injectionTime;//js 加载的时机
@property(nonatomic, assign) BOOL forMainFrameOnly;

@end

@implementation KKJSInfo

-(instancetype)jsInfo:(NSString*)js injectionTime:(KKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly
{
    self.js = js;
    self.injectionTime = injectionTime;
    self.forMainFrameOnly = forMainFrameOnly;
    return self;
}

+(instancetype)jsInfo:(NSString*)js injectionTime:(KKUserScriptInjectionTime)injectionTime forMainFrameOnly:(BOOL)forMainFrameOnly
{
   return  [[[KKJSInfo alloc]init]jsInfo:js injectionTime:injectionTime forMainFrameOnly:forMainFrameOnly];
}


@end
