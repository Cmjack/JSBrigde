//
//  KKWebView.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWebView.h"
#import "WKUserContentController+KKUserScript.h"


@interface KKScriptMessage ()

@property (nonatomic, readwrite, copy) id body;
@property (nonatomic, readwrite, copy) NSString *name;

@end

@implementation KKScriptMessage

@end

@interface KKWebView ()<WKScriptMessageHandler>

@property(nonatomic,strong)KKJSBridgeConfigInfo *configInfo;
@property(nonatomic,strong)NSMutableURLRequest *request;

@end

@implementation KKWebView

+ (instancetype)webViewWithJSBridgeConfig:(KKJSBridgeConfigInfo*)config
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    // 默认为0
    configuration.preferences.minimumFontSize = 10;
    // 默认认为YES
    configuration.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能js自动通过窗口打开，需要通过用户交互才能打开窗口
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;

    configuration.userContentController =  [[WKUserContentController alloc] init];
    KKWebView *webView = [[KKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
    webView.configInfo = config;
    return webView;
}

- (void)removeUserScript
{
    [self.configuration.userContentController removeAllUserScripts];
    [self.configuration.userContentController removeScriptMessageHandlerForName:self.configInfo.scriptMessageHandlerName];
}

- (void)installUserScript
{
    [self.configuration.userContentController installUserScript:self.configInfo.JSBridgeConfigList];
    [self.configuration.userContentController addScriptMessageHandler:self name:self.configInfo.scriptMessageHandlerName];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([self.KKDelegate respondsToSelector:@selector(kkWebvView:didReceiveScriptMessage:)])
    {
        KKScriptMessage *kkScripeMessage = [KKScriptMessage new];
        kkScripeMessage.name = message.name;
        kkScripeMessage.body = [self dataFormJsonString:message.body];
        [self.KKDelegate kkWebvView:self didReceiveScriptMessage:kkScripeMessage];
    }
}

#pragma mark -

-(id)dataFormJsonString:(NSString *)jsonString
{
    if (!jsonString) {
        return nil;
    }
    id jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    return jsonObject;
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

- (void)nativeCallJS:(NSDictionary*)param
{
    NSString *jsStr = [NSString stringWithFormat:@"nativeCallJS(%@)",[self jsonStringFromData:param]];
    [self evaluateJavaScript:jsStr completionHandler:nil];
}

- (void)loadWebURL:(NSURL*)url
{
    _request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300.0];
    [self loadRequest:self.request];
}

#pragma mark - loadLocalHtml

- (void)loadLocalHtml:(NSString*)path
{
    if(path){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        } else {
            NSURL *fileURL = [self fileURLForWKWebView8:[NSURL fileURLWithPath:path]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self loadRequest:request];
        }
    }
}

//将文件copy到tmp目录
- (NSURL *)fileURLForWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}


@end
