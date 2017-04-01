//
//  SIPopoverRootViewController.h
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+SIPopover.h"

typedef void(^SIPopoverDidFinishedBlock)(UIViewController *viewController);

@interface SIPopoverRootViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong, readonly) UIViewController *contentViewController;

- (instancetype)initWithContentViewController:(UIViewController *)contentViewController;

@property (nonatomic, strong) SIPopoverConfiguration *configuration;

- (void)transitionInCompletion:(void(^)(BOOL finished))completion;
- (void)transitionOutCompletion:(void(^)(BOOL finished))completion;

@end
