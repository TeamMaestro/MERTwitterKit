//
//  MERSplitViewController.h
//  MEReactiveKit
//
//  Created by William Towe on 3/3/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERViewController.h"

/**
 Enum that describes the state of `masterViewController`.
 
 - `MERSplitViewControllerMasterViewControllerStateDismissed`, the `masterViewController` is dimissed
 - `MERSplitViewControllerMasterViewControllerStatePresented`, the `masterViewController` is presented
 */
typedef NS_ENUM(NSInteger, MERSplitViewControllerMasterViewControllerState) {
    MERSplitViewControllerMasterViewControllerStateDismissed,
    MERSplitViewControllerMasterViewControllerStatePresented
};

/**
 This notification is posted when the receiver is about to present the `masterViewController`.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERSplitViewControllerNotificationWillPresentMasterViewController;
/**
 This notification is posted when the receiver has presented the `masterViewController`.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERSplitViewControllerNotificationDidPresentMasterViewController;

/**
 This notification is posted when the receiver is about to dismiss the `masterViewController`.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERSplitViewControllerNotificationWillDismissMasterViewController;
/**
 This notification is posted when the receiver has dismissed the `masterViewController`.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERSplitViewControllerNotificationDidDismissMasterViewController;

/**
 `MERSplitViewController` is a `MERViewController` subclass that implements the split navigation paradigm.
 */
@interface MERSplitViewController : MERViewController

/**
 Returns the master view controller assigned to the receiver.
 
 This view controller is presented on top of the `detailViewController` in portrait mode and to the left of the `detailViewController` in landscape mode.
 */
@property (strong,nonatomic) UIViewController *masterViewController;
/**
 Returns the detail view controller assigned to the receiver.
 
 This view controller is always visible and appears underneath the `masterViewController` when it is presented in portrait mode and to the right of `masterViewController` in landscape mode.
 */
@property (strong,nonatomic) UIViewController *detailViewController;

/**
 Returns the state of the `masterViewController` assigned to the receiver.
 
 @see MERSplitViewControllerMasterViewControllerState
 */
@property (readonly,assign,nonatomic) MERSplitViewControllerMasterViewControllerState masterViewControllerState;

/**
 Returns the divider view class assigned to the receiver.
 
 This class is used as the divider view that is placed between the `masterViewController` and `detailViewController` in landscape mode.
 
 The default is `[MERSplitViewDividerView class]`.
 
 @warning *NOTE:* The assigned class, if non-nil, must conform to the `MERSplitViewDividerViewClass` protocol
 */
@property (strong,nonatomic) Class dividerViewClass;

/**
 Returns the duration of the animation that is performed when the `masterViewController` is presented or dismissed.
 
 The default is 0.33.
 */
@property (assign,nonatomic) NSTimeInterval masterViewControllerAnimationDuration;

/**
 Calls `toggleMasterViewControllerAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see toggleMasterViewControllerAnimated:animations:completion:
 */
- (void)toggleMasterViewControllerAnimated:(BOOL)animated;
/**
 Calls `toggleMasterViewControllerAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see toggleMasterViewControllerAnimated:animations:completion:
 */
- (void)toggleMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 If `masterViewControllerState` is `MERSplitViewControllerMasterViewControllerStateDismissed` presents the `masterViewController`, otherwise dismisses the `masterViewController`.
 
 @param animated Whether the transition should be animated
 @param animations The animations block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 @warning *NOTE:* Calling this method is ignored when the application is in landscape mode
 */
- (void)toggleMasterViewControllerAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

@end

@interface UIViewController (MERSplitViewControllerExtensions)

/**
 Returns the root `MERSplitViewController` instance related to the receiver, or nil if there is no `MERSplitViewController` in the view hierarchy.
 */
@property (readonly,nonatomic) MERSplitViewController *MER_splitViewController;

@end
