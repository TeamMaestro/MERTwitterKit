//
//  MERTwitterClient+Tweets.h
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
 Methods to interact with Tweets group of the _statuses_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Tweets)

/**
 Returns local `MERTwitterTweetViewModel` instances matching the specified parameters.
 
 The tweets are ordered by their identity, in descending order (i.e. largest identity first).
 
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of tweets the fetch should return. The default is 0, which means no limit
 */
- (NSArray *)fetchTweetsAfterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/%3Aid
 
 @param identity The identity of the tweet for which to request retweets
 @param count The maximum number of results to return. The default is 20
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestRetweetsOfTweetWithIdentity:(int64_t)identity count:(NSUInteger)count;

/**
 Returns the local `MERTwitterTweetViewModel` with the provided _identity_.
 
 @param identity The identity of the tweet to return
 @return The tweet with the provided _identity_
 @exception NSException Thrown if _identity_ is <= 0
 @see requestTweetWithIdentity:
 */
- (MERTwitterTweetViewModel *)fetchTweetWithIdentity:(int64_t)identity;
/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` instance, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
 
 @param identity The identity of the tweet to request
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestTweetWithIdentity:(int64_t)identity;

/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` representing the destroyed tweet, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/%3Aid
 
 @param identity The identity of the tweet to destroy
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestDestroyTweetWithIdentity:(int16_t)identity;

/**
 Calls `requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:`, passing _status_, nil, 0, `kCLLocationCoordinate2DInvalid`, and nil respectively.
 
 @param status The status to update with
 @return The signal
 @exception NSException Thrown if _status_ is nil
 @see requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:
 */
- (RACSignal *)requestUpdateWithStatus:(NSString *)status;
/**
 Calls `requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:`, passing _status_, nil, _replyIdentity_, `kCLLocationCoordinate2DInvalid`, and nil respectively.
 
 @param status The status to update with
 @param replyIdentity The identity of the tweet to reply to
 @return The signal
 @exception NSException Thrown if _status_ is nil
 @see requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:
 */
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity;
/**
 Calls `requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:`, passing _status_, nil, _replyIdentity_, _location_, and _placeIdentity_ respectively.
 
 @param status The status to update with
 @param replyIdentity The identity of the tweet to reply to
 @param location The location to attach to the update
 @param placeIdentity The identity of the place to attach to the update
 @return The signal
 @exception NSException Thrown if _status_ is nil
 @see requestUpdateWithStatus:media:replyIdentity:location:placeIdentity:
 */
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity;
/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` that represents the provided _status_, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/statuses/update and https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media
 
 @param status The status to update with
 @param media An array of `UIImage` instances to attach to the update
 @param replyIdentity The identity of the tweet to reply to
 @param location The location to attach to the update
 @param placeIdentity The identity of the place to attach to the updates
 @return The signal
 @exception NSException Thrown if _status_ is nil
 */
- (RACSignal *)requestUpdateWithStatus:(NSString *)status media:(NSArray *)media replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity;

/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` representing the retweeted status, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/%3Aid
 
 @param identity The identity of the tweet to retweet
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestUpdateWithRetweetOfTweetWithIdentity:(int64_t)identity;

@end
