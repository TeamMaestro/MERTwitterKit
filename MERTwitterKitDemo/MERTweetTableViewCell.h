//
//  MERTweetTableViewCell.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MERTwitterKit/MERTwitterKit.h>

@interface MERTweetTableViewCell : UITableViewCell

@property (strong,nonatomic) MERTwitterKitTweetViewModel *viewModel;

+ (CGFloat)estimatedRowHeight;

@end
