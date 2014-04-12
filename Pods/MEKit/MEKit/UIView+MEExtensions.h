//
//  UIView+MEExtensions.h
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

#import <UIKit/UIKit.h>

@interface UIView (MEViewLayout)
/**
 Returns the origin of the receiver's frame
 
 @return The origin of the receiver's frame (e.g. `self.frame.origin`)
 */
- (CGPoint)ME_frameOrigin;

/**
 Sets the origin of the receiver's frame to `frameOrigin`
 
 @param frameOrigin The new origin
 */
- (void)ME_setFrameOrigin:(CGPoint)frameOrigin;

/**
 Returns the x coordinate of the receiver's frame origin
 
 @return The x coordinate of the receiver's frame origin (e.g. `self.frame.origin.x`)
 */
- (CGFloat)ME_frameX;

/**
 Sets the x coordinate of the receiver's frame origin to `frameX`
 
 @param frameX The new x coordinate
 */
- (void)ME_setFrameX:(CGFloat)frameX;

/**
 Returns the y coordinate of the receiver's frame origin
 
 @return The y coordinate of the receiver's frame origin (e.g. `self.frame.origin.y`)
 */
- (CGFloat)ME_frameY;

/**
 Sets the y coordinate of the receiver's frame origin to `frameY`
 
 @param frameY The new y coordinate
 */
- (void)ME_setFrameY:(CGFloat)frameY;

/**
 Returns the size of the receiver's frame
 
 @return The size of the receiver's frame (e.g. `self.frame.size`)
 */
- (CGSize)ME_frameSize;

/**
 Sets the size of the receiver's frame to `frameSize`
 
 @param frameSize The new size
 */
- (void)ME_setFrameSize:(CGSize)frameSize;

/**
 Returns the width of the receiver's frame size
 
 @return The width of the receiver's frame size (e.g. `self.frame.size.width`)
 */
- (CGFloat)ME_frameWidth;

/**
 Sets the width of the receiver's frame size to `frameWidth`
 
 @param frameWidth The new width
 */
- (void)ME_setFrameWidth:(CGFloat)frameWidth;

/**
 Returns the height of the receiver's frame size
 
 @return The height of the receiver's frame size (e.g. `self.frame.size.height`)
 */
- (CGFloat)ME_frameHeight;

/**
 Sets the height of the receiver's frame size to `frameHeight`
 
 @param frameHeight The new height
 */
- (void)ME_setFrameHeight:(CGFloat)frameHeight;

/**
 Adjust the x coordinate of the receiver's origin by `delta`
 
 @param delta The amount to adjust by
 */
- (void)ME_adjustFrameXBy:(CGFloat)delta;

/**
 Adjust the y coordinate of the receiver's origin by `delta`
 
 @param delta The amount to adjust by
 */
- (void)ME_adjustFrameYBy:(CGFloat)delta;

/**
 Adjust the origin (i.e. the x and y) of the receiver's frame by `deltaX` and `deltaY`
 
 @param deltaX The amount to adjust the x coordinate by
 @param deltaY The amount to adjust the y coordinate by
 */
- (void)ME_adjustFrameXBy:(CGFloat)deltaX yBy:(CGFloat)deltaY;

/**
 Adjust the width of the receiver's frame by `delta`
 
 @param delta The amount to adjust by
 */
- (void)ME_adjustFrameWidthBy:(CGFloat)delta;

/**
 Adjust the height of the receiver's frame by `delta`
 
 @param delta The amount to adjust by
 */
- (void)ME_adjustFrameHeightBy:(CGFloat)delta;

/**
 Adjust the size (i.e. the width and height) of the receiver's frame by `deltaWidth` and `deltaHeight`
 
 @param deltaWidth The amount to adjust the width by
 @param deltaHeight The amount to adjust the height by
 */
- (void)ME_adjustFrameWidthBy:(CGFloat)deltaWidth heightBy:(CGFloat)deltaHeight;

/**
 Adjust the origin and size of the receiver's frame by `deltaX`, `deltaY`, `deltaWidth` and `deltaHeight`
 
 @param deltaX The amount to adjust the x coordinate by
 @param deltaY The amount to adjust the y coordinate by
 @param deltaWidth The amount to adjust the width by
 @param deltaHeight The amount to adjust the height by
 */
- (void)ME_adjustFrameXBy:(CGFloat)deltaX yBy:(CGFloat)deltaY widthBy:(CGFloat)deltaWidth heightBy:(CGFloat)deltaHeight;

/**
 Recursively enumerates the subviews of the receiver and returns them
 
 @return An `NSArray` instance containing the subviews
 @warning *Note:* The recursion is depth first, but the subviews are collected in an `NSMutableSet` before being returned. The order of subviews in the returned `NSArray` should not be relied upon.
 */
- (NSArray *)ME_flattenedSubviews;

@end
