//
//  JMAlertPresentationController.m
//  Test
//
//  Created by Liuny on 2019/9/29.
//  Copyright © 2019 Liuny. All rights reserved.
//

#import "JMAlertPresentationController.h"

@interface JMAlertPresentationController ()
@property (nonatomic, strong) UIView *dimmingView;//用于黑色半透明背景
@end

@implementation JMAlertPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (void)presentationTransitionWillBegin{
    [super presentationTransitionWillBegin];
    {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.opaque = NO;
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.dimmingView = dimmingView;
        [self.containerView addSubview:dimmingView];
        
        // Get the transition coordinator for the presentation so we can
        // fade in the dimmingView alongside the presentation animation.
        id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
        
        self.dimmingView.alpha = 0.f;
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = self.maskViewAlpha;
        } completion:NULL];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    if (completed == NO){
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed == YES){
        self.dimmingView = nil;
    }
}

#pragma mark - layout(布局)
- (void)containerViewWillLayoutSubviews{
    [super containerViewWillLayoutSubviews];
    self.dimmingView.frame = self.containerView.bounds;
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    if (container == self.presentedViewController){
        [self.containerView setNeedsLayout];
    }
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize{
    if (container == self.presentedViewController){
        return ((UIViewController*)container).preferredContentSize;
    }else{
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

- (CGRect)frameOfPresentedViewInContainerView{
    return self.containerView.bounds;
}
@end
