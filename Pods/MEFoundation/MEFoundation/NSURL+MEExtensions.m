//
//  NSURL+MEExtensions.m
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

#import "NSURL+MEExtensions.h"
#import "MEDebugging.h"

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation NSURL (MEExtensions)

- (NSDate *)ME_contentCreationDate; {
    NSError *outError;
    NSDate *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLCreationDateKey error:&outError])
        MELogObject(outError);
    
    return retval;
}

- (NSDate *)ME_contentModificationDate; {
    NSError *outError;
    NSDate *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLContentModificationDateKey error:&outError])
        MELogObject(outError);
    
    return retval;
}

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
- (UIImage *)ME_effectiveIcon; {
    NSError *outError;
    UIImage *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLEffectiveIconKey error:&outError])
        MELogObject(outError);
    
    return retval;
}
#else
- (NSImage *)ME_effectiveIcon; {
    NSError *outError;
    NSImage *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLEffectiveIconKey error:&outError])
        MELogObject(outError);
    
    return retval;
}
#endif

- (BOOL)ME_isDirectory {
    NSError *outError;
    NSNumber *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLIsDirectoryKey error:&outError])
        MELogObject(outError);
    
    return retval.boolValue;
}

- (NSString *)ME_typeIdentifier; {
    NSError *outError;
    NSString *retval = nil;
    
    if (![self getResourceValue:&retval forKey:NSURLTypeIdentifierKey error:&outError])
        MELogObject(outError);
    
    return retval;
}

- (NSDictionary *)ME_queryDictionary; {
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (NSString *pair in [self.query componentsSeparatedByString:@"&"]) {
        NSArray *pairComps = [pair componentsSeparatedByString:@"="];
        
        [retval setObject:[pairComps objectAtIndex:1] forKey:[pairComps objectAtIndex:0]];
    }
    
    return retval;
}

+ (NSURL *)ME_URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters; {
    NSParameterAssert(baseString);
    
    NSMutableString *temp = [NSMutableString stringWithString:baseString];
    
    if (parameters.count > 0) {
        __block NSUInteger parameterIndex = 0;
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            if (parameterIndex == 0)
                [temp appendFormat:@"?%@=%@",key,obj];
            else
                [temp appendFormat:@"&%@=%@",key,obj];
            
            parameterIndex++;
        }];
    }
    
    return [NSURL URLWithString:temp];
}

@end
