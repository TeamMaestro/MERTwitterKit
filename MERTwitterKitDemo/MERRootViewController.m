//
//  MERViewController.m
//  MERTwitterKitDemo
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERRootViewController.h"
#import <MERTwitterKit/MERTwitterKit.h>
#import <MEFoundation/MEDebugging.h>
#import "MERTweetTableViewCell.h"
#import <MEKit/UITableViewCell+MEExtensions.h>

@interface MERRootViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSArray *viewModels;

- (void)_configureCell:(MERTweetTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@implementation MERRootViewController

- (NSString *)title {
    return @"Tweets";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERTweetTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERTweetTableViewCell class])];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    
    [[[MERTwitterClient sharedClient] selectAccount] subscribeNext:^(NSArray *value) {
        NSArray *accounts = value[0];
        MERTwitterClientRequestTwitterAccountsCompletionBlock completionBlock = value[1];
        
        completionBlock(accounts.firstObject);
        
    } error:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertTitle] message:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertMessage] delegate:nil cancelButtonTitle:error.userInfo[MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle] otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [[[RACObserve(self, viewModels)
       ignore:nil]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         
         [self.tableView reloadData];
     }];
    
    [[[[[RACObserve([MERTwitterClient sharedClient], selectedAccount)
        distinctUntilChanged]
       ignore:nil]
        take:1]
      flattenMap:^RACStream *(id value) {
          return [[MERTwitterClient sharedClient] requestHomeTimelineTweets];
    }] subscribeNext:^(NSArray *value) {
        @strongify(self);
        
        [self setViewModels:value];
    } error:^(NSError *error) {
        MELogObject(error);
    }];
}
- (void)viewDidLayoutSubviews {
    [self.tableView setFrame:self.view.bounds];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MERTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERTweetTableViewCell class]) forIndexPath:indexPath];
    
    [self _configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MERTweetTableViewCell estimatedRowHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MERTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MERTweetTableViewCell class])];
    
    [self _configureCell:cell indexPath:indexPath];
    
    return [cell ME_autolayoutSizeThatFits:CGSizeMake(CGRectGetWidth(tableView.frame), CGRectGetHeight(cell.bounds))].height + 1;
}

- (void)_configureCell:(MERTweetTableViewCell *)cell indexPath:(NSIndexPath *)indexPath; {
    MERTweetViewModel *viewModel = self.viewModels[indexPath.row];
    
    [cell setViewModel:viewModel];
}

@end
