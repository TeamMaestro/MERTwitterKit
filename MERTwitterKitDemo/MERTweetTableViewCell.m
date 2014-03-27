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
@property (weak,nonatomic) IBOutlet UILabel *tweetTextLabel;
@end

@implementation MERTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tweetTextLabel setTextColor:[UIColor blackColor]];
}

+ (CGFloat)estimatedRowHeight; {
    return 44;
}

- (void)setViewModel:(MERTweetViewModel *)viewModel {
    NSAssert([NSThread isMainThread], @"must be main thread!");
    _viewModel = viewModel;
    
    [self.tweetTextLabel setText:viewModel.text];
    NSLog(@"%@",viewModel.text);
}

@end
