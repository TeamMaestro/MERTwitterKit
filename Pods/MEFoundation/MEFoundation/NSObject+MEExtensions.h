//
//  NSObject+MEExtensions.h
//  MEFoundation
//
//  Created by William Towe on 8/15/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSObject (MEExtensions)

/**
 Calls `objc_getAssociatedObject()` passing `self` and the appropriate key.
 
 @return The represented object for `self` or `nil` if no object has been set.
 */
- (id)ME_representedObject;
/**
 Calls `objc_setAssociatedObject()` passing `self`, the appropriate key, `object` and `OBJC_ASSOCIATION_RETAIN_NONATOMIC`. As the last argument implies, represented objects are always retained, never copied.
 
 @param object The object you want to set as the represented object of the receiver.
 */
- (void)ME_setRepresentedObject:(id)object;

@end