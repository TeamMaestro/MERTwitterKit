//
//  MERTweetViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "RVMViewModel.h"
#import <UIKit/UIImage.h>

@class TwitterKitTweet;
@class MERTwitterKitUserViewModel;

@interface MERTwitterKitTweetViewModel : RVMViewModel

@property (readonly,nonatomic) NSString *text;
@property (readonly,nonatomic) NSSet *hashtagRanges;
@property (readonly,nonatomic) NSSet *mediaRanges;
@property (readonly,nonatomic) NSSet *mentionRanges;
@property (readonly,nonatomic) NSSet *symbolRanges;
@property (readonly,nonatomic) NSSet *urlRanges;

@property (readonly,nonatomic) NSDate *createdAt;
@property (readonly,nonatomic) NSString *relativeCreatedAtString;

@property (readonly,strong,nonatomic) MERTwitterKitUserViewModel *userViewModel;

- (instancetype)initWithTweet:(TwitterKitTweet *)tweet;

@end
