//
//  UIImage+MEExtensions.h
//  MEKit
//
//  Created by William Towe on 8/20/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface UIImage (MEExtensions)

/**
 Searches for the given image in the given bundle, caches the result and returns it.
 
 @param imageName The name of the image to search for, excluding any device/resolution modifiers (e.g. @2x, ~ipad, ~iphone, etc.)
 @param bundleName The name of the bundle that contains the image
 @return The image, or nil if the image could not be located
 @exception NSException Thrown if _imageName_ or _bundleName_ are nil
 */
+ (UIImage *)ME_imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName;

/**
 Returns an image created by rendering _image_ with _color_.
 
 This method leverages the `imageWithRenderingMode:` method that was added in iOS 7.
 
 @param image The image to render as a template
 @param color The color to use when rendering _image_
 @return The rendered image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (UIImage *)ME_imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;
/**
 Calls `[ME_imageByRenderingImage:self withColor:color]`
 
 @see ME_imageByRenderingImage:color:
 */
- (UIImage *)ME_imageByRenderingWithColor:(UIColor *)color;

/**
 Creates a new image by first drawing the image then drawing a rectangle of color over it.
 
 @param image The original image
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The new image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (UIImage *)ME_imageByTintingImage:(UIImage *)image withColor:(UIColor *)color;
/**
 Calls `[self.class ME_imageByTintingImage:self withColor:color]`
 
 @see ME_imageByTintingImage:color:
 */
- (UIImage *)ME_imageByTintingWithColor:(UIColor *)color;

/**
 Creates a new image by blurring _image_ using a box blur.
 
 @param image The original image
 @param radius A value between 0.0 and 1.0 describing how much to blur the image. The value will be clamped automatically
 @return The blurred image
 @exception NSException Thrown if _image_ is nil
 */
+ (UIImage *)ME_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius;
/**
 Calls `[self.class ME_imageByBlurringImage:self radius:radius]`
 
 @see ME_imageByBlurringImage:radius:
 */
- (UIImage *)ME_blurredImageWithRadius:(CGFloat)radius;

/**
 Creates a new image by pixellating _image_ using the `CIPixellate` CoreImage filter.
 
 @param image The original image
 @param center The center point of the image from which to start the pixellation. Pass `CGPointZero` to use the default, which is `CGPointMake(150.0, 150.0)`
 @param scale The relative size of the pixellated blocks. Pass 0.0 to use the default, which is 8.0
 @return The pixellated image
 @exception NSException Thrown if _image_ is nil
 */
+ (UIImage *)ME_imageByPixellatingImage:(UIImage *)image center:(CGPoint)center scale:(CGFloat)scale;
/**
 Calls `[self.class ME_imageByPixellatingImage:self center:center scale:scale]`
 
 @see ME_imageByPixellatingImage:center:scale:
 */
- (UIImage *)ME_pixellatedImageWithCenter:(CGPoint)center scale:(CGFloat)scale;

@end
