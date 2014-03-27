//
//  NSSet+MERExtensions.m
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

#import "NSSet+MERExtensions.h"
#import "MERMap.h"
#import "MERFilter.h"
#import "MERFold.h"

@implementation NSSet (MERExtensions)

- (NSSet *)MER_filter:(BOOL (^)(id value))block; {
    return MERFilter(self, block);
}
- (id)MER_find:(BOOL (^)(id value))block; {
    return MERFind(self, block);
}

- (NSSet *)MER_map:(id (^)(id value))block; {
    return MERMap(self, block);
}

- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id value))block; {
    return MERFoldLeft(self, start, ^id(id accumulator, id value, BOOL *stop) {
        return block(accumulator,value);
    });
}

- (BOOL)MER_any:(BOOL (^)(id value))block; {
    return MERAny(self, block);
}
- (BOOL)MER_all:(BOOL (^)(id value))block; {
    return MERAll(self, block);
}

- (NSSet *)MER_concat; {
    return MERFoldLeft(self, [[NSMutableSet alloc] init], ^id(NSMutableSet *accumulator, NSSet *value, BOOL *stop) {
        [accumulator unionSet:value];
        
        return accumulator;
    });
}
- (NSSet *)MER_concatWith:(NSSet *)set; {
    return [self setByAddingObjectsFromSet:set];
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
