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
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, MERTwitterClientSearchType) {
    MERTwitterClientSearchTypeMixed,
    MERTwitterClientSearchTypeRecent,
    MERTwitterClientSearchTypePopular
};

extern int64_t const MERTwitterClientCursorInitial;

extern NSString *const MERTwitterClientErrorDomain;

extern NSInteger const MERTwitterClientErrorCodeNoAccounts;

extern NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertMessage;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle;

extern NSString *const MERTwitterKitResourcesBundleName;
extern NSBundle *MERTwitterKitResourcesBundle(void);

@class MERTwitterKitTweetViewModel;

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

- (MERTwitterKitTweetViewModel *)fetchTweetWithIdentity:(int64_t)identity;
- (RACSignal *)requestTweetWithIdentity:(int64_t)identity;

- (RACSignal *)requestDestroyTweetWithIdentity:(int16_t)identity;

- (RACSignal *)requestUpdateWithStatus:(NSString *)status;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity latitude:(CGFloat)latitude longitude:(CGFloat)longitude placeIdentity:(NSString *)placeIdentity;
- (RACSignal *)requestUpdateWithStatus:(NSString *)status media:(NSArray *)media replyIdentity:(int64_t)replyIdentity latitude:(CGFloat)latitude longitude:(CGFloat)longitude placeIdentity:(NSString *)placeIdentity;

- (RACSignal *)requestRetweetOfTweetWithIdentity:(int64_t)identity;

- (RACSignal *)requestRetweetersOfTweetWithIdentity:(int64_t)identity cursor:(int64_t)cursor;
#pragma mark Search
- (RACSignal *)requestTweetsMatchingSearch:(NSString *)search type:(MERTwitterClientSearchType)type afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

@end
