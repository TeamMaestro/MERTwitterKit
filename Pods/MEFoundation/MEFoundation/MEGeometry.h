//
//  MEGeometry.h
//  MEFoundation
//
//  Created by William Towe on 4/23/12.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#ifndef _ME_FOUNDATION_GEOMETRY_
#define _ME_FOUNDATION_GEOMETRY_

#import <CoreGraphics/CGGeometry.h>

/**
 Creates and returns a `CGRect` by centering _rect_to_center_ within _in_rect_
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The rect created by centering _rect_to_center_ within _in_rect_
 */
static inline CGRect ME_CGRectCenter(CGRect rect_to_center, CGRect in_rect) {
    return CGRectIntegral(CGRectMake(CGRectGetMinX(in_rect) + (CGRectGetWidth(in_rect) * 0.5) - (CGRectGetWidth(rect_to_center) * 0.5),
                                     CGRectGetMinY(in_rect) + (CGRectGetHeight(in_rect) * 0.5) - (CGRectGetHeight(rect_to_center) * 0.5),
                                     CGRectGetWidth(rect_to_center), 
                                     CGRectGetHeight(rect_to_center)));
}

/**
 Calls ME_CGRectCenter() and restores the resulting rectangles origin.y to its original value. This centers the rectangle horizontally.
 */
static inline CGRect ME_CGRectCenterX(CGRect rect_to_center, CGRect in_rect) {
    CGRect new_rect = ME_CGRectCenter(rect_to_center, in_rect);
    
    new_rect.origin.y = rect_to_center.origin.y;
    
    return new_rect;
}

/**
 Calls ME_CGRectCenter() and restores the resulting rectangles origin.x to its original value. This centers the rectangle vertically.
 */
static inline CGRect ME_CGRectCenterY(CGRect rect_to_center, CGRect in_rect) {
    CGRect new_rect = ME_CGRectCenter(rect_to_center, in_rect);
    
    new_rect.origin.x = rect_to_center.origin.x;
    
    return new_rect;
}

/**
 Scale a CGSize to fit in a maximum size while maintaining the original aspect ratio.
 
 @param original_size The size to be scaled
 @param in_size The maximum size for original_size to reach
 @return The size resulting from fitting _original_size_ within _in_size_ while maintaining its aspect ratio
 */
static inline CGSize ME_CGSizeForScaleAspectFitInSize(CGSize original_size, CGSize in_size) {
    
    CGFloat scale = in_size.width / original_size.width;
    CGSize scaled_size = CGSizeMake(original_size.width * scale, original_size.height * scale);
    
    if (scaled_size.width > in_size.width || scaled_size.height > in_size.height) {
        scale = in_size.height / original_size.height;
        scaled_size = CGSizeMake(original_size.width * scale, original_size.height * scale);
    }
    
    return scaled_size;
}

/**
 Rounds up the width and height of the original size using ceil().
 
 @param original_size The size to round
 @return The result of rounding _original_size_
 */
static inline CGSize ME_CGSizeIntegral(CGSize original_size) {
    return CGSizeMake(ceil(original_size.width), ceil(original_size.height));
}

#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)

#import <Foundation/NSGeometry.h>

static inline CGFloat NSRectGetMinX(NSRect rect) {
    return NSMinX(rect);
}
static inline CGFloat NSRectGetMidX(NSRect rect) {
    return NSMidX(rect);
}
static inline CGFloat NSRectGetMaxX(NSRect rect) {
    return NSMaxX(rect);
}
static inline CGFloat NSRectGetMinY(NSRect rect) {
    return NSMinY(rect);
}
static inline CGFloat NSRectGetMidY(NSRect rect) {
    return NSMidY(rect);
}
static inline CGFloat NSRectGetMaxY(NSRect rect) {
    return NSMaxY(rect);
}
static inline CGFloat NSRectGetWidth(NSRect rect) {
    return NSWidth(rect);
}
static inline CGFloat NSRectGetHeight(NSRect rect) {
    return NSHeight(rect);
}

static inline NSRect ME_NSRectCenter(NSRect rectToCenter, NSRect inRect) {
    return NSIntegralRect(NSMakeRect(NSRectGetMinX(inRect) + (NSRectGetWidth(inRect) * 0.5) - (NSRectGetWidth(rectToCenter) * 0.5),
                                     NSRectGetMinY(inRect) + (NSRectGetHeight(inRect) * 0.5) - (NSRectGetHeight(rectToCenter) * 0.5),
                                     NSRectGetWidth(rectToCenter),
                                     NSRectGetHeight(rectToCenter)));
}

static inline NSRect ME_NSRectCenterX(NSRect rectToCenter, NSRect inRect) {
    NSRect retval = ME_NSRectCenter(rectToCenter, inRect);
    
    retval.origin.y = NSRectGetMinY(rectToCenter);
    
    return retval;
}

static inline NSRect ME_NSRectCenterY(NSRect rectToCenter, NSRect inRect) {
    NSRect retval = ME_NSRectCenter(rectToCenter, inRect);
    
    retval.origin.x = NSRectGetMinX(rectToCenter);
    
    return retval;
}

#endif

#endif
