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

@property (readonly,strong,nonatomic) MERTwitterKitUserViewModel *userViewModel;

- (instancetype)initWithTweet:(TwitterKitTweet *)tweet;

@end
