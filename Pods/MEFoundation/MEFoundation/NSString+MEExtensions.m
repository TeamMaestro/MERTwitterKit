//
//  NSString+MEExtensions.m
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

#import "NSString+MEExtensions.h"

#import <CommonCrypto/CommonDigest.h>

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

static inline uint8_t MEHexValueForCharacter(unichar character) {
	switch (character) {
		case '0':
			return 0;
		case '1':
			return 1;
		case '2':
			return 2;
		case '3':
			return 3;
		case '4':
			return 4;
		case '5':
			return 5;
		case '6':
			return 6;
		case '7':
			return 7;
		case '8':
			return 8;
		case '9':
			return 9;
		case 'a':
		case 'A':
			return 10;
		case 'b':
		case 'B':
			return 11;
		case 'c':
		case 'C':
			return 12;
		case 'd':
		case 'D':
			return 13;
		case 'e':
		case 'E':
			return 14;
		case 'f':
		case 'F':
			return 15;
		default:
			return 0;
	}
}

static inline uint8_t MEValueForCharacter(unichar character) {
	switch (character) {
		case '0':
			return 0;
		case '1':
			return 1;
		case '2':
			return 2;
		case '3':
			return 3;
		case '4':
			return 4;
		case '5':
			return 5;
		case '6':
			return 6;
		case '7':
			return 7;
		case '8':
			return 8;
		case '9':
			return 9;
		default:
			return 0;
	}
}

static inline uint8_t MEBinaryValueForCharacter(unichar character) {
	switch (character) {
		case '0':
			return 0;
		case '1':
			return 1;
		default:
			return 0;
	}
}

@implementation NSString (MEExtensions)

- (BOOL)ME_isEmpty; {
    return (self.length == 0);
}

- (BOOL)ME_isWhitespaceAndNewline; {
    return ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0);
}

- (NSString *)ME_stringByReplacingNewlinesWithString:(NSString *)replaceString; {
    NSParameterAssert(replaceString);
    
    NSMutableString *retval = [self mutableCopy];
    NSCharacterSet *set = [NSCharacterSet newlineCharacterSet];
    NSUInteger location = 0;
    NSRange range;
    
    while (location < retval.length) {
        range = [retval rangeOfCharacterFromSet:set options:0 range:NSMakeRange(location, retval.length - location)];
        
        if (range.location == NSNotFound)
            break;
        
        [retval replaceCharactersInRange:range withString:replaceString];
        
        location = NSMaxRange(range);
    }
    
    return [retval copy];
}

- (NSString *)ME_reverseString; {
	if (self.length <= 1)
		return self;
	
	NSUInteger stringLength = self.length;
	NSInteger stringIndex, reverseStringIndex;
	unichar *stringChars = calloc(sizeof(unichar), stringLength);
	unichar *reverseStringChars = calloc(sizeof(unichar), stringLength);
	
	[self getCharacters:stringChars range:NSMakeRange(0, stringLength)];
	
	for (stringIndex=stringLength-1, reverseStringIndex=0; stringIndex>=0; stringIndex--, reverseStringIndex++)
		reverseStringChars[reverseStringIndex] = stringChars[stringIndex];
	
	free(stringChars);
	
	return [[NSString alloc] initWithCharactersNoCopy:reverseStringChars length:stringLength freeWhenDone:YES];
}

- (NSString *)ME_URLEncodedString {
    NSMutableString *output = [NSMutableString string];
    const char * source = (const char *)[self UTF8String];
    size_t sourceLen = strlen(source);
    for (size_t i = 0; i < sourceLen; ++i) {
        const char thisChar = source[i];
        if (thisChar == ' ') {
            [output appendString:@"%20"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    return output;
}

+ (NSString *)ME_UUIDString; {
    return [[NSUUID UUID] UUIDString];
}

- (NSString *)ME_MD5String {
    const char *str = [self UTF8String];
    
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    NSMutableString *retval = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++)
        [retval appendFormat:@"%02x",buffer[i]];
    
    return retval;
}

- (NSString *)ME_SHA1String; {
    const char *str = [self UTF8String];
    
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    NSMutableString *retval = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
        [retval appendFormat:@"%02x",buffer[i]];
    
    return retval;
}

- (NSUInteger)ME_valueFromHexadecimalString; {
	NSString *string = [self ME_stringByRemovingInvalidHexadecimalDigits];
	
	if (self.length == 0)
		return 0;
	
	NSInteger index = self.length;
	NSUInteger total = 0, exponent = 0, base = 16;
	
	while (index > 0) {
		uint8_t value = MEHexValueForCharacter([string characterAtIndex:--index]);
		total += value * (NSUInteger)powf(base, exponent++);
	}
	return total;
}

- (NSUInteger)ME_valueFromBinaryString; {
	NSString *string = [self ME_stringByRemovingInvalidBinaryDigits];
	
	if (self.length == 0)
		return 0;
	
	NSInteger index = self.length;
	NSUInteger total = 0, exponent = 0, base = 2;
	
	while (index > 0) {
		uint8_t value = MEBinaryValueForCharacter([string characterAtIndex:--index]);
		total += value * (NSUInteger)powf(base, exponent++);
	}
	return total;
}

- (NSUInteger)ME_valueFromString; {
	NSString *string = [self ME_stringByRemovingInvalidDigits];
	
	if (self.length == 0)
		return 0;
	
	NSInteger index = self.length;
	NSUInteger total = 0, exponent = 0, base = 10;
	
	while (index > 0) {
		uint8_t value = MEValueForCharacter([string characterAtIndex:--index]);
		total += value * (NSUInteger)powf(base, exponent++);
	}
	return total;
}

- (NSString *)ME_stringByRemovingInvalidHexadecimalDigits; {
	static NSCharacterSet *hexadecimalDigits;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableCharacterSet *characterSet = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
        
		[characterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFabcdef"]];
        
		hexadecimalDigits = [characterSet copy];
	});
	
	NSUInteger charIndex, bufferIndex, stringLength = self.length;
	unichar buffer[stringLength];
	
	for (charIndex = 0, bufferIndex = 0; charIndex < stringLength; charIndex++) {
        unichar character = [self characterAtIndex:charIndex];
        
		if ([hexadecimalDigits characterIsMember:character])
			buffer[bufferIndex++] = character;
	}
	
	if (bufferIndex)
		return [[NSString alloc] initWithCharacters:buffer length:bufferIndex];
    
	return nil;
}

- (NSString *)ME_stringByRemovingInvalidBinaryDigits; {
	static NSCharacterSet *binaryDigits;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		binaryDigits = [NSCharacterSet characterSetWithCharactersInString:@"01"];
	});
	
	NSUInteger charIndex, bufferIndex, stringLength = self.length;
	unichar buffer[stringLength];
	
	for (charIndex = 0, bufferIndex = 0; charIndex < stringLength; charIndex++) {
        unichar character = [self characterAtIndex:charIndex];
        
		if ([binaryDigits characterIsMember:character])
			buffer[bufferIndex++] = character;
	}
	
	if (bufferIndex)
		return [[NSString alloc] initWithCharacters:buffer length:bufferIndex];
    
	return nil;
}

- (NSString *)ME_stringByRemovingInvalidDigits; {
	static NSCharacterSet *digits;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		digits = [NSCharacterSet decimalDigitCharacterSet];
	});
	
	NSUInteger charIndex, bufferIndex, stringLength = self.length;
	unichar buffer[stringLength];
	
	for (charIndex = 0, bufferIndex = 0; charIndex < stringLength; charIndex++) {
        unichar character = [self characterAtIndex:charIndex];
        
		if ([digits characterIsMember:character])
			buffer[bufferIndex++] = character;
	}
	
	if (bufferIndex)
		return [[NSString alloc] initWithCharacters:buffer length:bufferIndex];
    
	return nil;
}

@end
