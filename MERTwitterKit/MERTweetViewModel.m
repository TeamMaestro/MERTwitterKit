//
//  MERTweetViewModel.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTweetViewModel.h"
#import "MERTweet.h"

@interface MERTweetViewModel ()
@property (strong,nonatomic) MERTweet *tweet;
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

- (instancetype)initWithTweet:(MERTweet *)tweet; {
    if (!(self = [super init]))
    return nil;
    
    NSParameterAssert(tweet);
    
    [self setTweet:tweet];
    
    return self;
}

- (NSString *)text {
    return self.tweet.text;
}

@end
