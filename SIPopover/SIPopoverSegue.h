//
//  SIPopoverSegue.h
//
//  Created by Kevin Cao on 13-12-15.
//  Copyright (c) 2013年 Sumi Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SIPopoverConfiguration;

@interface SIPopoverSegue : UIStoryboardSegue

@property (nonatomic, strong) SIPopoverConfiguration *configuration;

@end
