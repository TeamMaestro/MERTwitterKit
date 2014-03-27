//
//  NSArray+MERExtensions.m
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

#import "NSArray+MERExtensions.h"
#import "MERMap.h"
#import "MERFilter.h"
#import "MERFold.h"
#import "MERZip.h"
#import "MERUnzip.h"

@implementation NSArray (MERExtensions)

- (NSArray *)MER_filter:(BOOL (^)(id value))block; {
    return MERFilter(self, block);
}
- (id)MER_find:(BOOL (^)(id value))block; {
    return MERFind(self, block);
}
- (NSUInteger)MER_findIndex:(BOOL (^)(id))block {
    return MERFindIndex(self, block);
}
- (NSArray *)MER_findWithIndex:(BOOL (^)(id, NSUInteger))block {
    return MERFindWithIndex(self, block);
}

- (NSArray *)MER_map:(id (^)(id value))block; {
    return MERMap(self, block);
}

- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id value))block; {
    return MERFoldLeft(self, start, ^id(id accumulator, id value, BOOL *stop) {
        return block(accumulator,value);
    });
}
- (id)MER_foldRightWithStart:(id)start block:(id (^)(id accumulator, id value))block; {
    return MERFoldRight(self, start, ^id(id accumulator, id value, BOOL *stop) {
        return block(accumulator,value);
    });
}

- (BOOL)MER_any:(BOOL (^)(id value))block; {
    return MERAny(self, block);
}
- (BOOL)MER_all:(BOOL (^)(id value))block; {
    return MERAll(self, block);
}

- (NSArray *)MER_zip; {
    return MERZip(self);
}
- (NSArray *)MER_zipWith:(NSArray *)array; {
    return [@[self,(array) ?: @[]] MER_zip];
}

- (NSArray *)MER_unzip; {
    return MERUnzip(self);
}
- (NSArray *)MER_unzipWith:(NSArray *)array {
    return [@[self,(array) ?: @[]] MER_unzip];
}

- (NSArray *)MER_take:(NSUInteger)take; {
    return (take < self.count) ? [self subarrayWithRange:NSMakeRange(0, take)] : self;
}
- (NSArray *)MER_drop:(NSUInteger)drop; {
    return (drop < self.count) ? [self subarrayWithRange:NSMakeRange(drop, self.count - drop)] : nil;
}

- (NSArray *)MER_splitAt:(NSUInteger)splitAt; {
    return (splitAt < self.count) ? @[[self subarrayWithRange:NSMakeRange(0, splitAt)],[self subarrayWithRange:NSMakeRange(splitAt, self.count - splitAt)]] : @[self,@[]];
}

- (NSArray *)MER_reverse; {
    return MERFoldRight(self, [[NSMutableArray alloc] init], ^id(NSMutableArray *accumulator, id value, BOOL *stop) {
        [accumulator addObject:value];
        
        return accumulator;
    });
}

- (NSArray *)MER_concat; {
    return MERFoldLeft(self, [[NSMutableArray alloc] init], ^id(NSMutableArray *accumulator, NSArray *value, BOOL *stop) {
        [accumulator addObjectsFromArray:value];
        
        return accumulator;
    });
}
- (NSArray *)MER_concatWith:(NSArray *)array; {
    return [self arrayByAddingObjectsFromArray:array];
}

- (NSNumber *)MER_sum; {
    BOOL decimal = MERAll(self, ^BOOL(id value) {
        return [value isKindOfClass:[NSDecimalNumber class]];
    });
    
    if (decimal) {
        return MERFoldLeft(self, [NSDecimalNumber zero], ^id(NSDecimalNumber *accumulator, NSDecimalNumber *value, BOOL *stop) {
            return [accumulator decimalNumberByAdding:value];
        });
    }
    else {
        return [self valueForKeyPath:@"@sum.self"];
    }
}
- (id)MER_minimum; {
    return [self valueForKeyPath:@"@min.self"];
}
- (id)MER_maximum; {
    return [self valueForKeyPath:@"@max.self"];
}

@end
