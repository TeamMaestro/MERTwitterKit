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

@interface MERTweetViewModel : RVMViewModel

@property (readonly,strong,nonatomic) UIImage *userProfileImage;
@property (readonly,nonatomic) NSString *text;

+ (instancetype)viewModelWithTweet:(TwitterKitTweet *)tweet;

@end
