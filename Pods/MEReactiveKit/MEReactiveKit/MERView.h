//
//  MERView.h
//  MEReactiveKit
//
//  Created by William Towe on 2/7/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 Mask that describes the separator options of the receiver.
 
 - `MERViewSeparatorOptionNone`, no separators are displayed
 - `MERViewSeparatorOptionTop`, a top separator is displayed
 - `MERViewSeparatorOptionLeft`, a left separator is displayed
 - `MERViewSeparatorOptionBottom`, a bottom separator is displayed
 - `MERViewSeparatorOptionRight`, a right separator is displayed
 - `MERViewSeparatorOptionTopBottom`, top and bottom separators are displayed
 - `MERViewSeparatorOptionLeftRight`, left and right separators are displayed
 - `MERViewSeparatorOptionAll`, top, left, bottom, and right separators are displayed
 */
typedef NS_OPTIONS(NSInteger, MERViewSeparatorOptions) {
    MERViewSeparatorOptionNone = 0,
    MERViewSeparatorOptionTop = 1 << 0,
    MERViewSeparatorOptionLeft = 1 << 1,
    MERViewSeparatorOptionBottom = 1 << 2,
    MERViewSeparatorOptionRight = 1 << 3,
    MERViewSeparatorOptionTopBottom = MERViewSeparatorOptionTop | MERViewSeparatorOptionBottom,
    MERViewSeparatorOptionLeftRight = MERViewSeparatorOptionLeft | MERViewSeparatorOptionRight,
    MERViewSeparatorOptionAll = MERViewSeparatorOptionTop | MERViewSeparatorOptionLeft | MERViewSeparatorOptionBottom | MERViewSeparatorOptionRight
};

/**
 `MERView` is a `UIView` subclass that provides additional useful behavior.
 */
@interface MERView : UIView

/**
 The separator options applied to the receiver.
 
 The default is `MERViewSeparatorOptionNone`.
 
 @see MERViewSeparatorOptions
 */
@property (assign,nonatomic) MERViewSeparatorOptions separatorOptions;
/**
 The color applied to the separators of the receiver.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (strong,nonatomic) UIColor *separatorColor;

@end
