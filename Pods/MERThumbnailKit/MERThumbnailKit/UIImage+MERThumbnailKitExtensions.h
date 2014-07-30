//
//  UIImage+MERThumbnailKitExtensions.h
//  MERThumbnailKit
//
//  Created by William Towe on 5/1/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIImage.h>

@interface UIImage (MERThumbnailKitExtensions)

/**
 Returns whether the receiver has an alpha channel.
 */
@property (readonly,nonatomic) BOOL MER_hasAlpha;

/**
 Returns a thumbnail of the receiver of the specified size.
 
 @param image The image to create a thumbnail of
 @param size The size of the thumbnail. The size of the resulting thumbnail will always be scaled to fit within the size of the original image
 @return The thumbnail image
 */
+ (UIImage *)MER_thumbnailOfImage:(UIImage *)image size:(CGSize)size;

/**
 Calls `[UIImage MER_thumbnailOfImage:size:]`, passing `self` and _size_ respectively.
 
 @param size The size of thumbnail
 @return The thumbnail image
 */
- (UIImage *)MER_thumbnailOfSize:(CGSize)size;

@end
