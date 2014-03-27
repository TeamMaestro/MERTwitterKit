//
//  NSURL+MEExtensions.h
//  MEFoundation
//
//  Created by William Towe on 10/30/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIImage.h>
#else
#import <AppKit/NSImage.h>
#endif

@interface NSURL (MEExtensions)

/**
 Convenience method to access the resource value associated with the `NSURLCreationDateKey` key.
 
 @return An `NSDate` instance.
 */
- (NSDate *)ME_contentCreationDate;

/**
 Convenience method to access the resource value associated with the `NSURLContentModificationDateKey` key.
 
 @return An `NSDate` instance.
 */
- (NSDate *)ME_contentModificationDate;

/**
 Convenience method to access the resource value associated with the `NSURLEffectiveIconKey` key.
 
 @return A `UIImage` instance or `NSImage` instance.
 */
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (UIImage *)ME_effectiveIcon;
#else
- (NSImage *)ME_effectiveIcon;
#endif

/**
 Convenience method to access the resource value associated with the `NSURLIsDirectoryKey` key.
 
 @return A BOOL
 */
- (BOOL)ME_isDirectory;

/**
 Convenience method to access the resource value associated with the `NSURLTypeIdentifierKey` key.
 
 @return An `NSString` instance of a UTI
 */
- (NSString *)ME_typeIdentifier;

/**
 Parses the receiver's query and returns a dictionary representation containing a key/value pair for each corresponding parameter in the query.
 
 @return A dictionary representation of the receiver's query
 */
- (NSDictionary *)ME_queryDictionary;

/**
 Returns a NSURL instance constructed from the _baseString_ and parameters.
 
 @param baseString The base string for the url
 @param parameters A dictionary of parameters that will be appended to _baseString_
 @exception NSException Thrown if _baseString_ is nil
 @return The new url
 */
+ (NSURL *)ME_URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters;

@end
