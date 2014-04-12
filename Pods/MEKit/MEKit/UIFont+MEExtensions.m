//
//  UIFont+MEExtensions.m
//  MEKit
//
//  Created by William Towe on 2/6/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIFont+MEExtensions.h"

#import <CoreText/CoreText.h>
#import <objc/runtime.h>

@interface UIFont (MEExtensionsPrivate)
+ (void)_ME_loadFontsIfNecessary;
@end

@implementation UIFont (MEExtensions)

static void const *kME_fontsDirectoryURL = &kME_fontsDirectoryURL;

+ (NSURL *)ME_fontsDirectoryURL; {
    NSURL *retval = objc_getAssociatedObject(self, kME_fontsDirectoryURL);
    
    if (!retval)
        retval = [[NSBundle mainBundle] URLForResource:@"Fonts" withExtension:nil];
    
    return retval;
}
+ (void)ME_setFontsDirectoryURL:(NSURL *)fontsDirectoryURL; {
    objc_setAssociatedObject(self, kME_fontsDirectoryURL, fontsDirectoryURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (UIFont *)ME_fontWithName:(NSString *)fontName size:(CGFloat)size; {
    [self _ME_loadFontsIfNecessary];
    
    return [UIFont fontWithName:fontName size:size];
}

@end

@implementation UIFont (MEExtensionsPrivate)

+ (void)_ME_loadFontsIfNecessary; {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *fontsDirectoryURL = [self ME_fontsDirectoryURL];
        
        if ([fontsDirectoryURL checkResourceIsReachableAndReturnError:NULL]) {
            for (NSURL *url in [[NSFileManager defaultManager] contentsOfDirectoryAtURL:fontsDirectoryURL includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:NULL];
                
                if (!data)
                    continue;
                
                CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
                CGFontRef font = CGFontCreateWithDataProvider(dataProvider);
                
                CTFontManagerRegisterGraphicsFont(font, NULL);
                
                CFRelease(font);
                CFRelease(dataProvider);
            }
        }
    });
}

@end