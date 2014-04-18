//
//  MERTwitterUserViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/31/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RVMViewModel.h"
#import <UIKit/UIImage.h>

/**
 `MERTwitterUserViewModel` is a `RVMViewModel` subclass that represents a User returned from the Twitter API.
 
 More information can be found at https://dev.twitter.com/docs/platform-objects/users
 */
@interface MERTwitterUserViewModel : RVMViewModel

/**
 The identity of the User. This is unique.
 
 The `id` of the User JSON object.
 */
@property (readonly,nonatomic) int64_t identity;

/**
 The name of the User (e.g. Peter Parker).
 
 The `name` of the User JSON object.
 */
@property (readonly,nonatomic) NSString *name;
/**
 The screen name of the User (e.g. @peteparker).
 
 The `screen_name` of the User JSON object.
 */
@property (readonly,nonatomic) NSString *screenName;
/**
 The profile image of the User.
 
 The property is initially nil, and is fetched asynchronously once the receiver's `active` property is set to YES. You should bind to this property with ReactiveCocoa to be notified when the image is fetched.
 
 See `MERTweetTableViewCell` within the MERTwitterKitDemo group for an example.
 */
@property (readonly,strong,nonatomic) UIImage *profileImage;

@end
