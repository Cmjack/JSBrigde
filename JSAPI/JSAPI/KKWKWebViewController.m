//
//  KKWKWebViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/7/5.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWKWebViewController.h"
#import "KKWebView.h"
#import <KKRouter.h>
#import <KKProgressHUD.h>
#import "KKWKWebViewController+Device.h"

@interface KKWKWebViewController ()

<WKNavigationDelegate,
WKUIDelegate,
KKWebViewDelegate>

@property(nonatomic, strong)KKWebView *webView;
@property(nonatomic, strong)UIRefreshControl *refreshControl;
@property(nonatomic, strong)UIButton *backButton;

@end

@implementation KKWKWebViewController

#pragma mark -  life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @"false",@"HttpOnly",
                                                                  nil]];
    [self initSubviews];
    [self initNar];
    if (self.url) {
        
        [self.webView loadWebURL:self.url];
        
    }else if (self.path) {
        
        [self.webView loadLocalHtml:self.path];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.url && [self.jsBridgeConfigInfo inLoadJSBridgeDomainListOfDomain:self.url.host])
    {
        [self.webView installUserScript];
        
    }else if (self.path)
    {
        [self.webView installUserScript];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView removeUserScript];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
    if (self.progressView) {
        self.progressView.frame = CGRectMake(0, 64, self.view.frame.size.width, 2);
    }
}
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - on action

- (void)onRefreshAction
{
    [self callJS:@"startRefresh" param:@{@"startRefresh":@1}];
}

- (void)onBackBtnAction
{
    NSLog(@"%@",self.webView.backForwardList);
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else
    {
        [[KKRouter sharedInstance]popViewController];
    }
}

#pragma mark - telephone

- (void)telephone:(NSDictionary*)param
{
    NSString *mobile = param[@"mobile"];
    
    if (mobile&&mobile.length>0) {
        
        mobile = [mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableString * str= [NSMutableString string];
        
        if (![mobile hasPrefix:@"tel:"]) {
            
            [str appendFormat:@"tel:%@",mobile];
            
        }else
        {
            [str appendString:mobile];
        }
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
    
}

#pragma mark - Navtive call JS method

- (void)callJS:(NSString*)method param:(NSDictionary*)param
{
    NSMutableDictionary *md = @{}.mutableCopy;
    [md setObject:method forKey:@"action"];
    [md setObject:param forKey:@"param"];
    [self.webView nativeCallJS:md.copy];
}

#pragma mark - 进度条

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        NSLog(@"progress: %f", self.webView.estimatedProgress);
        if (self.progressView) {
            
            self.progressView.progress = self.webView.estimatedProgress;
            if (self.webView.estimatedProgress == 1.0)
            {
                [self performSelector:@selector(hiddenProgressView) withObject:nil afterDelay:0.5];
            }
        }
    }
}

- (void)hiddenProgressView
{
    self.progressView.progress = 0;
}


#pragma mark - init

- (void)initSubviews
{
    [self.view addSubview:self.webView];
    if (self.progressView) {
        [self.view addSubview:self.progressView];
    }
}

- (void)initNar
{
    UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    negativeSpacer.width = -10;//
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,backButtonItem, nil] animated:NO];
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationItem setLeftBarButtonItems:nil animated:NO];
    }
}

- (KKWebView*)webView
{
    if (!_webView) {
        
        _webView = [KKWebView webViewWithJSBridgeConfig:self.jsBridgeConfigInfo];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.KKDelegate = self;
        [_webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    }
    return _webView;
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(onRefreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}


- (UIButton*)backButton
{
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backButton addTarget:self action:@selector(onBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *imageForButton =  [UIImage imageNamed:self.leftButtonImage];
        [_backButton setImage:imageForButton forState:UIControlStateNormal];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        CGSize buttonTitleLabelSize = [@"取消" sizeWithAttributes:@{NSFontAttributeName:_backButton.titleLabel.font}]; //文本尺寸
        CGSize buttonImageSize = imageForButton.size;   //图片尺寸
        _backButton.frame = CGRectMake(0,0,
                                       buttonImageSize.width + buttonTitleLabelSize.width,
                                       buttonImageSize.height);
        
    }
    return _backButton;
}

@end


@implementation KKWKWebViewController (KKWebViewDelegate)

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{

}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    if (webView.title&&webView.title.length>0) {
        self.navigationItem.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [webView  evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        if (self.navigationItem.title == nil && result) {
            self.navigationItem.title = result;
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error
{
    if (error.code != -1009)
    {
        [KKProgressHUD showErrorAddTo:self.view message:@"加载失败,请稍后重试"];
        
    }else
    {
        [KKProgressHUD showErrorAddTo:self.view message:@"网络错误,请检查网络设置"];
    }
}

//在发送请求之前，决定是否跳转

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    BOOL isMainFrame = navigationAction.targetFrame.isMainFrame;
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme;
    
    if ([scheme isEqualToString:@"kakatrip"])
    {
        //        NSDictionary *dict = [url kakatripSchemeParam];
        //
        //        if ([self.delegate respondsToSelector:@selector(kkWebvView:didReceiveScriptMessage:)])
        //        {
        //            KKScriptMessage *kkScripeMessage = [KKScriptMessage new];
        //            kkScripeMessage.name = @"KaKaTrip";
        //            kkScripeMessage.body = dict;
        //            [self.delegate kkWebvView:self didReceiveScriptMessage:kkScripeMessage];
        //        }
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if ([scheme isEqualToString:@"https"]||[scheme isEqualToString:@"http"])
    {
            NSString *host = url.host;
            BOOL isAllow = [self.jsBridgeConfigInfo inWhiteDomainList:host];
        
            if (isMainFrame && !isAllow)
            {
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication]openURL:navigationAction.request.URL];

                }];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否打开第三方网页" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:cancelAction];
                [alertController addAction:conformAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            decisionHandler(isAllow?WKNavigationActionPolicyAllow:WKNavigationActionPolicyCancel);
        
    }else if ([scheme isEqualToString:@"tel"])
    {
        NSMutableDictionary *param = @{}.mutableCopy;
        [param setObject:url.absoluteString forKey:@"mobile"];
        [self telephone:param.copy];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if ([scheme isEqualToString:@"sms:"])
    {
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    NSLog(@"%@",frameInfo);
    
    if (![frameInfo isMainFrame]) {
        
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)kkWebvView:(KKWebView*)kkWebView didReceiveScriptMessage:(KKScriptMessage *)message
{
    NSString *methodName = message.name;
    NSDictionary *param = message.body;
    NSString *action = param[@"action"];
    NSLog(@"%@",methodName);
    NSLog(@"%@",param);
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
    
    if ([self respondsToSelector:NSSelectorFromString(action)])
    {
        [self performSelector:NSSelectorFromString(action) withObject:param[@"param"]];
        
    }else if ([self respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",action])])
    {
        [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"%@:",action]) withObject:param[@"param"]];
    }else
    {
        NSLog(@"需要子类去实现 sel %@ action", action);
    }
#pragma clang diagnostic pop
}

@end


@interface KKWKWebViewController (WebView)

- (void)pullToRefreshEnable;
- (void)pullToRefreshDisable;
- (void)webViewBounceEnable;
- (void)webViewBounceDisable;

@end

@implementation KKWKWebViewController (WebView)

- (void)pullToRefreshEnable
{
    [self.webView.scrollView addSubview:self.refreshControl];
}

- (void)pullToRefreshDisable
{
    [self.refreshControl removeFromSuperview];
}

- (void)pullToRefreshStop
{
    [self.refreshControl endRefreshing];
}

- (void)webViewBounceEnable
{
    self.webView.scrollView.bounces = YES;
}

- (void)webViewBounceDisable
{
    self.webView.scrollView.bounces = NO;
}

@end

@implementation KKWKWebViewController (Navigation)


- (void)setBackButtonTitle:(NSString*)title
{
    [self.backButton setTitle:title forState:UIControlStateNormal];
    CGSize buttonTitleLabelSize = [title sizeWithAttributes:@{NSFontAttributeName:_backButton.titleLabel.font}]; //文本尺寸
    
    UIImage *imageForButton =  [UIImage imageNamed:self.leftButtonImage];
    CGSize buttonImageSize = imageForButton.size;   //图片尺寸
    _backButton.frame = CGRectMake(0,0,
                                   buttonImageSize.width + buttonTitleLabelSize.width,
                                   buttonImageSize.height);
}

- (void)setNavigationTitle:(NSDictionary*)param
{
    NSString *title = param[@"title"];
    self.navigationItem.title = title;
}

- (void)setNavigationLeftTitle:(NSDictionary*)param
{
    NSString *title = param[@"title"];
    [self setBackButtonTitle:title];
}

- (void)setNavigationRightTitle:(NSDictionary*)param
{
    
}

- (void)goBack
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
        
    }else
    {
        [[KKRouter sharedInstance]popViewController];
    }
}

- (void)closeWebView
{
    [[KKRouter sharedInstance]popViewController];
}

@end
