//
//  MERTwitterClient+Search.h
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
 Enum describing the type of search results to return.
 
 - `MERTwitterClientSearchTypeMixed`, return both recent and popular results
 - `MERTwitterClientSearchTypeRecent`, return recent results
 - `MERTwitterClientSearchTypePopular`, return popular results
 */
typedef NS_ENUM(NSInteger, MERTwitterClientSearchType) {
    MERTwitterClientSearchTypeMixed,
    MERTwitterClientSearchTypeRecent,
    MERTwitterClientSearchTypePopular
};

/**
 Methods to interact with the _search_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Search)

/**
 Returns local `MERTwitterTweetViewModel` instances whose `text` property contains the provided _search_ parameter.
 
 The view models are sorted by their identity property, in descending order (i.e. largest identity first).
 
 @param search The search term for which to return tweets
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of favorites the request should return. The default is 0, which means no limit
 @return The array of tweets matching _search_
 @exception NSException Thrown if _search_ is nil
 @see requestTweetsMatchingSearch:type:afterIdentity:beforeIdentity:count:
 */
- (NSArray *)fetchTweetsMatchingSearch:(NSString *)search afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;
/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances matching the provided _search_ parameter.
 
 @param search The search term for which to request tweets
 @param type The type of results to request
 @param afterIdentity The identity of the tweet for which to return tweets whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return tweets whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of favorites the request should return. The default is 20
 @return The signal
 @exception NSException Thrown if _search_ is nil
 @see fetchTweetsMatchingSearch:afterIdentity:beforeIdentity:count:
 */
- (RACSignal *)requestTweetsMatchingSearch:(NSString *)search type:(MERTwitterClientSearchType)type afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

@end
