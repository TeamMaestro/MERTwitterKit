//
//  CAGradientLayer+MEExtensions.m
//  MEKit
//
//  Created by William Towe on 5/29/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "CAGradientLayer+MEExtensions.h"

#import <UIKit/UIColor.h>

@implementation CAGradientLayer (MEExtensions)
+ (instancetype)ME_gradientLayerWithBounds:(CGRect)bounds colors:(NSArray *)colors locations:(NSArray *)locations; {
    CAGradientLayer *retval = [CAGradientLayer layer];
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    // CALayer requires CGColor's
    for (UIColor *color in colors)
        [CGColors addObject:(id)color.CGColor];
    
    [retval setColors:CGColors];
    [retval setLocations:locations];
    [retval setBounds:bounds];
    [retval setAnchorPoint:CGPointZero];
    
    return retval;
}
@end
