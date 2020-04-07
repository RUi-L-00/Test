//
//  JMBaseViewController.h
//  PLMMPRJK
//
//  Created by NJHu on 2017/3/29.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMNavigationBar.h"
#import "JMNavigationController.h"

@class JMNavUIBaseViewController;
@protocol JMNavUIBaseViewControllerDataSource <NSObject>

@optional
- (BOOL)navUIBaseViewControllerIsNeedNavBar:(JMNavUIBaseViewController *)navUIBaseViewController;
@end

@interface JMNavUIBaseViewController : UIViewController <JMNavigationBarDelegate, JMNavigationBarDataSource, JMNavUIBaseViewControllerDataSource>
/*默认的导航栏字体*/
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle;
/**  */
@property (weak, nonatomic) JMNavigationBar *jm_navgationBar;
@end
