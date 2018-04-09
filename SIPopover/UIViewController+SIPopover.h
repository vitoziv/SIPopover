//
//  UIViewController+SIPopover.h
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIPopoverDefine.h"

@class SIPopoverConfiguration;

@interface UIViewController (SIPopover)

- (UIOffset)si_popoverOffset;

- (void)si_presentPopover:(UIViewController *)viewController;
- (void)si_presentPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle;
- (void)si_presentPopover:(UIViewController *)viewController gravity:(SIPopoverGravity)gravity transitionStyle:(SIPopoverTransitionStyle)transitionStyle duration:(NSTimeInterval)duration;

- (void)si_presentPopover:(UIViewController *)viewController withConfig:(SIPopoverConfiguration *)config;

@end
