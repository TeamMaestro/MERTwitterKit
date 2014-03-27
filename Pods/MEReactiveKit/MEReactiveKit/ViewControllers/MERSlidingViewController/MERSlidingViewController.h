//
//  MERSlidingViewController.h
//  MEReactiveKit
//
//  Created by William Towe on 3/17/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERViewController.h"

/**
 Enum that describes the state of the `topViewController`.
 
 - `MERSlidingViewControllerTopViewControllerStateCenter`, the `topViewController` is centered
 - `MERSlidingViewControllerTopViewControllerStateLeft`, the `topViewController` is anchored to the left edge
 - `MERSlidingViewControllerTopViewControllerStateRight`, the `topViewController` is anchored to the right edge
 */
typedef NS_ENUM(NSInteger, MERSlidingViewControllerTopViewControllerState) {
    MERSlidingViewControllerTopViewControllerStateCenter,
    MERSlidingViewControllerTopViewControllerStateLeft,
    MERSlidingViewControllerTopViewControllerStateRight
};

/**
 Mask that indicates which gestures to apply to the `topViewController` when it is anchored to the left or right edge.
 
 - `MERSlidingViewControllerAnchorGestureOptionNone`, do not apply any gestures
 - `MERSlidingViewControllerAnchorGestureOptionTap`, apply a tap gesture
 */
typedef NS_OPTIONS(NSInteger, MERSlidingViewControllerAnchorGestureOptions) {
    MERSlidingViewControllerAnchorGestureOptionNone = 0,
    MERSlidingViewControllerAnchorGestureOptionTap = 1 << 0,
    MERSlidingViewControllerAnchorGestureOptionPan = 1 << 1,
    MERSlidingViewControllerAnchorGestureOptionAll = MERSlidingViewControllerAnchorGestureOptionTap | MERSlidingViewControllerAnchorGestureOptionPan
};

/**
 `MERSlidingViewController` is a `MERViewController` subclass that implements the sliding navigation paradigm.
 */
@interface MERSlidingViewController : MERViewController

/**
 Returns the top view controller assigned to the receiver.
 */
@property (strong,nonatomic) UIViewController *topViewController;
/**
 Returns the left view controller that is placed underneath the `topViewController`.
 */
@property (strong,nonatomic) UIViewController *leftViewController;
/**
 Returns the right view controller that is placed underneath the `topViewController`.
 */
@property (strong,nonatomic) UIViewController *rightViewController;

/**
 Returns the state of the `topViewController` assigned to the receiver.
 
 @see MERSlidingViewControllerTopViewControllerState
 */
@property (readonly,assign,nonatomic) MERSlidingViewControllerTopViewControllerState topViewControllerState;

/**
 Returns the anchor gesture options assigned to the receiver.
 
 @see MERSlidingViewControllerAnchorGestureOptions
 */
@property (assign,nonatomic) MERSlidingViewControllerAnchorGestureOptions anchorGestureOptions;

/**
 Returns the amount of the `topViewController` that is visible whenever the receiver is anchored to the left or right.
 
 The default is 44.0.
 */
@property (assign,nonatomic) CGFloat peekAmount;

/**
 Returns the duration of the animation that is performed when the `topViewController` is anchored to the left or right.
 
 The default is 0.5.
 */
@property (assign,nonatomic) NSTimeInterval topViewControllerAnchorAnimationDuration;
/**
 Returns the duration of the animation that is performed when the `topViewController` is reset.
 
 The default is 0.33.
 */
@property (assign,nonatomic) NSTimeInterval topViewControllerResetAnimationDuration;

/**
 Calls `toggleTopViewControllerToRightAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see toggleTopViewControllerToRightAnimated:animations:completion:
 */
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated;
/**
 Calls `toggleTopViewControllerToRightAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see toggleTopViewControllerToRightAnimated:animations:completion:
 */
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 If `topViewControllerState` is `MERSlidingViewControllerTopViewControllerStateCenter`, calls `anchorTopViewControllerToRightAnimated:animations:completion:`, passing _animated_, _animations_, and _completion_; otherwise calls `resetTopViewControllerAnimated:animations:completion:`, passing _animated_, _animations_, and _completion_.
 
 @param animated Whether to animate the transition
 @param animations The animations block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 */
- (void)toggleTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

/**
 Calls `anchorTopViewControllerToRightAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see anchorTopViewControllerToRightAnimated:animations:completion:
 */
- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated;
/**
 Calls `anchorTopViewControllerToRightAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see anchorTopViewControllerToRightAnimated:animations:completion:
 */
- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 Anchors the `topViewController` to the right edge of the receiver's view, optionally animating the transition.
 
 @param animated Whether to animate the transition
 @param animations The animations block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 */
- (void)anchorTopViewControllerToRightAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

/**
 Calls `toggleTopViewControllerToLeftAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see toggleTopViewControllerToLeftAnimated:animations:completion:
 */
- (void)toggleTopViewControllerToLeftAnimated:(BOOL)animated;
/**
 Calls `toggleTopViewControllerToLeftAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see toggleTopViewControllerToLeftAnimated:animations:completion:
 */
- (void)toggleTopViewControllerToLeftAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 If `topViewControllerState` is `MERSlidingViewControllerTopViewControllerStateCenter`, calls `anchorTopViewControllerToLeftAnimated:animations:completion:`, passing _animated_, _animations_, and _completion_; otherwise calls `resetTopViewControllerAnimated:animations:completion:`, passing _animated_, _animations_, and _completion_.
 
 @param animated Whether to animate the transition
 @param animations The animations block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 */
- (void)toggleTopViewControllerToLeftAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

/**
 Calls `anchorTopViewControllerToLeftAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see anchorTopViewControllerToLeftAnimated:animations:completion:
 */
- (void)anchorTopViewControllerToLeftAnimated:(BOOL)animated;
/**
 Calls `anchorTopViewControllerToLeftAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see anchorTopViewControllerToLeftAnimated:animations:completion:
 */
- (void)anchorTopViewControllerToLeftAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 Anchors the `topViewController` to the left edge of the receiver's view, optionally animating the transition.
 
 @param animated Whether to animate the transition
 @param animations The animation block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 */
- (void)anchorTopViewControllerToLeftAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

/**
 Calls `resetTopViewControllerAnimated:animations:completion:`, passing _animated_, nil, and nil.
 
 @see resetTopViewControllerAnimated:animations:completion:
 */
- (void)resetTopViewControllerAnimated:(BOOL)animated;
/**
 Calls `resetTopViewControllerAnimated:animations:completion:`, passing _animated_, nil, and _completion_.
 
 @see resetTopViewControllerAnimated:animations:completion:
 */
- (void)resetTopViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
/**
 Resets the `topViewController` in the receiver's view, optionally animating the transition.
 
 @param animated Whether to animate the transition
 @param animations The animations block to invoke along with the transition animation
 @param completion The completion block that is invoked when the transition is complete
 */
- (void)resetTopViewControllerAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion;

@end

@interface UIViewController (MERSlidingViewControllerExtensions)

/**
 Returns the root `MERSlidingViewController` instance related to the receiver, or nil if there is no `MERSlidingViewController` in the view hierarchy.
 */
@property (readonly,nonatomic) MERSlidingViewController *MER_slidingViewController;

@end