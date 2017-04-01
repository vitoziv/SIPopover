//
//  SIPopoverSegue.m
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import "SIPopoverSegue.h"
#import "UIViewController+SIPopover.h"

@implementation SIPopoverSegue

- (void)perform
{
    [self.sourceViewController si_presentPopover:self.destinationViewController withConfig:self.configuration];
}

@end
