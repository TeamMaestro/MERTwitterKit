//
//  NSDictionary+MERExtensions.m
//  MEReactiveFoundation
//
//  Created by William Towe on 2/22/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSDictionary+MERExtensions.h"
#import "MERFilter.h"
#import "MERMap.h"
#import "MERFold.h"

@implementation NSDictionary (MERExtensions)

- (NSDictionary *)MER_filter:(BOOL (^)(id<NSCopying> key, id value))block; {
    return MERFilterDictionary(self, block);
}

- (NSArray *)MER_find:(BOOL (^)(id<NSCopying> key, id value))block; {
    return MERFindKeyValue(self, block);
}

- (NSDictionary *)MER_map:(NSArray* (^)(id<NSCopying> key, id value))block; {
    return MERMapDictionary(self, block);
}

- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id<NSCopying> key, id value))block; {
    return MERFoldLeftDictionary(self, start, ^id(id accumulator, id<NSCopying> key, id value, BOOL *stop) {
        return block(accumulator,key,value);
    });
}

- (BOOL)MER_any:(BOOL (^)(id<NSCopying> key, id value))block; {
    return MERAnyDictionary(self, block);
}
- (BOOL)MER_all:(BOOL (^)(id<NSCopying> key, id value))block; {
    return MERAllDictionary(self, block);
}

- (NSDictionary *)MER_reverse; {
    return MERMapDictionary(self, ^NSArray *(id<NSCopying> key, id value) {
        return @[value,key];
    });
}

@end
