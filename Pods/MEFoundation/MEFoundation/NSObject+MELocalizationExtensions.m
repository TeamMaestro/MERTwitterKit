//
//  NSObject+MELocalizationExtensions.m
//  MEFoundation
//
//  Created by William Towe on 8/13/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSObject+MELocalizationExtensions.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIScreen.h>
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <AppKit/NSScreen.h>
#import <CoreServices/CoreServices.h>
#endif

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

NSString *const MELocalizationUserDefaultsKeySelectedLocalization = @"MELocalizationUserDefaultsKeySelectedLocalization";

NSString *const MELocalizationNotificationSelectedLocalizationDidChange = @"MELocalizationNotificationSelectedLocalizationDidChange";
NSString *const MELocalizationUserInfoKeySelectedLocalization = @"MELocalizationUserInfoKeySelectedLocalization";
NSString *const MELocalizationUserInfoKeySelectedLocalizationDisplayName = @"MELocalizationUserInfoKeySelectedLocalizationDisplayName";

@implementation NSObject (MELocalizationExtensions)

+ (NSString *)ME_defaultLocalization {
    return [NSLocale preferredLanguages].firstObject;
}

+ (NSString *)ME_selectedLocalization {
    return ([[NSUserDefaults standardUserDefaults] objectForKey:MELocalizationUserDefaultsKeySelectedLocalization]) ?: [self ME_defaultLocalization];
}
+ (void)ME_setSelectedLocalization:(NSString *)selectedLocalization {
    NSString *localization = (selectedLocalization) ?: [self ME_defaultLocalization];
    
    [[NSUserDefaults standardUserDefaults] setObject:localization forKey:MELocalizationUserDefaultsKeySelectedLocalization];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MELocalizationNotificationSelectedLocalizationDidChange object:self userInfo:@{MELocalizationUserInfoKeySelectedLocalization : localization,MELocalizationUserInfoKeySelectedLocalizationDisplayName: [self ME_displayNameForSelectedLocalization]}];
}

+ (NSString *)ME_displayNameForSelectedLocalization {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[self ME_selectedLocalization]];
    
    return [locale displayNameForKey:NSLocaleIdentifier value:[self ME_selectedLocalization]];
}

@end

@implementation NSBundle (MELocalizationExtensions)

- (NSString *)ME_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName; {
    NSURL *bundleURL = [self URLForResource:[self.class ME_selectedLocalization] withExtension:@"lproj"];
    
    if (!bundleURL)
        bundleURL = [[NSBundle mainBundle] URLForResource:[self.class ME_defaultLocalization] withExtension:@"lproj"];
    
    return [[NSBundle bundleWithURL:bundleURL] localizedStringForKey:key value:value table:tableName];
}

- (NSURL *)ME_localizedURLForResource:(NSString *)name withExtension:(NSString *)extension subdirectory:(NSString *)subpath localization:(NSString *)localizationName; {
    NSString *uti = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    
    if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeImage)) {
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
        BOOL retina = ([UIScreen mainScreen].scale == 2);
#else
        BOOL retina = ([NSScreen mainScreen].backingScaleFactor == 2);
#endif
        
        if (retina)
            name = [name stringByAppendingString:@"@2x"];
        
        NSURL *retval = [self URLForResource:name withExtension:extension subdirectory:subpath localization:localizationName];
        
        if (retina && !retval)
            retval = [self URLForResource:[name substringToIndex:[name rangeOfString:@"@2x"].location] withExtension:extension subdirectory:subpath localization:localizationName];
        
        if (!retval) {
            retval = [self URLForResource:name withExtension:extension subdirectory:subpath localization:[self.class ME_defaultLocalization]];
            
            if (retina && !retval)
                retval = [self URLForResource:[name substringToIndex:[name rangeOfString:@"@2x"].location] withExtension:extension subdirectory:subpath localization:[self.class ME_defaultLocalization]];
        }
        
        return retval;
    }
    else {
        NSURL *retval = [self URLForResource:name withExtension:extension subdirectory:subpath localization:localizationName];
        
        if (!retval)
            retval = [self URLForResource:name withExtension:extension subdirectory:subpath localization:[self.class ME_defaultLocalization]];
        
        return retval;
    }
}

@end
