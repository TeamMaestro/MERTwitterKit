//
//  NSString+MEExtensions.h
//  MEFoundation
//
//  Created by William Towe on 4/23/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSString (MEExtensions)

/**
 Returns whether the receiver's length == 0.
 
 @return YES if the receiver is empty, NO otherwise
 */
- (BOOL)ME_isEmpty;

/**
 Returns whether the receiver's length, excluding whitespace and newlines characters, == 0.
 
 @return YES if the receiver is empty, NO otherwise
 */
- (BOOL)ME_isWhitespaceAndNewline;

/**
 Returns a copy of the receiver where newline characters are replaced with _replaceString_.
 
 @param replaceString The string with which to replace all newlines characters in the receiver with
 @return The transformed string
 @exception NSException Thrown if _replaceString_ is nil
 */
- (NSString *)ME_stringByReplacingNewlinesWithString:(NSString *)replaceString;

/**
 Returns a copy of the receiver in reverse order.
 
 For example, `[@"abc" ME_reverseString]` returns `@"cba"`.
 
 @return The reversed string
 */
- (NSString *)ME_reverseString;

/**
 Returns a url encoded copy of the receiver where spaces are replaced with `%20` instead of `+`.
 
 The original method, by Dave DeLong, can be found at http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string/3426140#3426140
 
 @return The URL encoded string
 */
- (NSString *)ME_URLEncodedString;

/**
 Alias of `[[NSUUID UUID] UUIDString]`.
 
 @return The UUID string
 */
+ (NSString *)ME_UUIDString;

/**
 Returns the MD5 hash of the receiver
 
 @return An NSString representation of the MD5 hash
 */
- (NSString *)ME_MD5String;
/**
 Returns the SHA1 hash of the receiver
 
 @return An NSString representation of the SHA1 hash
 */
- (NSString *)ME_SHA1String;

/**
 Returns the numerical value of the receiver, assuming base 16.
 
 @return The numerical value of the receiver
 */
- (NSUInteger)ME_valueFromHexadecimalString;

/**
 Returns the numerical value of the receiver, assuming base 2.
 
 @return The numerical value of the receiver
 */
- (NSUInteger)ME_valueFromBinaryString;

/**
 Returns the numerical value of the receiver, assuming base 10.
 
 @return The numerical value of the receiver
 */
- (NSUInteger)ME_valueFromString;

/**
 Returns a copy of the receiver with all invalid hexadecimal digits removed.
 
 @return The transformed string
 */
- (NSString *)ME_stringByRemovingInvalidHexadecimalDigits;

/**
 Returns a copy of the receiver with all invalid binary digits removed.
 
 @return The transformed string
 */
- (NSString *)ME_stringByRemovingInvalidBinaryDigits;

/**
 Returns a copy of the receiver with all invalid base 10 digits removed.
 
 @return The transformed string
 */
- (NSString *)ME_stringByRemovingInvalidDigits;

@end
