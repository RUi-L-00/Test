//
//  LLMJBBaseViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "JMBaseViewController.h"
#import "JMUMengHelper.h"

@interface JMBaseViewController ()

@end

@implementation JMBaseViewController

- (instancetype)initWithStoryboardName:(NSString *)storyboardName{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    JMLog(@"====self[%@]=====",[self class]);
    self = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorMain;
    self.automaticallyAdjustsScrollViewInsets = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearanceWhenContainedInInstancesOfClasses:@[[JMBaseViewController class]]] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    });
    [self initControl];
    [self initData];
}

-(void)initControl{
    
}

-(void)initData{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 配置友盟统计
    [JMUMengHelper beginLogPageViewName:self.title ?: self.navigationItem.title];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 配置友盟统计
    [JMUMengHelper endLogPageViewName:self.title ?: self.navigationItem.title];
}

- (void)dealloc
{
    JMLog(@"dealloc---%@", self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







