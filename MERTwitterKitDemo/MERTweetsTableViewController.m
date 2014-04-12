//
//  MERTweetsTableViewController.m
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

#import "MERTweetsTableViewController.h"
#import <MERTwitterKit/MERTwitterKit.h>
#import "MERTweetTableViewCell.h"
#import <MEKit/UITableViewCell+MEExtensions.h>
#import <libextobjc/EXTScope.h>
#import "MERTweetDetailViewController.h"

@interface MERTweetsTableViewController ()
- (void)_configureCell:(MERTweetTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@implementation MERTweetsTableViewController

- (NSString *)title {
    return ([super title]) ?: @"Tweets";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MERTweetTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MERTweetTableViewCell class])];
    
    @weakify(self);
    
    [[[RACObserve(self, viewModels)
       ignore:nil]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         
         [self.tableView reloadData];
     }];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[MERTweetDetailViewController alloc] initWithViewModel:self.viewModels[indexPath.row]] animated:YES];
}

- (void)_configureCell:(MERTweetTableViewCell *)cell indexPath:(NSIndexPath *)indexPath; {
    MERTwitterKitTweetViewModel *viewModel = self.viewModels[indexPath.row];
    
    [cell setViewModel:viewModel];
}

@end
