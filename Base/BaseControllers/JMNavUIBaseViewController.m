//
//  JMBaseViewController.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "JMNavUIBaseViewController.h"
#import "JMNavigationBar.h"

@implementation JMNavUIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    JMWeak(self);
    [self.navigationItem addObserverBlockForKeyPath:JMKeyPath(self.navigationItem, title) block:^(id  _Nonnull obj, id  _Nonnull oldVal, NSString  *_Nonnull newVal) {
        if (newVal.length > 0 && ![newVal isEqualToString:oldVal]) {
            weakself.title = newVal;
        }
    }];
}


#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.jm_navgationBar.mj_w = self.view.mj_w;
    [self.view bringSubviewToFront:self.jm_navgationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self.navigationItem removeObserverBlocksForKeyPath:JMKeyPath(self.navigationItem, title)];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - DataSource
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(JMNavUIBaseViewController *)navUIBaseViewController {
    return YES;
}

/**头部标题*/
- (NSMutableAttributedString*)jmNavigationBarTitle:(JMNavigationBar *)navigationBar {
    return [self changeTitle:self.title ?: self.navigationItem.title];
}

/** 背景图片 */
//- (UIImage *)jmNavigationBarBackgroundImage:(JMNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
- (UIColor *)jmNavigationBackgroundColor:(JMNavigationBar *)navigationBar {
    return kColorMain;
}

//* 是否显示底部黑线
- (BOOL)jmNavigationIsHideBottomLine:(JMNavigationBar *)navigationBar
{
    return YES;
}

/** 导航条的高度 */
- (CGFloat)jmNavigationHeight:(JMNavigationBar *)navigationBar {
    return [UIApplication sharedApplication].statusBarFrame.size.height + 44.0;
}


/** 导航条的左边的 view */
//- (UIView *)jmNavigationBarLeftView:(JMNavigationBar *)navigationBar
//{
//
//}
/** 导航条右边的 view */
//- (UIView *)jmNavigationBarRightView:(JMNavigationBar *)navigationBar
//{
//
//}
/** 导航条中间的 View */
//- (UIView *)jmNavigationBarTitleView:(JMNavigationBar *)navigationBar
//{
//
//}
/** 导航条左边的按钮 */
- (UIImage *)jmNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(JMNavigationBar *)navigationBar
{
    return [UIImage imageNamed:@"back"];
}
/** 导航条右边的按钮 */
//- (UIImage *)jmNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(JMNavigationBar *)navigationBar
//{
//
//}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(JMNavigationBar *)navigationBar {
    [self.navigationController popViewControllerAnimated:YES];
    JMLog(@"%s", __func__);
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(JMNavigationBar *)navigationBar {
    JMLog(@"%s", __func__);
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(JMNavigationBar *)navigationBar {
    JMLog(@"%s", __func__);
}


#pragma mark 自定义代码

- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:kColorNavigationTint range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kFontSizeNavigation] range:NSMakeRange(0, title.length)];
    
    return title;
}


- (JMNavigationBar *)jm_navgationBar {
    // 父类控制器必须是导航控制器
    if(!_jm_navgationBar && [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        JMNavigationBar *navigationBar = [[JMNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        [self.view addSubview:navigationBar];
        _jm_navgationBar = navigationBar;
        
        navigationBar.dataSource = self;
        navigationBar.jmDelegate = self;
        navigationBar.hidden = ![self navUIBaseViewControllerIsNeedNavBar:self];
    }
    return _jm_navgationBar;
}




- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.jm_navgationBar.title = [self changeTitle:title];
}

@end






