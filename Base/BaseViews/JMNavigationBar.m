//
//  JMNavigationBar.m
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/31.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "JMNavigationBar.h"


#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kDefaultNavBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height + 44.0)

#define kSmallTouchSizeHeight 44.0

#define kLeftRightViewSizeMinWidth 60.0

#define kLeftMargin 0.0

#define kRightMargin 0.0

#define kNavBarCenterY(H) ((self.frame.size.height - kStatusBarHeight - H) * 0.5 + kStatusBarHeight)

#define kViewMargin 5.0

@implementation JMNavigationBar


#pragma mark - system

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupJMNavigationBarUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupJMNavigationBarUIOnce];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.superview bringSubviewToFront:self];
    
    self.leftView.frame = CGRectMake(0, kStatusBarHeight, self.leftView.mj_w, self.leftView.mj_h);
    
    self.rightView.frame = CGRectMake(self.mj_w - self.rightView.mj_w, kStatusBarHeight, self.rightView.mj_w, self.rightView.mj_h);
    
    self.titleView.frame = CGRectMake(0, kStatusBarHeight + (44.0 - self.titleView.mj_h) * 0.5, MIN(self.mj_w - MAX(self.leftView.mj_w, self.rightView.mj_w) * 2 - kViewMargin * 2, self.titleView.mj_w), self.titleView.mj_h);
    
    self.titleView.mj_x = (self.mj_w * 0.5 - self.titleView.mj_w * 0.5);
    
    self.bottomBlackLineView.frame = CGRectMake(0, self.mj_h, self.mj_w, 0.5);

}



#pragma mark - Setter
- (void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    [self addSubview:titleView];
    
    _titleView = titleView;
    
    __block BOOL isHaveTapGes = NO;
    
    [titleView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            
            isHaveTapGes = YES;
            
            *stop = YES;
        }
    }];
    
    if (!isHaveTapGes) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        
        [titleView addGestureRecognizer:tap];
    }
    
    
    [self layoutIfNeeded];
}




- (void)setTitle:(NSMutableAttributedString *)title
{
    // bug fix
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBarTitleView:)] && [self.dataSource jmNavigationBarTitleView:self]) {
        return;
    }
    
    /**头部标题*/
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.mj_w * 0.6, 44)];
    
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    navTitleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.titleView = navTitleLabel;
}


- (void)setLeftView:(UIView *)leftView
{
    [_leftView removeFromSuperview];
    
    [self addSubview:leftView];
    
    _leftView = leftView;
    
    
    if ([leftView isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)leftView;
        
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
    
}


- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    self.layer.contents = (id)backgroundImage.CGImage;
}



- (void)setRightView:(UIView *)rightView
{
    [_rightView removeFromSuperview];
    
    [self addSubview:rightView];
    
    _rightView = rightView;
    
    if ([rightView isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)rightView;
        
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
}



- (void)setDataSource:(id<JMNavigationBarDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self setupDataSourceUI];
}


#pragma mark - getter

- (UIView *)bottomBlackLineView
{
    if(!_bottomBlackLineView)
    {
        CGFloat height = 0.5;
        UIView *bottomBlackLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, height)];
        [self addSubview:bottomBlackLineView];
        _bottomBlackLineView = bottomBlackLineView;
        bottomBlackLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomBlackLineView;
}

#pragma mark - event

- (void)leftBtnClick:(UIButton *)btn
{
    if ([self.jmDelegate respondsToSelector:@selector(leftButtonEvent:navigationBar:)]) {
        
        [self.jmDelegate leftButtonEvent:btn navigationBar:self];
        
    }
    
}


- (void)rightBtnClick:(UIButton *)btn
{
    if ([self.jmDelegate respondsToSelector:@selector(rightButtonEvent:navigationBar:)]) {
        
        [self.jmDelegate rightButtonEvent:btn navigationBar:self];
        
    }
    
}


-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UILabel *view = (UILabel *)Tap.view;
    if ([self.jmDelegate respondsToSelector:@selector(titleClickEvent:navigationBar:)]) {
        
        [self.jmDelegate titleClickEvent:view navigationBar:self];
        
    }
}



#pragma mark - custom

- (void)setupDataSourceUI
{
    
    /** 导航条的高度 */
    
    if ([self.dataSource respondsToSelector:@selector(jmNavigationHeight:)]) {
        
        self.mj_size = CGSizeMake(kScreenWidth, [self.dataSource jmNavigationHeight:self]);
        
    }else
    {
        self.mj_size = CGSizeMake(kScreenWidth, kDefaultNavBarHeight);
    }
    
    /** 是否显示底部黑线 */
        if ([self.dataSource respondsToSelector:@selector(jmNavigationIsHideBottomLine:)]) {
    
            if ([self.dataSource jmNavigationIsHideBottomLine:self]) {
                self.bottomBlackLineView.hidden = YES;
            }
    
        }
    
    /** 背景图片 */
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBarBackgroundImage:)]) {
        
        self.backgroundImage = [self.dataSource jmNavigationBarBackgroundImage:self];
    }
    
    /** 背景色 */
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBackgroundColor:)]) {
        self.backgroundColor = [self.dataSource jmNavigationBackgroundColor:self];
    }
    
    
    /** 导航条中间的 View */
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBarTitleView:)]) {
        
        self.titleView = [self.dataSource jmNavigationBarTitleView:self];
        
    }else if ([self.dataSource respondsToSelector:@selector(jmNavigationBarTitle:)])
    {
        /**头部标题*/
        self.title = [self.dataSource jmNavigationBarTitle:self];
    }
    
    
    /** 导航条的左边的 view */
    /** 导航条左边的按钮 */
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBarLeftView:)]) {
        
        self.leftView = [self.dataSource jmNavigationBarLeftView:self];
        
    }else if ([self.dataSource respondsToSelector:@selector(jmNavigationBarLeftButtonImage:navigationBar:)])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSmallTouchSizeHeight, kSmallTouchSizeHeight)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIImage *image = [self.dataSource jmNavigationBarLeftButtonImage:btn navigationBar:self];
        
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        
        self.leftView = btn;
    }
    
    /** 导航条右边的 view */
    /** 导航条右边的按钮 */
    if ([self.dataSource respondsToSelector:@selector(jmNavigationBarRightView:)]) {
        
        self.rightView = [self.dataSource jmNavigationBarRightView:self];
        
    }else if ([self.dataSource respondsToSelector:@selector(jmNavigationBarRightButtonImage:navigationBar:)])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLeftRightViewSizeMinWidth, kSmallTouchSizeHeight)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIImage *image = [self.dataSource jmNavigationBarRightButtonImage:btn navigationBar:self];
        
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        
        self.rightView = btn;
    }
    
}


- (void)setupJMNavigationBarUIOnce
{
    self.backgroundColor = [UIColor whiteColor];
}


@end











