//
//  MERViewController.h
//  MEReactiveKit
//
//  Created by William Towe on 11/18/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 Mask that describes the navigation item options of the receiver.
 
 This affects when `configureNavigationItem` is called.
 
 - `MERViewControllerNavigationItemOptionNone`, `configureNavigationItem` is never called
 - `MERViewControllerNavigationItemOptionInit`, `configureNavigationItem` is called within `init`
 - `MERViewControllerNavigationItemOptionViewDidLoad`, `configureNavigationItem` is called within `viewDidLoad`
 - `MERViewControllerNavigationItemOptionViewWillAppear`, `configureNavigationItem` is called within `viewWillAppear:`
 - `MERViewControllerNavigationItemOptionWillAnimateRotationToInterfaceOrientation`, `configureNavigationItem` is called within `willAnimateRotationToInterfaceOrientation:duration:`
 - `MERViewControllerNavigationItemOptionDidRotateFromInterfaceOrientation`, `configureNavigationItem` is called within `didRotateFromInterfaceOrientation:`
 */
typedef NS_OPTIONS(NSInteger, MERViewControllerNavigationItemOptions) {
    MERViewControllerNavigationItemOptionNone = 0,
    MERViewControllerNavigationItemOptionInit = 1 << 0,
    MERViewControllerNavigationItemOptionViewDidLoad = 1 << 1,
    MERViewControllerNavigationItemOptionViewWillAppear = 1 << 2,
    MERViewControllerNavigationItemOptionWillAnimateRotationToInterfaceOrientation = 1 << 3,
    MERViewControllerNavigationItemOptionDidRotateFromInterfaceOrientation = 1 << 4
};

@class RACSignal;

/**
 `MERViewController` is a `UIViewController` subclass that provides additional useful properties related to keyboard management and navigation item management.
 */
@interface MERViewController : UIViewController

/**
 The navigation item options assigned to the receiver.
 
 The default is `MERViewControllerNavigationItemOptionInit`.
 
 @see MERViewControllerNavigationItemOptions
 */
@property (readonly,assign,nonatomic) MERViewControllerNavigationItemOptions navigationItemOptions;

/**
 The method gets called depending on the `navigationItemOptions` assigned to the receiver.
 
 The receiver should perform navigation item related configuration within this method.
 
 @see navigationItemOptions
 */
- (void)configureNavigationItem;

/**
 Returns whether the keyboard is visible.
 */
@property (readonly,assign,nonatomic,getter = isKeyboardVisible) BOOL keyboardVisible;
/**
 Returns the current keyboard frame, in the receiver's view coordinate space.
 
 If the keyboard is not visible, returns `CGRectZero`.
 */
@property (readonly,assign,nonatomic) CGRect keyboardFrame;

/**
 A signal that sends next whenever the `UIKeyboardWillChangeFrameNotification` is posted with a tuple containing the keyboard frame, animation duration, and animation curve.
 */
@property (readonly,nonatomic) RACSignal *keyboardWillChangeFrameSignal;
/**
 A signal that sends next whenever the `UIKeyboardDidChangeFrameNotification` is posted with a tuple containing the keyboard frame.
 */
@property (readonly,nonatomic) RACSignal *keyboardDidChangeFrameSignal;
/**
 A signal that sends next whenever the `UIKeyboardWillHideNotification` is posted with a tuple containing the keyboard frame, animation duration, and animation curve.
 */
@property (readonly,nonatomic) RACSignal *keyboardWillHideSignal;
/**
 A signal that sends next whenever the `UIKeyboardDidHideNotification` is posted with a tuple containing the keyboard frame.
 */
@property (readonly,nonatomic) RACSignal *keyboardDidHideSignal;
/**
 A signal that sends next whenever the `UIKeyboardWillShowNotification` is posted with a tuple containing the keyboard frame, animation duration, and animation curve.
 */
@property (readonly,nonatomic) RACSignal *keyboardWillShowSignal;
/**
 A signal that sends next whenever the `UIKeyboardDidShowNotification` is posted with a tuple containing the keyboard frame.
 */
@property (readonly,nonatomic) RACSignal *keyboardDidShowSignal;

@end
