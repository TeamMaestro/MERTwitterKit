//
//  MERTweetViewModel.m
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

#import "MERTwitterTweetViewModel.h"
#import "MERTwitterTweetViewModel+Private.h"
#import "MERTwitterUserViewModel+Private.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MERTwitterUserViewModel.h"
#import "TwitterKitUrl.h"
#import <MEReactiveFoundation/MEReactiveFoundation.h>
#import "TwitterKitMention.h"
#import "TwitterKitHashtag.h"
#import "TwitterKitSymbol.h"
#import "TwitterKitMedia.h"
#import <MERThumbnailKit/MERThumbnailKit.h>
#import "TwitterKitMediaRange.h"
#import "MERTwitterClient+Replies.h"

@interface MERTwitterTweetViewModel ()
@property (readwrite,strong,nonatomic) TwitterKitTweet *tweet;

@property (readwrite,strong,nonatomic) UIImage *mediaThumbnailImage;

@property (readwrite,strong,nonatomic) MERTwitterUserViewModel *userViewModel;
@end

@implementation MERTwitterTweetViewModel

- (NSString *)description {
    return [NSString stringWithFormat:@"identity: %@ text: %@",self.tweet.identity,self.tweet.text];
}

- (NSUInteger)hash {
    return self.tweet.hash;
}
- (BOOL)isEqual:(id)object {
    return [self.tweet isEqual:object];
}

+ (instancetype)viewModelWithTweet:(TwitterKitTweet *)tweet; {
    return [[self alloc] initWithTweet:tweet];
}

- (instancetype)initWithTweet:(TwitterKitTweet *)tweet; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(tweet);
    
    [self setTweet:tweet];
    [self setUserViewModel:[MERTwitterUserViewModel viewModelWithUser:self.tweet.user]];
    
    RAC(self,mediaThumbnailImage) = [[[[RACSignal combineLatest:@[self.didBecomeActiveSignal,[RACSignal return:[[(TwitterKitMediaRange *)self.tweet.mediaRanges.anyObject media] mediaUrl]]] reduce:^id(id _, NSString *value){
        return value;
    }] filter:^BOOL(id value) {
        return (value != nil);
    }] flattenMap:^RACStream *(id value) {
        return [[[MERThumbnailManager sharedManager] downloadFileWithURL:[NSURL URLWithString:value] progress:nil] reduceEach:^id (NSURL *url, NSURL *fileURL, NSNumber *_){
            return [UIImage imageWithContentsOfFile:fileURL.path];
        }];
        
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}

- (int64_t)identity {
    return self.tweet.identity.longLongValue;
}

- (NSString *)text {
    return self.tweet.text;
}
- (NSSet *)hashtagRanges {
    return [self.tweet.hashtags MER_map:^id(TwitterKitHashtag *value) {
        return value.range;
    }];
}
- (NSSet *)mediaRanges {
    return [self.tweet.mediaRanges MER_map:^id(TwitterKitMediaRange *value) {
        return value.range;
    }];
}
- (NSSet *)mentionRanges {
    return [self.tweet.mentions MER_map:^id(TwitterKitMention *value) {
        return value.range;
    }];
}
- (NSSet *)symbolRanges {
    return [self.tweet.symbols MER_map:^id(TwitterKitSymbol *value) {
        return value.range;
    }];
}
- (NSSet *)urlRanges {
    return [self.tweet.urls MER_map:^id(TwitterKitUrl *value) {
        return value.range;
    }];
}

- (NSDate *)createdAt {
    return self.tweet.createdAt;
}
- (NSString *)relativeCreatedAtString {
    static NSDateFormatter *kDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [[NSDateFormatter alloc] init];
        
        [kDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [kDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [kDateFormatter setDoesRelativeDateFormatting:YES];
    });
    
    return [kDateFormatter stringFromDate:self.createdAt];
}

- (NSUInteger)favoriteCount {
    return self.tweet.favoriteCount.unsignedIntegerValue;
}
- (NSUInteger)retweetCount {
    return self.tweet.retweetCount.unsignedIntegerValue;
}

- (NSArray *)threadTweets {
    return [[MERTwitterClient sharedClient] fetchThreadForTweetWithIdentity:self.identity];
}

@end
