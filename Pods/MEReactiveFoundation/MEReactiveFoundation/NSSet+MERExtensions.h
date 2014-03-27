//
//  NSSet+MERExtensions.h
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

#import <Foundation/Foundation.h>

@interface NSSet (MERExtensions)

/**
 Returns a set that contains objects from the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. The block should return YES if the resulting set should contain the object, NO otherwise
 @return The filtered set
 @exception NSException Thrown if _block_ is nil
 */
- (NSSet *)MER_filter:(BOOL (^)(id value))block;

/**
 Returns the first object in the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. If the block returns YES, the object is returned from the method
 @return The found object or nil
 @exception NSException Thrown if _block_ is nil
 */
- (id)MER_find:(BOOL (^)(id value))block;

/**
 Returns a set that is the result of mapping _block_ over each object in the receiver.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. The block should return the mapped value
 @return The mapped set
 @exception NSException Thrown if _block_ is nil
 @warning *NOTE:* _block_ may return nil, it will be mapped to [NSNull null] automatically
 */
- (NSSet *)MER_map:(id (^)(id value))block;

/**
 Returns a single object which is the result of folding the receiver.
 
 @param start The starting value for the fold. It will be passed as _accumulator_ on the first invocation of _block_
 @param block The block that is invoked for each object in the receiver. _accumulator_ is the value returned from the previous invocation of _block_ and _value_ is the current object
 @exception NSException Thrown if _block_ is nil
 @warning *NOTE:* `MER_foldRightWithStart:block:` does not exist because a set is unordered
 */
- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id value))block;

/**
 Returns YES if _block_ returns YES for any of the objects in the receiver, NO otherwise.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. If the block returns YES, the enumeration ends
 @return YES if _block_ returns YES once, NO otherwise
 @exception NSException Thrown if _block_ is nil
 */
- (BOOL)MER_any:(BOOL (^)(id value))block;
/**
 Returns YES if _block_ returns YES for all of the objects in the receiver, NO otherwise.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. If the block returns NO, the enumeration ends
 @return YES if _block_ returns YES for all of the objects in the receiver, NO otherwise
 @exception NSException Thrown if _block_ is nil
 */
- (BOOL)MER_all:(BOOL (^)(id value))block;

/**
 Returns a set which is the concatination (union) of the receiver's objects, which should be sets.
 
 @return The concatinated set
 */
- (NSSet *)MER_concat;
/**
 Concatinates the receiver with _set_ and returns the resulting set.
 
 @param set The set to concatinate the receiver with
 @return The concatinated set
 */
- (NSSet *)MER_concatWith:(NSSet *)set;

/**
 Returns the sum of the objects in the receiver.
 
 @return The calculated sum
 @warning *NOTE:* The objects in the receiver must be instances of `NSNumber` or `NSDecimalNumber`
 */
- (NSNumber *)MER_sum;
/**
 Returns the minimum of the objects in the receiver.
 
 @return The minimum object
 @warning *NOTE:* The objects in the receiver must support comparison (i.e. they must implement the `compare:` method). `NSNumber`, `NSDecimalNumber`, `NSDate`, and `NSString` support comparison out of the box
 */
- (id)MER_minimum;
/**
 Returns the maximum of the objects in the receiver.
 
 @return The maximum object
 @warning *NOTE:* The objects in the receiver must support comparison (i.e. they must implement the `compare:` method). `NSNumber`, `NSDecimalNumber`, `NSDate`, and `NSString` support comparison out of the box
 */
- (id)MER_maximum;

@end
