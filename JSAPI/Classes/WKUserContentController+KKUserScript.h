//
//  WKUserContentController+KKUserScript.h
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "KKJSBridgeConfigInfo.h"

@interface WKUserContentController (KKUserScript)

- (void)removeUserScript;
- (void)installUserScript:(NSArray<KKJSInfo *>*)jsInfoList;

@end
