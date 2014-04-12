//
//  MERTwitterKitTweetViewModel+Private.h
//  MERTwitterKit
//
//  Created by William Towe on 4/12/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTwitterKitTweetViewModel.h"
#import "TwitterKitTweet.h"

@interface MERTwitterKitTweetViewModel (Private)

+ (instancetype)viewModelWithTweet:(TwitterKitTweet *)tweet;

@end
