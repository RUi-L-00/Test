//
//  JMNavigationBar.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JMNavigationBar;
// 主要处理导航条
@protocol  JMNavigationBarDataSource<NSObject>

@optional

/**头部标题*/
- (NSMutableAttributedString*)jmNavigationBarTitle:(JMNavigationBar *)navigationBar;

/** 背景图片 */
- (UIImage *)jmNavigationBarBackgroundImage:(JMNavigationBar *)navigationBar;
 /** 背景色 */
- (UIColor *)jmNavigationBackgroundColor:(JMNavigationBar *)navigationBar;
/** 是否显示底部黑线 */
- (BOOL)jmNavigationIsHideBottomLine:(JMNavigationBar *)navigationBar;
/** 导航条的高度 */
- (CGFloat)jmNavigationHeight:(JMNavigationBar *)navigationBar;


/** 导航条的左边的 view */
- (UIView *)jmNavigationBarLeftView:(JMNavigationBar *)navigationBar;
/** 导航条右边的 view */
- (UIView *)jmNavigationBarRightView:(JMNavigationBar *)navigationBar;
/** 导航条中间的 View */
- (UIView *)jmNavigationBarTitleView:(JMNavigationBar *)navigationBar;
/** 导航条左边的按钮 */
- (UIImage *)jmNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(JMNavigationBar *)navigationBar;
/** 导航条右边的按钮 */
- (UIImage *)jmNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(JMNavigationBar *)navigationBar;
@end


@protocol JMNavigationBarDelegate <NSObject>

@optional
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(JMNavigationBar *)navigationBar;
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(JMNavigationBar *)navigationBar;
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(JMNavigationBar *)navigationBar;
@end


@interface JMNavigationBar : UIView

/** 底部的黑线 */
@property (weak, nonatomic) UIView *bottomBlackLineView;

/** 标题view */
@property (weak, nonatomic) UIView *titleView;

/** 左边view */
@property (weak, nonatomic) UIView *leftView;

/** 右边view */
@property (weak, nonatomic) UIView *rightView;

/** 标题（富文本） */
@property (nonatomic, copy) NSMutableAttributedString *title;

/** DataSource */
@property (weak, nonatomic) id<JMNavigationBarDataSource> dataSource;

/** 代理 */
@property (weak, nonatomic) id<JMNavigationBarDelegate> jmDelegate;

/** 背景图片 */
@property (weak, nonatomic) UIImage *backgroundImage;

@end
