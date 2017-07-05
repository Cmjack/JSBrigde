//
//  KKWebViewController.m
//  JSAPI
//
//  Created by CaiMing on 2017/6/16.
//  Copyright © 2017年 CaiMing. All rights reserved.
//

#import "KKWebViewController.h"
#import "KKWebViewBridge.h"
#import <KKRouter/KKRouter.h>
#import "KKWebViewController+Device.h"



@interface KKWebViewController ()<KKWebViewBridgeDelegate>

@property(nonatomic, strong)KKWebViewBridge *webView;
@property(nonatomic, strong)UIButton *backButton;
@property(nonatomic, strong)UIRefreshControl *refreshControl;

@end

@implementation KKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftButtonImage = @"blue_arrow_back";
    [self initSubviews];
    [self initNar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"xx" style:UIBarButtonItemStyleDone target:self action:@selector(onRightButtonAction)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRightButtonAction
{

}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView removeUserScript];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.webView installUserScript:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

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

- (void)onBackBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRefreshAction
{
    [self callJS:@"startRefresh" param:@{@"startRefresh":@1}];
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


- (UIImage *)createImageWithColor:(UIColor *)color;
{
    return [self createImageWithColor:color withSize:CGSizeMake(1, 1)];
}

- (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)callJS:(NSString*)method param:(NSDictionary*)param
{
    NSMutableDictionary *md = @{}.mutableCopy;
    [md setObject:method forKey:@"action"];
    [md setObject:param forKey:@"param"];
    NSString *jsStr = [NSString stringWithFormat:@"callJS(%@)",[self jsonStringFromData:md]];
    [self.webView.webView evaluateJavaScript:jsStr completionHandler:nil];
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


#pragma mark - initSubviews

- (void)initSubviews
{
    [self.view addSubview:self.webView];
    self.webView.frame = [UIScreen mainScreen].bounds;
}

- (KKWebViewBridge *)webView
{
    if (!_webView) {
        
        _webView = [[KKWebViewBridge alloc]init];
        _webView.delegate = self;
        _webView.url = self.url;
    }
    return _webView;
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

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(onRefreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}


@end


@implementation KKWebViewController (KKWebViewBridgeDelegate)

- (void)kkWebvView:(KKWebViewBridge *)kkWebView didReceiveScriptMessage:(KKScriptMessage *)message
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
    }
#pragma clang diagnostic pop

}

- (void)kkWebvView:(KKWebViewBridge *)kkWebView webViewTitle:(NSString *)title
{
    if (title&&title.length>0) {
        
        self.navigationItem.title = title;
    }
}

- (void)kkWebvView:(KKWebViewBridge *)kkWebView documentTitle:(NSString *)title
{
    if (title&&self.navigationItem.title == nil)
    {
        self.navigationItem.title = title;
    }
}

@end


@interface KKWebViewController (WebView)

- (void)pullToRefreshEnable;
- (void)pullToRefreshDisable;
- (void)webViewBounceEnable;
- (void)webViewBounceDisable;

@end

@implementation KKWebViewController (WebView)

- (void)pullToRefreshEnable
{
    [self.webView.webView.scrollView addSubview:self.refreshControl];
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
    self.webView.webView.scrollView.bounces = YES;
}

- (void)webViewBounceDisable
{
    self.webView.webView.scrollView.bounces = NO;
}

@end


@implementation KKWebViewController (Navigation)

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

- (void)navigationGoBack
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
        
    }else
    {
        [[KKRouter sharedInstance]popViewController];
    }
}

- (void)navigationClose
{
    [[KKRouter sharedInstance]popViewController];
}


@end
