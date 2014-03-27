//
//  NSMutableArray+MEExtensions.m
//  MEFoundation
//
//  Created by William Towe on 3/13/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "NSMutableArray+MEExtensions.h"

@implementation NSMutableArray (MEExtensions)

- (void)ME_removeFirstObject; {
    if (self.count > 0)
        [self removeObjectAtIndex:0];
}

- (void)ME_push:(id)object {
    [self insertObject:object atIndex:0];
}

- (void)ME_pop {
    [self ME_removeFirstObject];
}

// taken verbatim from http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
- (void)ME_shuffle; {
    for (NSUInteger i=0; i<self.count; i++) {
        NSUInteger max = self.count - i;
        NSUInteger n = arc4random_uniform((u_int32_t)max) + i;
        
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
