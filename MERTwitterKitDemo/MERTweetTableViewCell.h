//
//  MERTweetTableViewCell.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MERTwitterKit/MERTweetViewModel.h>

@interface MERTweetTableViewCell : UITableViewCell

@property (strong,nonatomic) MERTweetViewModel *viewModel;

+ (CGFloat)estimatedRowHeight;

@end
