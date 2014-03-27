//
//  MERFold.m
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

#import "MERFold.h"
#import "MERFilter.h"

id MERFoldLeft(id<NSObject,NSFastEnumeration> collection, id start, id(^block)(id accumulator, id value, BOOL *stop)) {
    NSCParameterAssert(block);
    
    id retval = start;
    
    if ([collection isKindOfClass:[NSArray class]] ||
        [collection isKindOfClass:[NSSet class]]) {
        
        for (id value in collection) {
            BOOL stop = NO;
            
            retval = block(retval,value,&stop);
            
            if (stop)
                break;
        }
    }
    return retval;
}
id MERFoldLeftDictionary(NSDictionary *dictionary, id start, id(^block)(id accumulator, id<NSCopying> key, id value, BOOL *stop)) {
    NSCParameterAssert(block);
    
    __block id retval = start;
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL localStop = NO;
        
        retval = block(retval,key,obj,&localStop);
        
        if (localStop)
            *stop = YES;
    }];
    
    return retval;
}

id MERFoldRight(id<NSObject,NSFastEnumeration> collection, id start, id(^block)(id accumulator, id value, BOOL *stop)) {
    NSCParameterAssert(block);
    
    id retval = start;
    
    if ([collection isKindOfClass:[NSArray class]]) {
        for (id value in [(NSArray *)collection reverseObjectEnumerator]) {
            BOOL stop = NO;
            
            retval = block(retval,value,&stop);
            
            if (stop)
                break;
        }
    }
    return retval;
}

BOOL MERAny(id<NSObject,NSFastEnumeration> collection, BOOL(^block)(id value)) {
    NSCParameterAssert(block);
    
    return [MERFoldLeft(collection, @NO, ^id(id accumulator, id value, BOOL *stop) {
        BOOL retval = block(value);
        
        if (retval)
            *stop = YES;
        
        return @(retval);
    }) boolValue];
}
BOOL MERAnyDictionary(NSDictionary *dictionary, BOOL(^block)(id<NSCopying> key, id value)) {
    NSCParameterAssert(block);
    
    return [MERFoldLeftDictionary(dictionary, @NO, ^id(id accumulator, id<NSCopying> key, id value, BOOL *stop) {
        BOOL retval = block(key,value);
        
        if (retval)
            *stop = YES;
        
        return @(retval);
    }) boolValue];
}

BOOL MERAll(id<NSObject,NSFastEnumeration> collection, BOOL(^block)(id value)) {
    NSCParameterAssert(block);
    
    return [MERFoldLeft(collection, @YES, ^id(NSNumber *accumulator, id value, BOOL *stop) {
        BOOL retval = (accumulator.boolValue && block(value));
        
        if (!retval)
            *stop = YES;
        
        return @(retval);
    }) boolValue];
}
BOOL MERAllDictionary(NSDictionary *dictionary, BOOL(^block)(id<NSCopying> key, id value)) {
    NSCParameterAssert(block);
    
    return [MERFoldLeftDictionary(dictionary, @YES, ^id(NSNumber *accumulator, id<NSCopying> key, id value, BOOL *stop) {
        BOOL retval = (accumulator.boolValue && block(key,value));
        
        if (!retval)
            *stop = YES;
        
        return @(retval);
    }) boolValue];
}
