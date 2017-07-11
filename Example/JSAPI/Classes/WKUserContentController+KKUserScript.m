//
//  WKUserContentController+KKUserScript.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "WKUserContentController+KKUserScript.h"

@implementation WKUserContentController (KKUserScript)

- (void)removeUserScript
{
    [self removeAllUserScripts];
}

- (void)installUserScript:(NSArray<KKJSInfo *>*)jsInfoList
{
    for (KKJSInfo *jsInfo in jsInfoList) {
        
        WKUserScriptInjectionTime injecttionTime = WKUserScriptInjectionTimeAtDocumentStart;
        
        if (jsInfo.injectionTime == KKUserScriptInjectionTimeAtDocumentEnd)
        {
            injecttionTime = WKUserScriptInjectionTimeAtDocumentEnd;
        }
        
        WKUserScript *script = [[WKUserScript alloc]initWithSource:jsInfo.js injectionTime:injecttionTime forMainFrameOnly:jsInfo.forMainFrameOnly];
        [self addUserScript:script];
    }
    
}

@end
