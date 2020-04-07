//
//  JMTextViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/4/26.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//
#import "JMNavUIBaseViewController.h"

@class JMTextViewController;
@protocol JMTextViewControllerDataSource <NSObject>

@optional
- (UIReturnKeyType)textViewControllerLastReturnKeyType:(JMTextViewController *)textViewController;

- (BOOL)textViewControllerEnableAutoToolbar:(JMTextViewController *)textViewController;

//  控制是否可以点击点击的按钮
- (NSArray <UIButton *> *)textViewControllerRelationButtons:(JMTextViewController *)textViewController;

@end


@protocol JMTextViewControllerDelegate <UITextViewDelegate, UITextFieldDelegate>

@optional
#pragma mark - 最后一个输入框点击键盘上的完成按钮时调用
- (void)textViewController:(JMTextViewController *)textViewController inputViewDone:(id)inputView;
@end

@interface JMTextViewController : JMNavUIBaseViewController<JMTextViewControllerDataSource, JMTextViewControllerDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField NS_REQUIRES_SUPER;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string NS_REQUIRES_SUPER;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_REQUIRES_SUPER;
- (BOOL)textFieldShouldReturn:(UITextField *)textField NS_REQUIRES_SUPER;


@end




#pragma mark - design UITextField
IB_DESIGNABLE
@interface UITextField (JMTextViewController)

@property (assign, nonatomic) IBInspectable BOOL isEmptyAutoEnable;

@end


@interface JMTextViewControllerTextField : UITextField

@end





