//
//  MERDatePickerViewButton.h
//  MEReactiveKit
//
//  Created by William Towe on 2/21/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 This notification is posted whenever the receiver becomes first responder.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERDatePickerViewButtonNotificationDidBecomeFirstResponder;
/**
 This notification is posted whenever the receiver resigns first responder.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERDatePickerViewButtonNotificationDidResignFirstResponder;

/**
 A `MERButton` subclass that manages a `UIDatePickerView` as its `inputView`.
 
 Each instance assigns an instance of `MERNextPreviousInputAccessoryView` as its `inputAccessoryView`.
 */
@interface MERDatePickerViewButton : UIButton

/**
 The date represented by the receiver.
 
 The default is `[NSDate date]`.
 */
@property (strong,nonatomic) NSDate *datePickerDate;
/**
 The mode of the date picker managed by the receiver.
 
 The default is `UIDatePickerModeDateAndTime`.
 */
@property (assign,nonatomic) UIDatePickerMode datePickerMode;
/**
 The minimum date of the date picker managed by the receiver.
 */
@property (strong,nonatomic) NSDate *datePickerMinimumDate;
/**
 The maximum date of the date picker managed by the receiver.
 */
@property (strong,nonatomic) NSDate *datePickerMaximumDate;

/**
 The `NSDateFormatter` instance used to format the `datePickerDate` as the receiver's title.
 
 The default is a `NSDateFormatter` instance with `dateStyle` and `timeStyle` set to `NSDateFormatterShortStyle`.
 */
@property (strong,nonatomic) NSDateFormatter *dateFormatter UI_APPEARANCE_SELECTOR;

@end
