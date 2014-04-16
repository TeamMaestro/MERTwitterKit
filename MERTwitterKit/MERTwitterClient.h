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

- (RACSignal *)requestAccounts;

@end
