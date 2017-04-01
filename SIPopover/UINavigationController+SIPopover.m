//
//  UINavigationController+SIPopover.m
//  SIPopoverExample
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import "UINavigationController+SIPopover.h"
#import "SIPopoverRootViewController.h"
#import "SIPopoverConfiguration.h"

@implementation UINavigationController (SIPopover)

- (void)si_pushPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle
{
    [self si_pushPopover:viewController gravity:gravity transitionStyle:transitionStyle backgroundEffect:SIPopoverBackgroundEffectDarken duration:0.4];
}

- (void)si_pushPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle backgroundEffect:(SIPopoverBackgroundEffect)backgroundEffect duration:(NSTimeInterval)duration
{
    SIPopoverRootViewController *rootViewController = [[SIPopoverRootViewController alloc] initWithContentViewController:viewController];
    SIPopoverConfiguration *configuration = [SIPopoverConfiguration new];
    configuration.gravity = gravity;
    configuration.transitionStyle = transitionStyle;
    configuration.backgroundEffect = backgroundEffect;
    configuration.duration = duration;
    configuration.tapBackgroundToDissmiss = YES;
    rootViewController.configuration = configuration;
    self.delegate = rootViewController;
    [self pushViewController:rootViewController animated:YES];
}

- (void)si_pushPopover:(UIViewController *)viewController withConfig:(SIPopoverConfiguration *)config {
    SIPopoverRootViewController *rootViewController = [[SIPopoverRootViewController alloc] initWithContentViewController:viewController];
    rootViewController.configuration = config;
    self.delegate = rootViewController;
    [self pushViewController:rootViewController animated:YES];
}

@end

