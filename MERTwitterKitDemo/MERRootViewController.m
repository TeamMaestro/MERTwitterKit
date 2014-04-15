//
//  MERViewController.m
//  MERTwitterKitDemo
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERRootViewController.h"
#import <MERTwitterKit/MERTwitterKit.h>
#import <MEFoundation/MEDebugging.h>
#import <libextobjc/EXTScope.h>
#import "MERTweetsTableViewController.h"
#import "MERTweetUpdateViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MERRootViewController ()
@property (strong,nonatomic) MERTweetsTableViewController *tableViewController;
@end

@implementation MERRootViewController

- (NSString *)title {
    return @"Tweets";
}
- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    
    UIBarButtonItem *updateItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    @weakify(self);
    
    [updateItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            MERTweetUpdateViewController *viewController = [[MERTweetUpdateViewController alloc] init];
            
            [viewController setCompletionBlock:^(MERTwitterKitTweetViewModel *viewModel, NSError *error) {
                if (viewModel) {
                    NSMutableArray *temp = [self.tableViewController.viewModels mutableCopy];
                    
                    [temp insertObject:viewModel atIndex:0];
                    
                    [self.tableViewController setViewModels:temp];
                }
            }];
            
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [retval setRightBarButtonItems:@[updateItem]];
    
    return retval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewController:[[MERTweetsTableViewController alloc] init]];
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController didMoveToParentViewController:self];
    
    @weakify(self);
    
    [[[MERTwitterClient sharedClient] requestAccounts] subscribeNext:^(NSArray *value) {
        [[MERTwitterClient sharedClient] setSelectedAccount:value.firstObject];
        
    } error:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertTitle] message:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertMessage] delegate:nil cancelButtonTitle:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle] otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [[[[[RACObserve([MERTwitterClient sharedClient], selectedAccount)
        distinctUntilChanged]
       ignore:nil]
        take:1]
      flattenMap:^RACStream *(ACAccount *value) {
//          return [[MERTwitterClient sharedClient] requestHomeTimelineTweetsAfterTweetWithIdentity:0 beforeIdentity:0 count:100];
          return [RACSignal return:[[MERTwitterClient sharedClient] fetchTweetsAfterIdentity:0 beforeIdentity:0 count:100]];
    }] subscribeNext:^(NSArray *value) {
        @strongify(self);
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tableViewController.viewModels];
        
        [temp insertObjects:value atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, value.count)]];
        
        [self.tableViewController setViewModels:temp];
    } error:^(NSError *error) {
        MELogObject(error);
    }];
}
- (void)viewDidLayoutSubviews {
    [self.tableViewController.view setFrame:self.view.bounds];
}

@end
