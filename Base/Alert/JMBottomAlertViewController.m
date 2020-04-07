//
//  JMCenterAlertViewController.m
//  Test
//
//  Created by Liuny on 2019/9/26.
//  Copyright © 2019 Liuny. All rights reserved.
//

#import "JMBottomAlertViewController.h"
#import "JMAlertPresentationController.h"

@interface JMBottomAlertViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation JMBottomAlertViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initControl];
    [self initData];
}

-(void)initControl{
    
}

-(void)initData{
    
}

- (instancetype)initWithStoryboardName:(NSString *)storyboardName{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    if(self){
        //设置代理
        self.transitioningDelegate  = self;
        //设置为custom模式，才会走presentationControllerForPresentedViewController代理，从而设置半透明的背景
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.dismissWhenTapOutsideContentView = YES;
        self.maskViewAlpha = 0.5;
        
        self.view.backgroundColor = [UIColor clearColor];
        //添加点击隐藏手势
        UIView *tapView = [[UIView alloc] init];
        tapView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
        [tapView addGestureRecognizer:tapGester];

        [self.view insertSubview:tapView atIndex:0];
        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)tapDismiss{
    if(self.dismissWhenTapOutsideContentView){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    JMAlertPresentationController *presentController = [[JMAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentController.maskViewAlpha = self.maskViewAlpha;
    return presentController;
}
 
@end
