//
//  UIColor+MEExtensions.m
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

#import "UIColor+MEExtensions.h"

@implementation UIColor (MEExtensions)

+ (UIColor *)ME_colorWithHexadecimalString:(NSString *)hexadecimalString; {
    if (!hexadecimalString.length)
        return nil;
    
    hexadecimalString = [hexadecimalString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    UIColor *retval = nil;
    uint32_t hexadecimalColor;
    NSScanner *scanner = [NSScanner scannerWithString:hexadecimalString];
    
    if (![scanner scanHexInt:&hexadecimalColor])
        return retval;
    
    uint8_t red = (uint8_t)(hexadecimalColor >> 16);
    uint8_t green = (uint8_t)(hexadecimalColor >> 8);
    uint8_t blue = (uint8_t)hexadecimalColor;
    
    retval = [UIColor colorWithRed:(CGFloat)red/0xff green:(CGFloat)green/0xff blue:(CGFloat)blue/0xff alpha:1.0];
    
    return retval;
}
@end
