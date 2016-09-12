//
//  SIPopoverRootViewController.m
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import "SIPopoverRootViewController.h"
#import "SIPopoverAnimator.h"


@interface SIPopoverTransition : NSObject <UINavigationBarDelegate, UIViewControllerTransitioningDelegate>

- (instancetype)initWithDuration:(NSTimeInterval)duration;

@property (nonatomic) NSTimeInterval duration;

@end

@implementation SIPopoverTransition

- (instancetype)initWithDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _duration = duration;
    }
    return self;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    SIPopoverAnimator *animator = [[SIPopoverAnimator alloc] init];
    animator.operation = operation;
    animator.duration = self.duration;
    return animator;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [self animatorWithPresentation:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [self animatorWithPresentation:NO];
}

- (SIPopoverAnimator *)animatorWithPresentation:(BOOL)presentation
{
    SIPopoverAnimator *animator = [[SIPopoverAnimator alloc] init];
    animator.presentation = presentation;
    animator.duration = self.duration;
    return animator;
}

@end

static NSString * const PreferredContentSizeKeyPath = @"preferredContentSize";

@interface SIPopoverRootViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) SIPopoverTransition *transition;

@end

@implementation SIPopoverRootViewController

- (void)dealloc
{
    [self.contentViewController removeObserver:self forKeyPath:PreferredContentSizeKeyPath context:nil];
    if (self.didFinishedHandler) {
        self.didFinishedHandler(self);
    }
}

- (instancetype)initWithContentViewController:(UIViewController *)rootViewController
{
    if (self = [super init]) {
        _contentViewController = rootViewController;
        self.modalPresentationStyle = UIModalPresentationCustom;
        _transition = [[SIPopoverTransition alloc] initWithDuration:0.3];
        self.transitioningDelegate = _transition;
        [_contentViewController addObserver:self forKeyPath:PreferredContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.transition.duration = duration;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.dimView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    switch (self.backgroundEffect) {
        case SIPopoverBackgroundEffectNone:
            self.dimView.backgroundColor = [UIColor clearColor];
            break;
        case SIPopoverBackgroundEffectDarken:
            self.dimView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
        case SIPopoverBackgroundEffectLighten:
            self.dimView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            break;
            
        default:
            NSLog(@"Warnning: undefine background effect");
            break;
    }
    
    [self.view addSubview:self.dimView];
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerView.autoresizesSubviews = NO;
    [self.view addSubview:self.containerView];
    
    [self addChildViewController:self.contentViewController];
    [self.containerView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    [self setupContentView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundHandler:)];
    tapGesture.delegate = self;
    [self.containerView addGestureRecognizer:tapGesture];
}

- (void)setupContentView
{
    CGSize size = [self.contentViewController preferredContentSize];
    
    UIView *contentView = self.contentViewController.view;
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *horizontalCenterConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:contentView.superview
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.0
                                                                                   constant:0];
    [contentView.superview addConstraint:horizontalCenterConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                           toItem:nil
                                                                        attribute:0
                                                                       multiplier:1.0
                                                                         constant:size.height];
    [contentView addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:0
                                                                      multiplier:1.0
                                                                        constant:size.width];
    [contentView addConstraint:widthConstraint];
    switch (self.gravity) {
        case SIPopoverGravityNone:{
            NSLayoutConstraint *verticalCenterConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                        attribute:NSLayoutAttributeCenterY
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:contentView.superview
                                                                                        attribute:NSLayoutAttributeCenterY
                                                                                       multiplier:1
                                                                                         constant:0];
            
            [contentView.superview addConstraint:verticalCenterConstraint];
        }
            break;
        case SIPopoverGravityBottom: {
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:contentView.superview
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1
                                                                                 constant:0];
            
            [contentView.superview addConstraint:bottomConstraint];
        }
            break;
        case SIPopoverGravityTop: {
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:contentView.superview
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1
                                                                              constant:0];
            
            [contentView.superview addConstraint:topConstraint];
        }
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.contentViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.contentViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.contentViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.contentViewController viewDidDisappear:animated];
}

#pragma mark - Gesture

- (void)tapBackgroundHandler:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    if (!CGRectContainsPoint(self.contentViewController.view.frame, location)) {
        if (self.tapBackgroundToDissmiss) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return touch.view == self.containerView;
}

#pragma mark - Transition

- (void)transitionInCompletion:(void (^)(BOOL finished))completion
{
    UIView *contentView = self.contentViewController.view;
    CGFloat containerHeight = CGRectGetHeight(contentView.bounds);
    switch (self.transitionStyle) {
        case SIPopoverTransitionStyleSlideFromTop:
        {
            contentView.transform = CGAffineTransformMakeTranslation(0, -containerHeight);
            [UIView animateWithDuration:self.duration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 contentView.transform = CGAffineTransformIdentity;
                             }
                             completion:completion];
        }
            break;
        case SIPopoverTransitionStyleSlideFromBottom:
        {
            contentView.transform = CGAffineTransformMakeTranslation(0, containerHeight);
            [UIView animateWithDuration:self.duration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 contentView.transform = CGAffineTransformIdentity;
                             }
                             completion:completion];
        }
            break;
        case SIPopoverTransitionStyleBounce:
        {
            contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            contentView.alpha = 0;
            [UIView animateWithDuration:self.duration
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 contentView.transform = CGAffineTransformIdentity;
                                 contentView.alpha = 1;
                             }
                             completion:completion];
        }
            break;
    }
    
    self.dimView.alpha = 0;
    [UIView animateWithDuration:self.duration
                     animations:^{
                         self.dimView.alpha = 1;
                     }];
}

- (void)transitionOutCompletion:(void (^)(BOOL finished))completion
{
    UIView *contentView = self.contentViewController.view;
    switch (self.transitionStyle) {
        case SIPopoverTransitionStyleSlideFromTop:
        {
            [UIView animateWithDuration:self.duration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CGRect rect = contentView.frame;
                                 rect.origin.y = -CGRectGetHeight(rect);
                                 contentView.frame = rect;
                             }
                             completion:completion];
        }
            break;
        case SIPopoverTransitionStyleSlideFromBottom:
        {
            CGFloat containerHeight = CGRectGetHeight(self.view.bounds);
            [UIView animateWithDuration:self.duration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 CGRect rect = contentView.frame;
                                 rect.origin.y = containerHeight;
                                 contentView.frame = rect;
                             }
                             completion:completion];
        }
            break;
        case SIPopoverTransitionStyleBounce:
        {
            [UIView animateKeyframesWithDuration:self.duration
                                           delay:0
                                         options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                      animations:^{
                                          [UIView addKeyframeWithRelativeStartTime:0
                                                                  relativeDuration:0.2
                                                                        animations:^{
                                                                            contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                                                        }];
                                          [UIView addKeyframeWithRelativeStartTime:0.2
                                                                  relativeDuration:0.8
                                                                        animations:^{
                                                                            contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                                                            contentView.alpha = 0;
                                                                        }];
                                      }
                                      completion:completion];
        }
            break;
    }
    [UIView animateWithDuration:self.duration
                     animations:^{
                         self.dimView.alpha = 0;
                     }];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:PreferredContentSizeKeyPath]) {
        [self.view setNeedsLayout];
    }
}

@end