//
//  NSMutableArray+MEExtensions.h
//  MEFoundation
//
//  Created by William Towe on 3/13/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MEExtensions)

/**
 Removes the first object in the receiver, or does nothing if the receiver is empty.
 
 Equivalent to calling [self removeObjectAtIndex:0]
 
 */
- (void)ME_removeFirstObject;

/**
 Pushes the object onto the receiver at index 0.
 
 Equivalent to calling [self insertObject:object atIndex:0]
 
 @param object The object to push
 @exception NSException Thrown if object is nil
 */
- (void)ME_push:(id)object;

/**
 Calls `[self ME_removeFirstObject]`.
 */
- (void)ME_pop;

/**
 Shuffles the receiver.
 */
- (void)ME_shuffle;

@end
