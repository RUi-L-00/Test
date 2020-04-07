//
//  JMCenterAlertViewController.m
//  Test
//
//  Created by Liuny on 2019/9/27.
//  Copyright © 2019 Liuny. All rights reserved.
//

#import "JMCenterAlertViewController.h"
#import "JMAlertPresentationController.h"
#import "Masonry.h"


@interface JMCenterAlertViewController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@end

@implementation JMCenterAlertViewController
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
        self.view.backgroundColor = [UIColor clearColor];
        //设置代理
        self.transitioningDelegate  = self;
        //设置为custom模式，才会走presentationControllerForPresentedViewController代理，从而设置半透明的背景
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.dismissWhenTapOutsideContentView = YES;
        self.maskViewAlpha = 0.5;
        
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

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{

    return [transitionContext isAnimated] ? 0.35 : 0;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation (will have no effect on dismissal because the
    // presenting view controller's view was not removed).
    [containerView addSubview:toView];
    
    if (isPresenting) {
        toView.alpha = 0.f;
        
        // This animation only affects the alpha.  The views can be set to
        // their final frames now.
        fromView.frame = [transitionContext finalFrameForViewController:fromViewController];
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
    } else {
        // Because our presentation wraps the presented view controller's view
        // in an intermediate view hierarchy, it is more accurate to rely
        // on the current frame of fromView than fromViewInitialFrame as the
        // initial frame.
        toView.frame = [transitionContext finalFrameForViewController:toViewController];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting)
            toView.alpha = 1.f;
        else
            fromView.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition
        // finished or not.
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
        
        // Reset the alpha of the dismissed view, in case it will be used
        // elsewhere in the app.
        if (isPresenting == NO)
            fromView.alpha = 1.f;
    }];
}


#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    JMAlertPresentationController *presentController = [[JMAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentController.maskViewAlpha = self.maskViewAlpha;
    return presentController;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}


@end
