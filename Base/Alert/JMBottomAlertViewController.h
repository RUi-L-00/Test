//
//  JMCenterAlertViewController.h
//  Test
//
//  Created by Liuny on 2019/9/26.
//  Copyright © 2019 Liuny. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBottomAlertViewController : UIViewController
///遮罩的透明度，默认0.5
@property (nonatomic, assign) CGFloat maskViewAlpha;

///点击contentView以外区域dismiss，默认为yes
@property (nonatomic, assign) BOOL dismissWhenTapOutsideContentView;

- (instancetype)initWithStoryboard;
- (instancetype)initWithStoryboardName:(NSString *)storyboardName;
- (void)initControl;
- (void)initData;
@end

NS_ASSUME_NONNULL_END
