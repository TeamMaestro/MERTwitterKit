//
//  NSBundle+MEExtensions.m
//  MEFoundation
//
//  Created by William Towe on 5/8/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSBundle+MEExtensions.h"

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation NSBundle (MEExtensions)

- (NSString *)ME_identifier {
    return [[self infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
- (NSString *)ME_displayName {
    return [[self infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
- (NSString *)ME_executable {
    return [[self infoDictionary] objectForKey:@"CFBundleExecutable"];
}
- (NSString *)ME_shortVersionString {
    return [[self infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
- (NSString *)ME_version {
    return [[self infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
