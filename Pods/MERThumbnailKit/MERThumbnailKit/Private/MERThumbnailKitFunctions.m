//
//  MERThumbnailKitFunctions.m
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

#import "MERThumbnailKitFunctions.h"
#import <MEFoundation/MEFoundation.h>

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

#if !__has_feature(objc_arc)
#error MERThumbnailKit requires ARC
#endif

BOOL MERThumbnailKitCGImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

CGImageRef MERThumbnailKitCreateCGImageThumbnailWithSize(CGImageRef imageRef, CGSize size) {
    NSCParameterAssert(imageRef);
    NSCParameterAssert(!CGSizeEqualToSize(size, CGSizeZero));
    
    CGSize destSize = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), CGRectMake(0, 0, size.width, size.height)).size;
    CGImageRef sourceImageRef = imageRef;
    CFDataRef sourceDataRef = CGDataProviderCopyData(CGImageGetDataProvider(sourceImageRef));
    vImage_Buffer source = {
        .data = (void *)CFDataGetBytePtr(sourceDataRef),
        .height = CGImageGetHeight(sourceImageRef),
        .width = CGImageGetWidth(sourceImageRef),
        .rowBytes = CGImageGetBytesPerRow(sourceImageRef)
    };
    vImage_Buffer destination;
    vImage_Error error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(sourceImageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        MELogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    error = vImageScale_ARGB8888(&source, &destination, NULL, kvImageHighQualityResampling|kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        MELogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    CFRelease(sourceDataRef);
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = (uint32_t)CGImageGetBitsPerComponent(sourceImageRef),
        .bitsPerPixel = (uint32_t)CGImageGetBitsPerPixel(sourceImageRef),
        .colorSpace = NULL,
        .bitmapInfo = CGImageGetBitmapInfo(sourceImageRef),
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &format, NULL, NULL, kvImageNoFlags, &error);
    
    free(destination.data);
    
    if (error != kvImageNoError) {
        MELogObject(@(error));
        CGImageRelease(destImageRef);
        return NULL;
    }
    
    return destImageRef;
}
