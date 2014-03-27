//
//  UIView+MEExtensions.m
//  MEKit
//
//  Created by William Towe on 4/23/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIView+MEExtensions.h"

@implementation UIView (MEViewLayout)

- (CGPoint)ME_frameOrigin; {
    return self.frame.origin;
}

- (void)ME_setFrameOrigin:(CGPoint)frameOrigin; {
    [self setFrame:CGRectMake(frameOrigin.x, 
                              frameOrigin.y, 
                              CGRectGetWidth([self frame]), 
                              CGRectGetHeight([self frame]))];
}

- (CGFloat)ME_frameX; {
    return CGRectGetMinX(self.frame);
}
- (void)ME_setFrameX:(CGFloat)frameX; {
    [self setFrame:CGRectMake(frameX, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

- (CGFloat)ME_frameY; {
    return CGRectGetMinY(self.frame);
}
- (void)ME_setFrameY:(CGFloat)frameY; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), frameY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

- (CGSize)ME_frameSize; {
    return self.frame.size;
}
- (void)ME_setFrameSize:(CGSize)frameSize; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), frameSize.width, frameSize.height)];
}

- (CGFloat)ME_frameWidth; {
    return CGRectGetWidth(self.frame);
}
- (void)ME_setFrameWidth:(CGFloat)frameWidth; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), frameWidth, CGRectGetHeight(self.frame))];
}

- (CGFloat)ME_frameHeight; {
    return CGRectGetHeight(self.frame);
}
- (void)ME_setFrameHeight:(CGFloat)frameHeight; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), frameHeight)];
}

- (void)ME_adjustFrameXBy:(CGFloat)delta; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame) + delta, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
- (void)ME_adjustFrameYBy:(CGFloat)delta; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + delta, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
- (void)ME_adjustFrameXBy:(CGFloat)deltaX yBy:(CGFloat)deltaY; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame) + deltaX, CGRectGetMinY(self.frame) + deltaY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
- (void)ME_adjustFrameWidthBy:(CGFloat)delta; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame) + delta, CGRectGetHeight(self.frame))];
}
- (void)ME_adjustFrameHeightBy:(CGFloat)delta; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) + delta)];
}
- (void)ME_adjustFrameWidthBy:(CGFloat)deltaWidth heightBy:(CGFloat)deltaHeight; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame) + deltaWidth, CGRectGetHeight(self.frame) + deltaHeight)];
}
- (void)ME_adjustFrameXBy:(CGFloat)deltaX yBy:(CGFloat)deltaY widthBy:(CGFloat)deltaWidth heightBy:(CGFloat)deltaHeight; {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame) + deltaX, CGRectGetMinY(self.frame) + deltaY, CGRectGetWidth(self.frame) + deltaWidth, CGRectGetHeight(self.frame) + deltaHeight)];
}

- (NSArray *)ME_flattenedSubviews; {
    NSMutableSet *retval = [NSMutableSet setWithCapacity:0];
    
    for (UIView *view in [self subviews]) {
        [retval addObject:view];
        [retval addObjectsFromArray:[view ME_flattenedSubviews]];
    }
    
    return [retval allObjects];
}
@end
