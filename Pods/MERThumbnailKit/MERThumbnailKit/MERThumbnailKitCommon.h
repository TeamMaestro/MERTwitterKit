//
//  MERThumbnailKitCommon.h
//  MERThumbnailKit
//
//  Created by William Towe on 5/4/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 The bundle identifier for the library.
 */
extern NSString *const MERThumbnailKitBundleIdentifier;

/**
 The version of library (e.g. 2.2.3).
 */
extern const struct MERThumbnailKitVersion {
    NSInteger major;
    NSInteger minor;
    NSInteger patch;
} MERThumbnailKitVersion;

/**
 The name of the library resources bundle.
 */
extern NSString *const MERThumbnailKitResourcesBundleName;
/**
 Returns the `NSBundle` instance containing the resources for the library.
 */
extern NSBundle *MERThumbnailKitResourcesBundle();

@interface MERThumbnailKitCommon : NSObject

/**
 Returns the version string of the library (e.g. "com.maestro.merthumbnailkit 2.2.3").
 */
+ (NSString *)versionString;

@end
