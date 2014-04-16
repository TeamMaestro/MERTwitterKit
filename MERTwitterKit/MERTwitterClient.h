//
//  MERTwitterClient.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <CoreLocation/CoreLocation.h>

/**
 The initial value to pass when calling a method containing a _cursor_ parameter.
 
 For example, when calling `requestFriendsForUserWithIdentity:screenName:count:cursor:`, you would pass `MERTwitterClientCursorInitial` for the _cursor_ parameter.
 */
extern int64_t const MERTwitterClientCursorInitial;

/**
 The domain for errors specific to the MERTwitterKit framework.
 */
extern NSString *const MERTwitterClientErrorDomain;

/**
 The error code indicating the user has not setup any Twitter accounts on the device.
 */
extern NSInteger const MERTwitterClientErrorCodeNoAccounts;

/**
 These keys are used to give more detailed information about errors specific to the MERTwitterKit framework.
 */
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertMessage;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle;

/**
 The name of the MERTwitterKit resources bundle.
 */
extern NSString *const MERTwitterKitResourcesBundleName;
/**
 Returns the MERTwitterKit resources bundle.
 
 @return The resources bundle
 */
extern NSBundle *MERTwitterKitResourcesBundle(void);

@class RACSignal;
@class MERTwitterTweetViewModel;

/**
 `MERTwitterClient` presents a wrapper around the Twitter 1.1 API, built on top of AFNetworking and ReactiveCocoa.
 
 More information about AFNetworking can be found at https://github.com/AFNetworking/AFNetworking
 More information about ReactiveCocoa can be found at https://github.com/ReactiveCocoa/ReactiveCocoa
 More information about the Twitter 1.1 API can be found at https://dev.twitter.com/docs/api/1.1
 
 You can either use the `sharedClient` class method, or `[[MERTwitterClient alloc] init]` your own instance of this class.
 
 Before any requests can be made, an `ACAccount` instance must be assigned to the receiver. You can retrieve the Twitter present on the device by using the `requestAccounts` method.
 */
@interface MERTwitterClient : NSObject

/**
 The `ACAccount` instance assigned to the receiver, which will be used to authorize all requests made to the Twitter API.
 
 @warning *NOTE:* Any requests made prior to setting an account on the receiver will result in a 401 unauthorized error.
 */
@property (strong,nonatomic) ACAccount *selectedAccount;

/**
 Returns the shared client instance.
 
 You can also `[[MERTwitterClient alloc] init]` your own instances.
 */
+ (instancetype)sharedClient;

/**
 Returns a signal that sends `next` with an array of `ACAccount` instances, then `completes`.
 
 If the user denies the application access, sends `error` with `MERTwitterClientErrorCodeNoAccounts`.
 */
- (RACSignal *)requestAccounts;

@end
