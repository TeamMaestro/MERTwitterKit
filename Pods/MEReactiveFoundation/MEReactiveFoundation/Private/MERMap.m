//
//  MERMap.m
//  MEReactiveFoundation
//
//  Created by William Towe on 1/24/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERMap.h"

id MERMap(id<NSObject,NSFastEnumeration> collection, id(^block)(id value)) {
    NSCParameterAssert(block);
    
    if ([collection isKindOfClass:[NSArray class]]) {
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        for (id value in collection)
            [retval addObject:(block(value)) ?: [NSNull null]];
        
        return retval;
    }
    else if ([collection isKindOfClass:[NSSet class]]) {
        NSMutableSet *retval = [[NSMutableSet alloc] init];
        
        for (id value in collection)
            [retval addObject:(block(value)) ?: [NSNull null]];
        
        return retval;
    }
    return nil;
}
NSDictionary *MERMapDictionary(NSDictionary *dictionary, NSArray*(^block)(id<NSCopying> key, id value)) {
    NSCParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSArray *map = block(key,obj);
        
        if (map)
            [retval setObject:map[1] forKey:map[0]];
        else
            [retval setObject:[NSNull null] forKey:key];
    }];
    
    return retval;
}
