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

@interface MERTwitterClient (Tweets)

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

@end
