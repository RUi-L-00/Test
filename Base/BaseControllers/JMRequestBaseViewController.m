//
//  LMJRequestBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "JMRequestBaseViewController.h"

@interface JMRequestBaseViewController ()
@property (nonatomic, strong) Reachability *reachHost;

@end

@implementation JMRequestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reachHost];
}

#pragma mark - 加载框
- (void)showLoading
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dismissLoading
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#define kURL_Reachability__Address @"www.baidu.com"
#pragma mark - 监听网络状态
- (Reachability *)reachHost
{
    if(_reachHost == nil)
    {
        _reachHost = [Reachability reachabilityWithHostName:kURL_Reachability__Address];
        JMWeak(self);
        [_reachHost setUnreachableBlock:^(Reachability * reachability){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself networkStatus:reachability.currentReachabilityStatus inViewController:weakself];
            });
        }];
        
        [_reachHost setReachableBlock:^(Reachability * reachability){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself networkStatus:reachability.currentReachabilityStatus inViewController:weakself];
            });
        }];
        [_reachHost startNotifier];
    }
    return _reachHost;
}


#pragma mark - LMJRequestBaseViewControllerDelegate
- (void)networkStatus:(NetworkStatus)networkStatus inViewController:(JMRequestBaseViewController *)inViewController
{
    //判断网络状态
    switch (networkStatus) {
        case NotReachable:
            [JMProgressHelper toastInWindowWithMessage:kRequestFailure];
            break;
        case ReachableViaWiFi:
            JMLog(@"wifi上网2");
            break;
        case ReachableViaWWAN:
            JMLog(@"手机上网2");
            break;
        default:
            break;
    }
}


- (void)dealloc
{
    if ([self isViewLoaded]) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }
    [_reachHost stopNotifier];
    _reachHost = nil;
}

@end
