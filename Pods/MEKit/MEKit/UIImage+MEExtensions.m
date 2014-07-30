//
//  UIImage+MEExtensions.m
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

#import "UIImage+MEExtensions.h"
#import <MEFoundation/MEDebugging.h>
#import <MEFoundation/MEMacros.h>

#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation UIImage (MEExtensions)

+ (UIImage *)ME_imageNamed:(NSString *)imageName inBundleNamed:(NSString *)bundleName; {
    NSParameterAssert(imageName);
    NSParameterAssert(bundleName);
    
    static NSCache *kImageNamedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kImageNamedCache = [[NSCache alloc] init];
        
        [kImageNamedCache setName:@"com.maestro.cache.image-named-in-bundle-named"];
    });
    
    BOOL retina = ([[UIScreen mainScreen] scale] == 2);
    
    if (retina)
        imageName = [[imageName.stringByDeletingPathExtension stringByAppendingString:@"@2x"] stringByAppendingPathExtension:imageName.pathExtension];
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:bundleName.stringByDeletingPathExtension withExtension:bundleName.pathExtension]];
    NSURL *url = [bundle URLForResource:imageName.stringByDeletingPathExtension withExtension:imageName.pathExtension];
    
    if (!url && retina)
        url = [bundle URLForResource:[imageName substringToIndex:[imageName rangeOfString:@"@2x"].location] withExtension:imageName.pathExtension];
    
    NSString *key = url.lastPathComponent;
    UIImage *retval = [kImageNamedCache objectForKey:key];
    
    if (!retval) {
        retval = [self imageWithContentsOfFile:url.path];
        
        if (retval)
            [kImageNamedCache setObject:retval forKey:key cost:(retval.size.width * retval.size.height * retval.scale)];
    }
    
    return retval;
}

+ (UIImage *)ME_imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color {
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [color setFill];
    [[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *retval = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)ME_imageByRenderingWithColor:(UIColor *)color; {
    return [self.class ME_imageByRenderingImage:self withColor:color];
}

+ (UIImage *)ME_imageByTintingImage:(UIImage *)image withColor:(UIColor *)color; {
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    CGContextClipToMask(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIRectFillUsingBlendMode(CGRectMake(0, 0, image.size.width, image.size.height), kCGBlendModeNormal);
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)ME_imageByTintingWithColor:(UIColor *)color; {
    return [self.class ME_imageByTintingImage:self withColor:color];
}

+ (UIImage *)ME_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius; {
    NSParameterAssert(image);
    
    radius = MEBoundedValue(radius, 0.0, 1.0);
    
    uint32_t boxSize = (uint32_t)(radius * 100);
    
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef inImageRef = image.CGImage;
    CGDataProviderRef inProviderRef = CGImageGetDataProvider(inImageRef);
    CFDataRef inData = CGDataProviderCopyData(inProviderRef);
    
    vImage_Buffer inBuffer = {
        .width = CGImageGetWidth(inImageRef),
        .height = CGImageGetHeight(inImageRef),
        .rowBytes = CGImageGetBytesPerRow(inImageRef),
        .data = (void *)CFDataGetBytePtr(inData)
    };
    
    void *buffer = malloc(inBuffer.rowBytes * inBuffer.height);
    
    vImage_Buffer outBuffer = {
        .width = inBuffer.width,
        .height = inBuffer.height,
        .rowBytes = inBuffer.rowBytes,
        .data = buffer
    };
    
    vImage_Error error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        MELog(@"%@",@(error));
        
        free(buffer);
        CFRelease(inData);
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpaceRef, CGImageGetBitmapInfo(inImageRef));
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *retval = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer);
    CFRelease(inData);
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)ME_blurredImageWithRadius:(CGFloat)radius; {
    return [self.class ME_imageByBlurringImage:self radius:radius];
}

+ (UIImage *)ME_imageByPixellatingImage:(UIImage *)image center:(CGPoint)center scale:(CGFloat)scale; {
    NSParameterAssert(image);
    
    // CIContext is thread safe, so we only need a single instance
    static CIContext *kContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // turn off color management for performance
        kContext = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace: [NSNull null]}];
    });
    
    NSString *const kFilterKey = @"com.maestro.mekit.uiimage+meextensions.pixellate";
    
    // CIFilter is not thread safe, so create a single filter per thread and reuse it
    CIFilter *filter = [NSThread currentThread].threadDictionary[kFilterKey];
    
    if (!filter) {
        filter = [CIFilter filterWithName:@"CIPixellate"];
        
        [[NSThread currentThread].threadDictionary setObject:filter forKey:kFilterKey];
    }
    
    [filter setDefaults];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
    
    if (!CGPointEqualToPoint(CGPointZero, center))
        [filter setValue:[CIVector vectorWithCGPoint:center] forKey:kCIInputCenterKey];
    
    if (scale > 0.0)
        [filter setValue:@(scale) forKey:kCIInputScaleKey];
    
    CIImage *outputImage = filter.outputImage;
    CGImageRef imageRef = [kContext createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *retval = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)ME_pixellatedImageWithCenter:(CGPoint)center scale:(CGFloat)scale; {
    return [self.class ME_imageByPixellatingImage:self center:center scale:scale];
}

@end
