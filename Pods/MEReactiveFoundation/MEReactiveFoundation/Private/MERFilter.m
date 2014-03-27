//
//  MERFilter.m
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

#import "MERFilter.h"

id MERFilter(id<NSObject,NSFastEnumeration> collection, BOOL(^block)(id value)) {
    NSCParameterAssert(block);
    
    if ([collection isKindOfClass:[NSArray class]]) {
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        for (id value in collection) {
            if (block(value))
                [retval addObject:value];
        }
        
        return retval;
    }
    else if ([collection isKindOfClass:[NSSet class]]) {
        NSMutableSet *retval = [[NSMutableSet alloc] init];
        
        for (id value in collection) {
            if (block(value))
                [retval addObject:value];
        }
        
        return retval;
    }
    return nil;
}
NSDictionary *MERFilterDictionary(NSDictionary *dictionary, BOOL(^block)(id<NSCopying> key, id value)) {
    NSCParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key,obj))
            [retval setObject:obj forKey:key];
    }];
    
    return retval;
}

id MERFind(id<NSObject,NSFastEnumeration> collection, BOOL(^block)(id value)) {
    NSCParameterAssert(block);
    
    id retval = nil;
    
    if ([collection isKindOfClass:[NSArray class]] ||
        [collection isKindOfClass:[NSSet class]]) {
        
        for (id value in collection) {
            if (block(value)) {
                retval = value;
                break;
            }
        }
    }
    return retval;
}
NSArray *MERFindKeyValue(NSDictionary *dictionary, BOOL(^block)(id<NSCopying> key, id value)) {
    NSCParameterAssert(block);
    
    __block NSArray *retval = nil;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (block(key,obj)) {
            retval = @[key,obj];
            *stop = YES;
        }
    }];
    
    return retval;
}
NSUInteger MERFindIndex(NSArray *array, BOOL(^block)(id value)) {
    NSCParameterAssert(block);
    
    __block NSUInteger retval = NSNotFound;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            retval = idx;
            *stop = YES;
        }
    }];
    return retval;
}
NSArray *MERFindWithIndex(NSArray *array, BOOL(^block)(id value, NSUInteger index)) {
    NSCParameterAssert(block);
    
    __block NSArray *retval = nil;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = @[obj,@(idx)];
            *stop = YES;
        }
    }];
    return retval;
}
