//
//  UIViewController+MEExtensions.h
//  MEKit
//
//  Created by William Towe on 3/20/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MEExtensions)

/**
 Returns the root view controller of the receiver.
 
 This will either be the `rootViewController` of the application delegate, or the root view controller of the presented view controller if one exists.
 
 @return The root view controller of the receiver
 */
- (UIViewController *)ME_rootViewController;

@end
