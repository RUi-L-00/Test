//
//  JMTabBarController.m
//  JMBaseProject
//
//  Created by liuny on 2018/7/14.
//  Copyright © 2018年 liuny. All rights reserved.
//

#import "JMTabBarController.h"
#import "UserCenterMainVC.h"
#import "GiftVC.h"
@interface JMTabBarController ()

@end

@implementation JMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControl];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControl{
    //未选中的字体颜色
    UIColor *colorUnselect = [UIColor colorWithHexString:@"#222222"];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:colorUnselect} forState:UIControlStateNormal];
    //选中的字体颜色
    UIColor *colorSelect = [UIColor colorWithHexString:@"#222222"];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:colorSelect} forState:UIControlStateSelected];
    //设置不透明
    self.tabBar.translucent = NO;
    //设置背景颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //设置背景图片
    [self.tabBar setBackgroundImage:nil];
    //设置阴影图
    [self.tabBar setShadowImage:nil];
}

-(void)initData{
    [self setupViewControllers];
}

//设置选中与未选中的图标
-(void)setupBarItem:(UITabBarItem *)item normalImageName:(NSString *)normalName selectImageName:(NSString *)selectName{
    UIImage *imageSelected = [UIImage imageNamed:selectName];
    UIImage *imageNormal = [UIImage imageNamed:normalName];
    item.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)setupViewControllers{
    

     NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
     HomeVC *vc1 = [[HomeVC alloc] initWithStoryboard];
     JMNavigationController *nav1 = [[JMNavigationController alloc] initWithRootViewController:vc1];
     [self setupBarItem:nav1.tabBarItem normalImageName:@"Tab1" selectImageName:@"Tab1_Select"];
     [nav1.tabBarItem setTitle:@"主页"];
     [viewControllers addObject:nav1];
     
     GiftVC *vc2 = [[GiftVC alloc] initWithStoryboardName:@"Gift"];
     JMNavigationController *nav2 = [[JMNavigationController alloc] initWithRootViewController:vc2];
     [self setupBarItem:nav2.tabBarItem normalImageName:@"Tab2" selectImageName:@"Tab2_Select"];
     [nav2.tabBarItem setTitle:@"礼品兑换"];
     [viewControllers addObject:nav2];
//
     ShoppingCartVC *vc3 = [[ShoppingCartVC alloc] initWithStoryboard];
     JMNavigationController *nav3 = [[JMNavigationController alloc] initWithRootViewController:vc3];
     [self setupBarItem:nav3.tabBarItem normalImageName:@"Tab3" selectImageName:@"Tab3_Select"];
     [nav3.tabBarItem setTitle:@"购物车"];
     [viewControllers addObject:nav3];
//
    NoticeVC *vc4 = [[NoticeVC alloc] initWithStoryboard];
    JMNavigationController *nav4 = [[JMNavigationController alloc] initWithRootViewController:vc4];
    [self setupBarItem:nav4.tabBarItem normalImageName:@"Tab4" selectImageName:@"Tab4_Select"];
    [nav4.tabBarItem setTitle:@"消息"];
    [viewControllers addObject:nav4];
    
     UserCenterMainVC *vc5 = [[UserCenterMainVC alloc] initWithStoryboardName:@"UserCenter"];
     JMNavigationController *nav5 = [[JMNavigationController alloc] initWithRootViewController:vc5];
     [self setupBarItem:nav5.tabBarItem normalImageName:@"Tab5" selectImageName:@"Tab5_Select"];
     [nav5.tabBarItem setTitle:@"我的"];
     [viewControllers addObject:nav5];
     
     self.viewControllers = viewControllers;
}
@end
