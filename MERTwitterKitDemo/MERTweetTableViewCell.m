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
@end

@implementation MERTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    RAC(self.tweetTextLabel,text) = RACObserve(self, viewModel.text);
    RAC(self.profileImageView,image) = RACObserve(self, viewModel.userProfileImage);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.viewModel setActive:NO];
}

+ (CGFloat)estimatedRowHeight; {
    return 44;
}

- (void)setViewModel:(MERTweetViewModel *)viewModel {
    _viewModel = viewModel;
    
    [viewModel setActive:YES];
}

@end
