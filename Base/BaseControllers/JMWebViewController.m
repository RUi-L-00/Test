//
//  JMWebViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/4/9.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "JMWebViewController.h"
@interface JMWebViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIProgressView *progressView;

/** <#digest#> */
@property (strong, nonatomic) UIButton *backBtn;

/** <#digest#> */
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation JMWebViewController

- (void)setGotoURL:(NSString *)gotoURL {
//    @"`#%^{}\"[]|\\<> "   最后有一位空格
    _gotoURL = [gotoURL stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        if (@available(iOS 11.0, *)){
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
        contentInset.top += self.jm_navgationBar.mj_h;
        self.webView.scrollView.contentInset = contentInset;
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    }
    
    JMWeak(self);
    [self.webView addObserverBlockForKeyPath:JMKeyPath(weakself.webView, estimatedProgress) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        weakself.progressView.progress = weakself.webView.estimatedProgress;
        // 加载完成
        if (weakself.webView.estimatedProgress  >= 1.0f ) {
            
            [UIView animateWithDuration:0.25f animations:^{
                weakself.progressView.alpha = 0.0f;
                weakself.progressView.progress = 0.0f;
            }];
            
        }else{
            weakself.progressView.alpha = 1.0f;
        }
        
    }];
    
    [self.webView addObserverBlockForKeyPath:JMKeyPath(self.webView, title) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        
        if (!JMIsEmpty(newVal) && [newVal isKindOfClass:[NSString class]] && [self webViewController:self webViewIsNeedAutoTitle:self.webView]) {
            weakself.title = newVal;
        }
        
    }];
    
    
    [self.webView.scrollView addObserverBlockForKeyPath:JMKeyPath(self.webView.scrollView, contentSize) block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakself webView:weakself.webView scrollView:weakself.webView.scrollView contentSize:weakself.webView.scrollView.contentSize];
    }];
    
    if (self.gotoURL.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.gotoURL]]];
    }else if (!JMIsEmpty(self.contentHTML)) {
        [self.webView loadHTMLString:self.contentHTML baseURL:nil];
    }
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.progressView];
}

/*
#pragma mark - JMNavUIBaseViewControllerDataSource
#pragma mark - 设置左上角的一个返回按钮和一个关闭按钮
- (UIView *)jmNavigationBarLeftView:(JMNavigationBar *)navigationBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    
    self.backBtn.mj_origin = CGPointZero;
    
    self.closeBtn.mj_x = self.backBtn.mj_w;
    
    [leftView addSubview:self.backBtn];
    
    [leftView addSubview:self.closeBtn];
    
    return leftView;
}



- (void)leftButtonEvent:(UIButton *)sender navigationBar:(JMNavigationBar *)navigationBar
{
    [self backBtnClick:sender webView:self.webView];
}

- (void)left_close_button_event:(UIButton *)sender
{
    [self closeBtnClick:sender webView:self.webView];
}*/


#pragma mark - LMJWebViewControllerDataSource
// 默认需要, 是否需要进度条
- (BOOL)webViewController:(JMWebViewController *)webViewController webViewIsNeedProgressIndicator:(WKWebView *)webView
{
    return YES;
}

// 默认需要自动改变标题
- (BOOL)webViewController:(JMWebViewController *)webViewController webViewIsNeedAutoTitle:(WKWebView *)webView
{
    return YES;
}


#pragma mark - LMJWebViewControllerDelegate
// 导航条左边的返回按钮的点击
- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView
{
    if (self.webView.canGoBack) {
        self.closeBtn.hidden = NO;
        [self.webView goBack];
    }else
    {
        [self closeBtnClick:self.closeBtn webView:self.webView];
    }
}

// 关闭按钮的点击
- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView {
    // 判断两种情况: push 和 present
    if ((self.navigationController.presentedViewController || self.navigationController.presentingViewController) && self.navigationController.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
- (void)webView:(WKWebView *)webView scrollView:(UIScrollView *)scrollView contentSize:(CGSize)contentSize
{
    NSLog(@"%@\n%@\n%@", webView, scrollView, NSStringFromCGSize(contentSize));
}

#pragma mark - webDelegate

// 1, 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"decidePolicyForNavigationAction   ====    %@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// 2开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"didStartProvisionalNavigation   ====    %@", navigation);
    
}


// 4, 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 5,内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"didCommitNavigation   ====    %@", navigation);
}

// 3, 6, 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        if ([challenge previousFailureCount] == 0) {
//
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
//        } else {
//
//            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//        }
//    } else {
//
//        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
//    }
}

// 7页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didFinishNavigation   ====    %@", navigation);
    
}

// 8页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
    [JMProgressHelper toastInView:self.view message:@"网页加载失败"];
}

//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
    NSLog(@"webViewWebContentProcessDidTerminate");
}

#pragma mark - 懒加载

- (WKWebView *)webView
{
    if(_webView == nil)
    {
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 检测各种特殊的字符串：比如电话、网站
        config.dataDetectorTypes = UIDataDetectorTypeAll;
        // 播放视频
        config.allowsInlineMediaPlayback = YES;

        // 交互对象设置
//        config.userContentController = [[WKUserContentController alloc] init];
        
        //自己添加(修改字体过小)
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        config.userContentController = wkUController;
        
        
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        [self.view insertSubview:webView atIndex:0];
        _webView = webView;
        
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        //滑动返回看这里
        webView.allowsBackForwardNavigationGestures = YES;
        webView.allowsLinkPreview = YES;
    }
    return _webView;
}


- (UIProgressView *)progressView
{
    if(_progressView == nil && [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        
        [self.view addSubview:progressView];
        
        _progressView = progressView;
        
        progressView.mj_h = 1;
        
        progressView.mj_w = kScreenWidth;
        
        progressView.mj_y = self.jm_navgationBar.mj_h;
        progressView.tintColor = [UIColor greenColor];
        
        if ([self respondsToSelector:@selector(webViewController:webViewIsNeedProgressIndicator:)]) {
            if (![self webViewController:self webViewIsNeedProgressIndicator:self.webView]) {
                progressView.hidden = YES;
            }
        }
        
    }
    return _progressView;
}


- (UIButton *)backBtn
{
    if(_backBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"NavigationBack"] forState:UIControlStateNormal];
        
        btn.mj_size = CGSizeMake(34, 44);
        
        [btn addTarget:self action:@selector(leftButtonEvent:navigationBar:) forControlEvents:UIControlEventTouchUpInside];
        
        _backBtn = btn;
    }
    return _backBtn;
}

- (UIButton *)closeBtn
{
    return nil;
    if(_closeBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"NavigationClose"] forState:UIControlStateNormal];
//        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        btn.mj_size = CGSizeMake(44, 44);
        
//        btn.hidden = YES;
        
        [btn addTarget:self action:@selector(left_close_button_event:) forControlEvents:UIControlEventTouchUpInside];
        
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (void)dealloc
{
    NSLog(@"LMJWebViewController -- dealloc");
    
    [_webView.scrollView removeObserverBlocks];
    [_webView removeObserverBlocks];
    
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    _webView.scrollView.delegate = nil;
}


@end



// UIWebView 使用的权限认证方式，
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if ([navigationAction.request.URL.absoluteString containsString:@"https://"] && IOSVersion < 9.0 && !self.httpsAuth) {
//        self.originRequest = navigationAction.request;
//        self.httpsUrlConnection = [[NSURLConnection alloc] initWithRequest:self.originRequest delegate:self];
//        [self.httpsUrlConnection start];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge previousFailureCount] == 0) {
//        self.httpsAuth = YES;
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//    } else {
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    self.httpsAuth = YES;
//    [self.webView loadRequest:self.originRequest];
//    [self.httpsUrlConnection cancel];
//}
//
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}


