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

typedef NS_OPTIONS(NSInteger, MERTwitterClientFriendshipStatus) {
    MERTwitterClientFriendshipStatusNone = 0,
    MERTwitterClientFriendshipStatusFollowing = 1 << 0,
    MERTwitterClientFriendshipStatusFollowingRequested = 1 << 1,
    MERTwitterClientFriendshipStatusFollowedBy = 1 << 2,
    MERTwitterClientFriendshipStatusBlocking = 1 << 3
};

@interface MERTwitterClient (FriendsAndFollowers)

- (RACSignal *)requestFriendshipCreateForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
- (RACSignal *)requestFriendshipDestroyForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;

- (RACSignal *)requestFriendsForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;
- (RACSignal *)requestFollowersForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;

- (RACSignal *)requestFriendshipStatusForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
- (RACSignal *)requestFriendshipStatusForUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames;

@end
