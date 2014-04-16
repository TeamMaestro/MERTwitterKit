//
//  MERTwitterClient+Favorites.h
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
 Methods to interact with the _favorites_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Favorites)

/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` objects, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide _identity_ or _screenName_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/favorites/list
 
 @param identity The identity of the user for which to request favorites
 @param screenName The screen name of the user for which to request favorites
 @param afterIdentity The identity of the tweet for which to return favorites whose identity is greater than (i.e. newer) _afterIdentity_
 @param beforeIdentity The identity of the tweet for which to return favorites whose identity is less than (i.e. older) _beforeIdentity_
 @param count The maximum number of favorites the request should return. The default is 20
 @exception NSException Thrown if _identity_ is <= 0 and _screenName_ is nil
 */
- (RACSignal *)requestFavoritesForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count;

/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` object representing the favorited tweet, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/favorites/create
 
 @param identity The identity of the tweet to favorite
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestFavoriteCreateForTweetWithIdentity:(int64_t)identity;
/**
 Returns a signal that sends `next` with a `MERTwitterTweetViewModel` object representing the un-favorited tweet, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/favorites/destroy
 
 @param identity The identity of the tweet to un-favorite
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestFavoriteDestroyForTweetWithIdentity:(int64_t)identity;

@end
