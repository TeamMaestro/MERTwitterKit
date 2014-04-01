//
//  MERTweetViewModel.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTwitterKitTweetViewModel.h"
#import "TwitterKitTweet.h"
#import "TwitterKitUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MERTwitterKitUserViewModel.h"

@interface MERTwitterKitTweetViewModel ()
@property (strong,nonatomic) TwitterKitTweet *tweet;

@property (readwrite,strong,nonatomic) MERTwitterKitUserViewModel *userViewModel;
@end

@implementation MERTwitterKitTweetViewModel

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
    [self setUserViewModel:[MERTwitterKitUserViewModel viewModelWithUser:self.tweet.user]];
    
    return self;
}

- (NSString *)text {
    return self.tweet.text;
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

@end
