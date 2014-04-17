//
//  MERTwitterClient+Timelines.h
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
 Methods to interact with the Timelines group of the _statuses_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Timelines)

/**
 Returns a signal that sends `next` with an array of 'MERTwitterTweetViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/mentions_timeline
 
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of favorites the request should return. The default is 20
 @return The signal
 */
- (RACSignal *)requestMentionsTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

/**
 Returns local `MERTwitterTweetViewModel` instances belonging to the authenticated user.
 
 The tweets are sorted by their identity, in descending order (i.e. largest identity first).
 
 You must provide _userIdentity_ or _screenName_.
 
 @param userIdentity The identity of the user for which to return tweets
 @param screenName The screen name of the user for which to return tweets
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of tweets the request should return. The default is 0, which means no limit
 @return The array of tweets
 @exception NSException Thrown if _userIdentity_ is <= 0 and _screenName_ is nil
 */
- (NSArray *)fetchUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
 
 @param userIdentity The identity of the user for which to return tweets
 @param screenName The screen name of the user for which to return tweets
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of tweets the request should return. The default is 20
 @return The signal
 @exception NSException Thrown if _userIdentity_ is <= 0 and _screenName_ is nil
 */
- (RACSignal *)requestUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
 
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of tweets the request should return. The default is 20
 @return The signal
 */
- (RACSignal *)requestHomeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/retweets_of_me
 
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of tweets the request should return. The default is 20
 @return The signal
 */
- (RACSignal *)requestRetweetsOfMeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

@end
