//
//  MERTwitterClient+FriendsAndFollowers.h
//  MERTwitterKit
//
//  Created by William Towe on 4/15/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTwitterClient.h"

/**
 Mask describing the friendship status of a user related to the authenticated user.
 
 - `MERTwitterClientFriendshipStatusNone`, no friendship :(
 - `MERTwitterClientFriendshipStatusFollowing`, the authenticated user is following the user
 - `MERTwitterClientFriendshipStatusFollowingRequested`, the authenticated user has a following request pending for the user
 - `MERTwitterClientFriendshipStatusFollowedBy`, the authenticated user is followed by the user
 - `MERTwitterClientFriendshipStatusBlocking`, the authenticated user is blocking the user
 */
typedef NS_OPTIONS(NSInteger, MERTwitterClientFriendshipStatus) {
    MERTwitterClientFriendshipStatusNone = 0,
    MERTwitterClientFriendshipStatusFollowing = 1 << 0,
    MERTwitterClientFriendshipStatusFollowingRequested = 1 << 1,
    MERTwitterClientFriendshipStatusFollowedBy = 1 << 2,
    MERTwitterClientFriendshipStatusBlocking = 1 << 3
};

/**
 Methods to interact with the _friends_, _followers_, and _friendships_ resource families of the Twitter API.
 */
@interface MERTwitterClient (FriendsAndFollowers)

/**
 Returns a signal that sends `next` with a `MERTwitterUserViewModel` object representing the friended user, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide either _identity_ or _screenName_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/friendships/create
 
 @param identity The identity of the user to request friendship for
 @param screenName The screen name of the user to request friendship for
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 @see requestFriendshipDestroyForUserWithIdentity:screenName:
 */
- (RACSignal *)requestFriendshipCreateForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
/**
 Returns a signal that sends `next` with a `MERTwitterUserViewModel` object representing the un-friended user, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide either _identity_ or _screenName_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/friendships/destroy
 
 @param identity The identity of the user to destroy friendship for
 @param screenName The screen name of the user to destroy friendship for
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 @see requestFriendshipCreateForUserWithIdentity:screenName:
 */
- (RACSignal *)requestFriendshipDestroyForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;

/**
 Returns a signal that sends `next` with a `RACTuple` containing an array of `MERTwitterUserViewModel` instances, the next _cursor_ value, and the previous _cursor_ value, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide either _identity_ or _screenName_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/friends/list
 
 @param identity The identity of user for which to request friends
 @param screenName The screen name of the user for which to request friends
 @param count The maximum number of friends the request should return. The default is 20
 @param cursor The cursor value that determines which page of friends to return. The default value is MERTwitterClientCursorInitial, which means "return the first page"
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 @see requestFollowersForUserWithIdentity:screenName:count:cursor:
 */
- (RACSignal *)requestFriendsForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;
/**
 Returns a signal that sends `next` with a `RACTuple` containing an array of `MERTwitterUserViewModel` instances, the next _cursor_ value, and the previous _cursor_ value, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide either _identity_ or _screenName_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/followers/list
 
 @param identity The identity of the user for which to request followers
 @param screenName The screen name of the user for which to request followers
 @param count The maximum number of followers the request should return. The default is 20
 @param cursor The cursor value that determines which page of followers to return. The default value is MERTwitterClientCursorInitial, which means "return the first page"
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 @see requestFriendsForUserWithIdentity:screenName:count:cursor:
 */
- (RACSignal *)requestFollowersForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;

/**
 Calls `requestFriendshipStatusForUsersWithIdentities:screenNames:`, passing `@[@(identity)]` and/or `@[screenName]`.
 
 You must provide either _identity_ or _screenName_.
 
 @param identity The identity of the user for which to request friendship status
 @param screenName The screen name of the user for which to request friendship status
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 @see requestFriendshipStatusForUsersWithIdentities:screenNames:
 */
- (RACSignal *)requestFriendshipStatusForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
/**
 Returns a signal that sends `next` with an array of `RACTuple` instances, each containing a `MERTwitterUserViewModel` instance and a `MERTwitterClientFriendshipStatus` value, indicating the friendship status of the user related to the authenticated user. If the request cannot be completed, sends `error`.
 
 You must provide either _identities_ or _screenNames_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/friendships/lookup
 
 @param identities The array of identities for which to request friendship status
 @param screenNames The array of screen names for which to request friendship status
 @return The signal
 @exception NSException Thrown if _identities_ and _screenNames_ are nil
 */
- (RACSignal *)requestFriendshipStatusForUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames;

@end
