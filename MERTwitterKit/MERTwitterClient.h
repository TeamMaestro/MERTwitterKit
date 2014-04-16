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

typedef NS_ENUM(NSInteger, MERTwitterClientSearchType) {
    MERTwitterClientSearchTypeMixed,
    MERTwitterClientSearchTypeRecent,
    MERTwitterClientSearchTypePopular
};

typedef NS_OPTIONS(NSInteger, MERTwitterClientFriendshipStatus) {
    MERTwitterClientFriendshipStatusNone = 0,
    MERTwitterClientFriendshipStatusFollowing = 1 << 0,
    MERTwitterClientFriendshipStatusFollowingRequested = 1 << 1,
    MERTwitterClientFriendshipStatusFollowedBy = 1 << 2,
    MERTwitterClientFriendshipStatusBlocking = 1 << 3
};

typedef NS_ENUM(NSInteger, MERTwitterClientGeoGranularity) {
    MERTwitterClientGeoGranularityNeighborhood,
    MERTwitterClientGeoGranularityPOI,
    MERTwitterClientGeoGranularityCity,
    MERTwitterClientGeoGranularityAdmin,
    MERTwitterClientGeoGranularityCountry
};

extern int64_t const MERTwitterClientCursorInitial;

extern NSString *const MERTwitterClientErrorDomain;

extern NSInteger const MERTwitterClientErrorCodeNoAccounts;

extern NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertMessage;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle;

extern NSString *const MERTwitterKitResourcesBundleName;
extern NSBundle *MERTwitterKitResourcesBundle(void);

@class RACSignal;
@class MERTwitterTweetViewModel;

@interface MERTwitterClient : NSObject

@property (strong,nonatomic) ACAccount *selectedAccount;

+ (instancetype)sharedClient;
#pragma mark Accounts
- (RACSignal *)requestAccounts;
#pragma mark Timelines
- (RACSignal *)requestMentionsTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

- (NSArray *)fetchUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
- (RACSignal *)requestUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

- (RACSignal *)requestHomeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
- (RACSignal *)requestRetweetsOfMeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
#pragma mark Tweets
- (NSArray *)fetchTweetsAfterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

- (RACSignal *)requestRetweetsOfTweetWithIdentity:(int64_t)identity count:(NSUInteger)count;

- (MERTwitterTweetViewModel *)fetchTweetWithIdentity:(int64_t)identity;
- (RACSignal *)requestTweetWithIdentity:(int64_t)identity;

- (RACSignal *)requestDestroyTweetWithIdentity:(int16_t)identity;

- (RACSignal *)requestUpdateWithStatus:(NSString *)status;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status media:(NSArray *)media replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity;

- (RACSignal *)requestRetweetOfTweetWithIdentity:(int64_t)identity;
#pragma mark Replies
- (NSArray *)fetchRepliesForTweetWithIdentity:(int64_t)identity;
- (RACSignal *)requestRepliesForTweetWithIdentity:(int64_t)identity;
#pragma mark Search
- (NSArray *)fetchTweetsMatchingSearch:(NSString *)search afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
- (RACSignal *)requestTweetsMatchingSearch:(NSString *)search type:(MERTwitterClientSearchType)type afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
#pragma mark Streaming
- (RACSignal *)requestStreamForTweetsMatchingKeywords:(NSArray *)keywords userIdentities:(NSArray *)userIdentities locations:(NSArray *)locations;
#pragma mark Friends & Followers
- (RACSignal *)requestFriendshipCreateForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
- (RACSignal *)requestFriendshipDestroyForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;

- (RACSignal *)requestFriendsForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;
- (RACSignal *)requestFollowersForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor;

- (RACSignal *)requestFriendshipStatusForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName;
- (RACSignal *)requestFriendshipStatusForUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames;
#pragma mark Users
- (RACSignal *)requestUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames;

- (RACSignal *)requestUsersMatchingSearch:(NSString *)search page:(NSUInteger)page count:(NSUInteger)count;
#pragma mark Favorites
- (RACSignal *)requestFavoritesForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

- (RACSignal *)requestFavoriteCreateForTweetWithIdentity:(int64_t)identity;
- (RACSignal *)requestFavoriteDestroyForTweetWithIdentity:(int64_t)identity;
#pragma mark Places & Geo
- (RACSignal *)requestPlaceWithIdentity:(NSString *)identity;
- (RACSignal *)requestPlacesWithLocation:(CLLocationCoordinate2D)location accuracy:(CLLocationDistance)accuracy granularity:(MERTwitterClientGeoGranularity)granularity count:(NSUInteger)count;
- (RACSignal *)requestPlacesMatchingLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude ipAddress:(NSString *)ipAddress query:(NSString *)query containedWithinPlaceWithIdentity:(NSString *)placeIdentity accuracy:(CLLocationDistance)accuracy granularity:(MERTwitterClientGeoGranularity)granularity count:(NSUInteger)count;
- (RACSignal *)requestPlacesSimilarToPlaceWithName:(NSString *)name location:(CLLocationCoordinate2D)location containedWithinPlaceWithIdentity:(NSString *)placeIdentity;

@end
