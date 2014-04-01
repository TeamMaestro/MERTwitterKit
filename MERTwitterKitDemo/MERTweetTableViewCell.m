//
//  MERTweetTableViewCell.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTweetTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface MERTweetTableViewCell ()
@property (weak,nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak,nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak,nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *tweetCreatedAtLabel;
@end

@implementation MERTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    RAC(self.tweetTextLabel,text) = RACObserve(self, viewModel.text);
    RAC(self.profileImageView,image) = RACObserve(self, viewModel.userViewModel.profileImage);
    RAC(self.userNameLabel,text) = RACObserve(self, viewModel.userViewModel.name);
    RAC(self.userScreenNameLabel,text) = RACObserve(self, viewModel.userViewModel.screenName);
    RAC(self.tweetCreatedAtLabel,text) = RACObserve(self, viewModel.relativeCreatedAtString);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.viewModel.userViewModel setActive:NO];
}

+ (CGFloat)estimatedRowHeight; {
    return 44;
}

- (void)setViewModel:(MERTwitterKitTweetViewModel *)viewModel {
    _viewModel = viewModel;
    
    [viewModel.userViewModel setActive:YES];
}

@end
