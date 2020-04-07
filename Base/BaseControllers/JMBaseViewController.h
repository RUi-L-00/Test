//
//  LLMJBBaseViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/11.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMRequestBaseViewController.h"


@interface JMBaseViewController : JMRequestBaseViewController
-(instancetype)initWithStoryboard;
//仅用于子类initWithStoryboard方法中，不可外用
- (instancetype)initWithStoryboardName:(NSString *)storyboardName;
//子类重写用于处理控件初始化属性
-(void)initControl;
//子类重写用于处理初始化数据
-(void)initData;
@end
