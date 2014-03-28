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
    
    RAC(self.tweetTextLabel,text) = RACObserve(self, viewModel.text);
}

+ (CGFloat)estimatedRowHeight; {
    return 44;
}

@end
