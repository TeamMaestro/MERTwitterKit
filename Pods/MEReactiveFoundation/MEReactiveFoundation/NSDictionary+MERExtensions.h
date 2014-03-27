//
//  NSDictionary+MERExtensions.h
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

#import <Foundation/Foundation.h>

@interface NSDictionary (MERExtensions)

/**
 Returns a dictionary that contains key/value pairs from the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each key/value pair in the receiver. The key/value are passed into the block. The block should return YES if the resulting dictionary should contain the key/value pair, NO otherwise
 @return The filtered dictionary
 @exception NSException Thrown if _block_ is nil
 */
- (NSDictionary *)MER_filter:(BOOL (^)(id<NSCopying> key, id value))block;

/**
 Returns the first key/value pair in the receiver for which _block_ returns YES.
 
 @param block The block that is invoked for each key/value pair in the receiver. The key/value are passed into the block. If the block returns YES, the key/value pair is returned from the method
 @return The found key/value pair or nil
 @exception NSException Thrown if _block_ is nil
 */
- (NSArray *)MER_find:(BOOL (^)(id<NSCopying> key, id value))block;

/**
 Returns a dictionary that is the result of mapping _block_ over each key/value pair in the receiver.
 
 @param block The block that is invoked for each key/value pair in the receiver. The key/value are passed into the block. The block should return the mapped key/value pair
 @return The mapped dictionary
 @exception NSException Thrown if _block_ is nil
 @warning *NOTE:* _block_ may return nil, if it does, the passed in key will be mapped to `[NSNull null]` in the mapped key/value pair
 */
- (NSDictionary *)MER_map:(NSArray* (^)(id<NSCopying> key, id value))block;

/**
 Returns a single object which the result of folding the receiver from left to right.
 
 @param start The starting value for the fold. It will be passed as _accumulator_ on the first invocation of _block_
 @param block The block that is invoked for each key/value pair in the receiver. _accumulator_ is the value returned from the previous invocation of _block_, _key_ and _value_ are the current key/value pair
 @exception NSException Thrown if _block_ is nil
 */
- (id)MER_foldLeftWithStart:(id)start block:(id (^)(id accumulator, id<NSCopying> key, id value))block;

/**
 Returns YES if _block_ returns YES for any of the key/value pairs in the receiver, NO otherwise.
 
 @param block The block that is invoked for each key/value pair in the receiver. The key/value are passed into the block. If the block returns YES, the enumeration ends
 @return YES if _block_ returns YES once, NO otherwise
 @exception NSException Thrown if _block_ is nil
 */
- (BOOL)MER_any:(BOOL (^)(id<NSCopying> key, id value))block;
/**
 Returns YES if _block_ returns YES for all of the key/value pairs in the receiver, NO otherwise.
 
 @param block The block that is invoked for each key/value pair in the receiver. The key/value pair are passed into the block. If the block returns NO, the enumeration ends
 @return YES if _block_ returns YES for all of the key/value pairs in the receiver, NO otherwise
 @exception NSException Thrown if _block_ is nil
 */
- (BOOL)MER_all:(BOOL (^)(id<NSCopying> key, id value))block;

/**
 Returns a dictionary that contains the reversed key/value pairs of the receiver.
 
 For example, `@{@1,@"one"}` would reverse to `@{@"one",@1}`.
 
 Calls through to `MER_map:`.
 
 @return The reversed dictionary
 */
- (NSDictionary *)MER_reverse;

@end
