//
//  NSArray+MERExtensions.h
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

@interface NSArray (MERExtensions)

/**
 Returns an array that contains objects from the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. The block should return YES if the resulting array should contain the object, NO otherwise
 @return The filtered array
 @exception NSException Thrown if _block_ is nil
 */
- (NSArray *)MER_filter:(BOOL (^)(id value))block;

/**
 Returns the first object in the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. If the block returns YES, the object is returned from the method
 @return The found object or nil
 @exception NSException Thrown if _block_ is nil
 */
- (id)MER_find:(BOOL (^)(id value))block;
/**
 Returns the index of the first object in the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. If the block returns YES, the index of the object is returned from the method
 @return The index of the found object or `NSNotFound`
 @exception NSException Thrown if _block_ is nil
 */
- (NSUInteger)MER_findIndex:(BOOL (^)(id value))block;
/**
 Returns an array containing the first object in the receiver, along with its index, for which _block_ returns YES.
 
 @param block The block that is invoked for each object in the receiver. The object, as well as its index are passed into the block. If the block returns YES, the object and its index are returned from the method
 @return The found object and its index or nil
 @exception NSException Thrown if _block_ is nil
 */
- (NSArray *)MER_findWithIndex:(BOOL (^)(id value, NSUInteger index))block;

/**
 Returns an array that is the result of mapping _block_ over each object in the receiver.
 
 @param block The block that is invoked for each object in the receiver. The object is passed into the block. The block should return the mapped value
 @return The mapped array
 @exception NSException Thrown if _block_ is nil
 @warning *NOTE:* _block_ may return nil, it will be mapped to [NSNull null] automatically
 */
- (NSArray *)MER_map:(id (^)(id value))block;

/**
 Returns a single object which is the result of folding the receiver from left to right.
 
 @param start The starting value for the fold. It will be passed as _accumulator_ on the first invocation of _block_
 @param block The block that is invoked for each object in the receiver. _accumulator_ is the value returned from the previous invocation of _block_ and _value_ is the current object
 @exception NSException Thrown if _block_ is nil
 */
- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id value))block;
/**
 Returns a single object which is the result of folding the receiver from right to left.
 
 This is not a right fold in the sense of a Haskell (or similar functional language) right fold, because it is not lazily evaluated.
 
 @param start The starting value for the fold. It will be passed as _accumulator_ on the first invocation of _block_
 @param block The block that is invoked for each object in the receiver. _accumulator_ is the value returned from the previous invocation of _block_ and _value_ is the current object
 @exception NSException Thrown if _block_ is nil
 */
- (id)MER_foldRightWithStart:(id)start block:(id (^)(id accumulator, id value))block;

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
 Zips the receiver, whose objects should be arrays, by creating a new array whose objects will be arrays containing an object from each of the objects in the receiver.
 
 For example, given `@[@[@1,@2,@3],@[@4,@5,@6]]`, `MER_zip` would return `@[@[@1,@4],@[@2,@5],@[@3,@6]]`.
 
 @return The zipped array
 @warning *NOTE:* The count of the arrays in the receiver should be equal. If not, the count of the returned array is clamped to the minimum count of the arrays in the receiver
 */
- (NSArray *)MER_zip;
/**
 Zips the receiver with _array_ and returns the resulting array.
 
 @param array The array to zip the receiver with
 @return The zipped array
 */
- (NSArray *)MER_zipWith:(NSArray *)array;

/**
 Unzips the receiver, whose objects should be arrays, by creating a new array whose objects will be arrays containing an object from each of the objects in the receiver.
 
 For example, given `@[@[@1,@4],@[@2,@5],@[@3,@6]]`, `MER_unzip` would return `@[@[@1,@2,@3],@[@4,@5,@6]]`.
 
 @return The unzipped array
 @warning *NOTE:* The count of the arrays in the receiver should be equal. If not, the count of the returned array is clamped to the minimum count of the arrays in the receiver
 */
- (NSArray *)MER_unzip;
/**
 Unzips the receiver with _array_ and returns the resulting array.
 
 @param array The array to unzip the receiver with
 @return The unzipped array
 */
- (NSArray *)MER_unzipWith:(NSArray *)array;

/**
 Returns a subarray of the receiver, starting at index 0, whose count is _take_.
 
 If _take_ is >= `count`, returns the receiver.
 
 @param take The count of the returned subarray
 @return The subarray of the receiver
 */
- (NSArray *)MER_take:(NSUInteger)take;
/**
 Returns a subarray of the receiver, starting at index _drop_, whose count is `count` - _drop_.
 
 If _drop_ is >= `count`, returns the receiver.
 
 @param drop The number of objects to drop from the returned subarray
 @return The subarray of the receiver
 */
- (NSArray *)MER_drop:(NSUInteger)drop;

/**
 Returns an array containing two subarrays of the receiver. The first subarray starts at index 0 and count is _splitAt_. The second subarray starts at index _splitAt_ and count is `count` is - _splitAt_.
 
 If _splitAt_ >= `count`, returns an array containing the receiver as the first subarray and an empty array as the second subarray.
 
 @param splitAt The index at which to split the receiver
 @return The array containing the subarrays of the receiver
 */
- (NSArray *)MER_splitAt:(NSUInteger)splitAt;

/**
 Returns an array containing the objects of the receiver in reverse order.
 
 Calls through to `MERFoldRight`.
 
 @return The reversed array
 */
- (NSArray *)MER_reverse;

/**
 Returns an array which is the concatination of the receiver's objects, which should be arrays.
 
 Concatinates the receiver's objects from left to right.
 
 @return The concatinated array
 */
- (NSArray *)MER_concat;
/**
 Concatinates the receiver with _array_ and returns the resulting array.
 
 @param array The array to concatinate the receiver with
 @return The concatinated array
 */
- (NSArray *)MER_concatWith:(NSArray *)array;

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
