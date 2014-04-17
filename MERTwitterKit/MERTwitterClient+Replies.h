//
//  MERTwitterClient+Replies.h
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
 Methods to request dicussion threads and replies. Similar to the "Thread/Replies" view in Twitterrific and the replies at the top of the "Detail" view in Tweetbot.
 */
@interface MERTwitterClient (Replies)

/**
 Returns local `MERTwitterTweetViewModel` instances that belong to the discussion thread rooted at the tweet with the provided _identity_.
 
 The view models are sorted by their identity, in descending order (i.e. largest identity first).
 
 This method will include all tweets in a discussion thread, going back to the tweet that started the discussion.
 
 @param identity The identity of the tweet for which to fetch discussion thread tweets
 @return The array of discussion thread tweets
 @exception NSException Thrown if _identity_ is 0
 @see requestThreadForTweetsWithIdentity:
 @see [MERTwitterTweetViewModel threadTweets]
 */
- (NSArray *)fetchThreadForTweetWithIdentity:(int64_t)identity;
/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances representing the tweets of a discussion thread rooted at the tweet with the provided _identity_, then `completes`. If the request cannot be completed, sends `error`.
 
 At a high level, this works by inspecting the `in_reply_to_status_id` key of the Tweet objects the Twitter API returns. If a Tweet object contains the `in_reply_to_status_id` object another request is made to fetch that object using `requestTweetWithIdentity:`. This process is repeated until a tweet is encountered whose `in_reply_to_status_id` key is nil. That object is the root of the discussion thread.
 
 @param identity The identity of the tweet for which to request discussion thread tweets
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 @see fetchThreadForTweetWithIdentity:
 */
- (RACSignal *)requestThreadForTweetWithIdentity:(int64_t)identity;

/**
 Returns local `MERTwitterTweetViewModel` instances that are replies to the tweet with the provided _identity_.
 
 The view models are sorted by their identity, in descending order (i.e. largest identity first).
 
 This method only returns tweets that are replies to the tweet with the provided _identity_. Tweets that are part of a discussion thread involving the tweet with _identity_ will be omitted if they are not a reply to the tweet with _identity_.
 
 @param identity The identity of the tweet for which to fetch replies
 @return The array of replies
 @exception NSException NSException Thrown if _identity_ is <= 0
 @see requestRepliesForTweetWithIdentity:afterIdentity:beforeIdentity:count:
 */
- (NSArray *)fetchRepliesForTweetWithIdentity:(int64_t)identity;
/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances representing the replies to the tweet with the provided _identity_, then `completes`. If the request cannot be completed, sends `error`.
 
 @param identity The identity of the tweet for which to request replies
 @param afterIdentity The identity of the tweet for which to return favorites whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return favorites whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of favorites the request should return. The default is 20
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestRepliesForTweetWithIdentity:(int64_t)identity afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

@end
