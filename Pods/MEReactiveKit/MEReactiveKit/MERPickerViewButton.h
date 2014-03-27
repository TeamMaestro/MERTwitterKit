//
//  MERPickerViewButton.h
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
extern NSString *const MERPickerViewButtonNotificationDidBecomeFirstResponder;
/**
 This notification is posted whenever the receiver resigns first responder.
 
 The receiver is the object of the notification.
 */
extern NSString *const MERPickerViewButtonNotificationDidResignFirstResponder;

@protocol MERPickerViewButtonDataSource;

/**
 A `MERButton` subclass that manages a `UIPickerView` as its `inputView`.
 
 Each instance assigns an instance of `MERNextPreviousInputAccessoryView` as its `inputAccessoryView`.
 */
@interface MERPickerViewButton : UIButton

/**
 Returns the data source assigned to the receiver.
 */
@property (weak,nonatomic) id<MERPickerViewButtonDataSource> dataSource;

/**
 The index of the selected row of the picker view managed by the receiver.
 */
@property (assign,nonatomic) NSInteger pickerSelectedRow;
/**
 Whether the picker view managed by the receiver should show its selection indicator.
 */
@property (assign,nonatomic) BOOL pickerShowsSelectionIndicator;

@end

@protocol MERPickerViewButtonDataSource <NSObject>
@required
/**
 The number of rows in the picker view managed by the receiver.
 */
- (NSInteger)numberOfRowsInPickerViewButton:(MERPickerViewButton *)button;
/**
 The title for the row at the given index.
 */
- (NSString *)pickerViewButton:(MERPickerViewButton *)button titleForRowAtIndex:(NSInteger)index;
@optional
/**
 The attributed title for the row at the given index. If the data source responds to this method, its value is preferred over the return value from `pickerViewButton:titleForRowAtIndex:`.
 */
- (NSAttributedString *)pickerViewButton:(MERPickerViewButton *)button attributedTitleForRowAtIndex:(NSInteger)index;
@end