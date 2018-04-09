//
//  SINavigationPopoverSegue.h
//  SIPopoverExample
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIPopoverDefine.h"

@interface SINavigationPopoverSegue : UIStoryboardSegue

@property (nonatomic, assign) SIPopoverGravity gravity;
@property (nonatomic, assign) SIPopoverTransitionStyle transitionStyle;
@property (nonatomic, assign) NSTimeInterval duration;

@end
