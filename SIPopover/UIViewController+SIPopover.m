//
//  UIViewController+SIPopover.m
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import "UIViewController+SIPopover.h"
#import "SIPopoverRootViewController.h"
#import "SIPopoverConfiguration.h"

@implementation UIViewController (SIPopover)

- (UIOffset)si_popoverOffset
{
    return UIOffsetZero;
}

- (void)si_presentPopover:(UIViewController *)viewController
{
    SIPopoverConfiguration *configuration = [SIPopoverConfiguration defaultConfig];
    [self si_presentPopover:viewController withConfig:configuration];
}

- (void)si_presentPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle
{
    SIPopoverConfiguration *configuration = [SIPopoverConfiguration defaultConfig];
    configuration.gravity = gravity;
    configuration.transitionStyle = transitionStyle;
    [self si_presentPopover:viewController withConfig:configuration];
}

- (void)si_presentPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle duration:(NSTimeInterval)duration
{
    SIPopoverConfiguration *configuration = [SIPopoverConfiguration defaultConfig];
    configuration.gravity = gravity;
    configuration.transitionStyle = transitionStyle;
    configuration.duration = duration;
    [self si_presentPopover:viewController withConfig:configuration];
}

- (void)si_presentPopover:(UIViewController *)viewController withConfig:(SIPopoverConfiguration *)config
{
    SIPopoverRootViewController *rootViewController = [[SIPopoverRootViewController alloc] initWithContentViewController:viewController];
    rootViewController.configuration = config;
    [self presentViewController:rootViewController animated:YES completion:nil];
}

@end
