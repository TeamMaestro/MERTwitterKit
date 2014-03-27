//
//  MEGradientView.h
//  MEKit
//
//  Created by William Towe on 4/15/13.
//  Copyright (c) 2013 William Towe. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 `MEGradientView` is a light wrapper around `CAGradientLayer`.
 
 Its methods map to the corresponding `CAGradientLayer` methods and perform the necessary NS to CG conversions for you.
 */
@interface MEGradientView : UIView

/**
 The colors of the gradient.
 
 The array should contain `UIColor` instances.
 */
@property (strong,nonatomic) NSArray *colors;
/**
 The locations, or color stops of the gradient.
 
 These should be `NSNumber` instances wrapping values from 0 to 1.
 
 @warning *NOTE:* If you pass nil, the colors will be evenly distributed.
 */
@property (strong,nonatomic) NSArray *locations;
/**
 The start point of the gradient.
 
 This point is defined in the unit coordinate space.
 */
@property (assign,nonatomic) CGPoint startPoint;
/**
 The end point of the gradient.
 
 This point is defined in the unit coordinate space.
 */
@property (assign,nonatomic) CGPoint endPoint;

@end
