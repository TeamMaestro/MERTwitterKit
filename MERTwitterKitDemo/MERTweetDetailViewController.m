//
//  MERTweetDetailViewController.m
//  MERTwitterKit
//
//  Created by William Towe on 4/12/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTweetDetailViewController.h"
#import <MERTwitterKit/MERTwitterKit.h>
#import <libextobjc/EXTScope.h>
#import "MERTweetsTableViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MERTweetDetailViewController ()
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@property (weak,nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak,nonatomic) IBOutlet UILabel *textLabel;
@property (weak,nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak,nonatomic) IBOutlet UILabel *retweetCountLabel;

@property (strong,nonatomic) MERTwitterKitTweetViewModel *viewModel;
@end

@implementation MERTweetDetailViewController

- (NSString *)title {
    return @"Detail";
}
- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    
    UIBarButtonItem *retweetItem = [[UIBarButtonItem alloc] initWithTitle:@"Retweet" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    [retweetItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [retval setRightBarButtonItems:@[retweetItem]];
    
    return retval;
}

- (NSArray *)toolbarItems {
    UIBarButtonItem *retweetsItem = [[UIBarButtonItem alloc] initWithTitle:@"RTs" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    @weakify(self);
    
    [retweetsItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[[[[MERTwitterClient sharedClient] requestRetweetsOfTweetWithIdentity:self.viewModel.identity count:0] initially:^{
                [SVProgressHUD show];
            }] finally:^{
                [SVProgressHUD dismiss];
            }]
             subscribeNext:^(NSArray *value) {
                 @strongify(self);
                 
                 MERTweetsTableViewController *viewController = [[MERTweetsTableViewController alloc] init];
                 
                 [viewController setTitle:@"Retweets"];
                 [viewController setViewModels:value];
                 
                 [self.navigationController pushViewController:viewController animated:YES];
            }];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    return @[retweetsItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    @weakify(self);
    
    RAC(self.imageView,image) = RACObserve(self, viewModel.userViewModel.profileImage);
    RAC(self.mediaImageView,image) = RACObserve(self, viewModel.mediaThumbnailImage);
    RAC(self.nameLabel,text) = RACObserve(self, viewModel.userViewModel.name);
    RAC(self.screenNameLabel,text) = RACObserve(self, viewModel.userViewModel.screenName);
    RAC(self.textLabel,attributedText) = [[RACObserve(self, viewModel) ignore:nil] map:^id(MERTwitterKitTweetViewModel *value) {
        @strongify(self);
        
        NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:value.text attributes:@{NSFontAttributeName: self.textLabel.font,NSForegroundColorAttributeName: [UIColor blackColor]}];
        
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
    RAC(self.favoriteCountLabel,text) = [RACObserve(self, viewModel.favoriteCount) map:^id(id value) {
        return [NSString stringWithFormat:@"%@ favorite(s)",value];
    }];
    RAC(self.retweetCountLabel,text) = [RACObserve(self, viewModel.retweetCount) map:^id(id value) {
        return [NSString stringWithFormat:@"%@ retweet(s)",value];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (instancetype)initWithViewModel:(MERTwitterKitTweetViewModel *)viewModel; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(viewModel);
    
    [self setViewModel:viewModel];
    
    return self;
}

@end
