//
//  MERTweetTableViewCell.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTweetTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEReactiveFoundation/MEReactiveFoundation.h>

@interface MERTweetTableViewCell ()
@property (weak,nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak,nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak,nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *tweetCreatedAtLabel;
@property (weak,nonatomic) IBOutlet UIImageView *mediaThumbnailImageView;
@end

@implementation MERTweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    RAC(self.tweetTextLabel,attributedText) = [[RACObserve(self, viewModel) ignore:nil] map:^id(MERTwitterKitTweetViewModel *value) {
        @strongify(self);
        
        NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:value.text attributes:@{NSFontAttributeName: self.tweetTextLabel.font,NSForegroundColorAttributeName: [UIColor blackColor]}];
        
        for (NSValue *hashtagRange in value.hashtagRanges) {
            [retval addAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} range:hashtagRange.rangeValue];
        }
        for (NSValue *urlRange in value.urlRanges) {
            [retval addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]} range:urlRange.rangeValue];
        }
        for (NSValue *urlRange in value.mediaRanges) {
            [retval addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]} range:urlRange.rangeValue];
        }
        for (NSValue *urlRange in value.mentionRanges) {
            [retval addAttributes:@{NSForegroundColorAttributeName: [UIColor purpleColor]} range:urlRange.rangeValue];
        }
        for (NSValue *urlRange in value.symbolRanges) {
            [retval addAttributes:@{NSForegroundColorAttributeName: [UIColor magentaColor]} range:urlRange.rangeValue];
        }
        
        return retval;
    }];
    RAC(self.profileImageView,image) = RACObserve(self, viewModel.userViewModel.profileImage);
    RAC(self.userNameLabel,text) = RACObserve(self, viewModel.userViewModel.name);
    RAC(self.userScreenNameLabel,text) = RACObserve(self, viewModel.userViewModel.screenName);
    RAC(self.tweetCreatedAtLabel,text) = RACObserve(self, viewModel.relativeCreatedAtString);
    RAC(self.mediaThumbnailImageView,image) = RACObserve(self, viewModel.mediaThumbnailImage);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.viewModel setActive:NO];
    [self.viewModel.userViewModel setActive:NO];
}

+ (CGFloat)estimatedRowHeight; {
    return 44;
}

- (void)setViewModel:(MERTwitterKitTweetViewModel *)viewModel {
    _viewModel = viewModel;
    
    [viewModel setActive:YES];
    [viewModel.userViewModel setActive:YES];
}

@end
