//
//  MERTweetViewModel.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTweetViewModel.h"
#import "TwitterKitTweet.h"
#import "TwitterKitUser.h"
#import <SDWebImage/SDWebImageManager.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>

@interface MERTweetViewModel ()
@property (strong,nonatomic) TwitterKitTweet *tweet;

@property (readwrite,strong,nonatomic) UIImage *userProfileImage;

@property (strong,nonatomic) id<SDWebImageOperation> userProfileImageOperation;

- (instancetype)initWithTweet:(TwitterKitTweet *)tweet;
@end

@implementation MERTweetViewModel

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
    
    @weakify(self);
    
    RAC(self,userProfileImage) = [[RACSignal combineLatest:@[self.didBecomeActiveSignal,[RACSignal return:self.tweet.user.profileImageUrl]] reduce:^id(id _, NSString *value) {
        return value;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);

        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            id<SDWebImageOperation> operation = [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:value] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }];
            
            [self setUserProfileImageOperation:operation];
            
            return nil;
        }];
    }];
    
    [self.didBecomeInactiveSignal
     subscribeNext:^(id _) {
         @strongify(self);
         
         [self.userProfileImageOperation cancel];
         [self setUserProfileImageOperation:nil];
    }];
    
    return self;
}

- (NSString *)text {
    return self.tweet.text;
}

@end
