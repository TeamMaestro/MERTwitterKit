//
//  UIViewController+MEExtensions.m
//  MEKit
//
//  Created by William Towe on 3/20/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "UIViewController+MEExtensions.h"

@implementation UIViewController (MEExtensions)

- (UIViewController *)ME_rootViewController {
    UIViewController *retval = self;
    
    while (retval.parentViewController)
        retval = retval.parentViewController;
    
    while (retval.presentedViewController)
        retval = retval.presentedViewController;
    
    return retval;
}

@end
