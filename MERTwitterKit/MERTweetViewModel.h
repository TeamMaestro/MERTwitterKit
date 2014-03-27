//
//  MERTweetViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "RVMViewModel.h"

@class MERTweet;

@interface MERTweetViewModel : RVMViewModel

@property (readonly,nonatomic) NSString *text;

- (instancetype)initWithTweet:(MERTweet *)tweet;

@end
