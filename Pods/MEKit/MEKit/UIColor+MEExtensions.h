//
//  UIColor+MEExtensions.h
//  MEKit
//
//  Created by William Towe on 6/7/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 Alias for `colorWithWhite:alpha:`, passing _w_ and 1 respectively.
 */
#define MEColorW(w) [UIColor colorWithWhite:((w)/255.0) alpha:1]
/**
 Alias for `colorWithWhite:alpha:`, passing _w_ and _a_ respectively.
 */
#define MEColorWA(w,a) [UIColor colorWithWhite:((w)/255.0) alpha:((a)/255.0)]

/**
 Alias for `colorWithRed:green:blue:alpha:`, passing _r_, _g_, _b_, and 1 respectively.
 */
#define MEColorRGB(r,g,b) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:1]
/**
 Alias for `colorWithRed:green:blue:alpha:`, passing _r_, _g_, _b_, and _a_ respectively.
 */
#define MEColorRGBA(r,g,b,a) [UIColor colorWithRed:((r)/255.0) green:((g)/255.0) blue:((b)/255.0) alpha:((a)/255.0)]

/**
 Alias for `colorWithHue:saturation:brightness:alpha:`, passing _h_, _s_, _b_, and 1 respectively.
 */
#define MEColorHSB(h,s,b) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:1]
/**
 Alias for `colorWithHue:saturation:brightness:alpha:`, passing _h_, _s_, _b_, and _a_ respectively.
 */
#define MEColorHSBA(h,s,b,a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]

@interface UIColor (MEExtensions)

/**
 Returns a color created by parsing _hexadecimalString_.
 
 This method adapted from a similar method on `NSColor`, which can be found at http://www.karelia.com/cocoa_legacy/Foundation_Categories/NSColor__Instantiat.m
 
 @param hexadecimalString The hexadecimal string to transform
 @return The color created from _hexadecimalString_ or nil if a color could not be created
 */
+ (UIColor *)ME_colorWithHexadecimalString:(NSString *)hexadecimalString;
@end
