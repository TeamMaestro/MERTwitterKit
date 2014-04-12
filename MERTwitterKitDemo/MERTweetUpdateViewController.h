//
//  MERTweetUpdateViewController.h
//  MERTwitterKit
//
//  Created by William Towe on 4/12/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MERTwitterKitTweetViewModel;

typedef void(^MERTweetUpdateViewControllerCompletionBlock)(MERTwitterKitTweetViewModel *viewModel, NSError *error);

@interface MERTweetUpdateViewController : UIViewController

@property (copy,nonatomic) MERTweetUpdateViewControllerCompletionBlock completionBlock;

@end
