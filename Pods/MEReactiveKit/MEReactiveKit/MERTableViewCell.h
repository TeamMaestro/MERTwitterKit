//
//  MERTableViewCell.h
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
 Mask that describes the cell separator options of the receiver.
 
 - `MERTableViewCellSeparatorOptionNone`, no separators are displayed
 - `MERTableViewCellSeparatorOptionTop`, a top separator is displayed
 - `MERTableViewCellSeparatorOptionBottom`, a bottom separator is displayed
 - `MERTableViewCellSeparatorOptionAll`, top and bottom separators are displayed
 */
typedef NS_OPTIONS(NSInteger, MERTableViewCellSeparatorOptions) {
    MERTableViewCellSeparatorOptionNone = 0,
    MERTableViewCellSeparatorOptionTop = 1 << 0,
    MERTableViewCellSeparatorOptionBottom = 1 << 1,
    MERTableViewCellSeparatorOptionAll = MERTableViewCellSeparatorOptionTop | MERTableViewCellSeparatorOptionBottom
};

@class RACSignal;

/**
 `MERTableViewCell` is a `UITableViewCell` subclass that provides common functionality.
 */
@interface MERTableViewCell : UITableViewCell

/**
 Returns the content view edge insets applied to the receiver.
 
 These are applied within `layoutSubviews`.
 */
@property (assign,nonatomic) UIEdgeInsets contentViewEdgeInsets;

/**
 The cell separator options applied to the receiver.
 
 @see MERTableViewCellSeparatorOptions
 */
@property (assign,nonatomic) MERTableViewCellSeparatorOptions cellSeparatorOptions;
/**
 The cell separator color applied to the receiver.
 */
@property (strong,nonatomic) UIColor *cellSeparatorColor;

/**
 A signal that sends next with the highlighted state of the receiver.
 */
@property (readonly,nonatomic) RACSignal *highlightedSignal;
/**
 A signal that sends next with a tuple containing the highlighted state and whether the change was animated.
 */
@property (readonly,nonatomic) RACSignal *highlightedTupleSignal;
/**
 A signal that sends next with the selected state of the receiver.
 */
@property (readonly,nonatomic) RACSignal *selectedSignal;
/**
 A signal that sends next with a tupel containing the selected state and whether the change was animated.
 */
@property (readonly,nonatomic) RACSignal *selectedTupleSignal;

@end
