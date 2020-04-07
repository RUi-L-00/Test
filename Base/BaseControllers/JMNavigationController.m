//
//  JMNavigationController.m
//  JMBaseProject
//
//  Created by liuny on 2018/7/14.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "JMNavigationController.h"

@interface JMNavigationController ()

@end

@implementation JMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControl{
    self.navigationBar.hidden = YES;
    // 不让自控制器控制系统导航条
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count != 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
@end
