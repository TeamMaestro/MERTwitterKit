//
//  MERTwitterClient+Streaming.h
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
 Methods to interact with _streaming_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Streaming)

/**
 Returns a signal that sends `next` with an array of `MERTwitterTweetViewModel` instances each time new data is received. The signal will continue sending `next`s until the `RACDisposable` returned from subscribe family of methods has been disposed of. At which point the signal will send `complete`. If the stream cannot be established, sends `error`.
 
 You must provide _keywords_, _userIdentities_, or _locations_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/post/statuses/filter
 
 @param keywords The keywords for which to return tweets
 @param userIdentities The user identities for which to return tweets
 @param locations The locations, passed as `RACTuple`s of `CLLocationCoordinate2D` specifying a bounding box, for which to return tweets. The southwest corner of the bounding box should be the first object in each `RACTuple`
 @return The signal
 @exception NSException Thrown if _keywords_, _userIdentities_, and _locations_ are nil
 @warning *NOTE:* The locations parameter is currently unimplemented
 */
- (RACSignal *)requestStreamForTweetsMatchingKeywords:(NSArray *)keywords userIdentities:(NSArray *)userIdentities locations:(NSArray *)locations;

@end
