//
//  MERTweetUpdateViewController.m
//  MERTwitterKit
//
//  Created by William Towe on 4/12/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTweetUpdateViewController.h"
#import <MERTwitterKit/MERTwitterKit.h>
#import <libextobjc/EXTScope.h>

@interface MERTweetUpdateViewController ()

@end

@implementation MERTweetUpdateViewController

- (NSString *)title {
    return @"Update";
}
- (UINavigationItem *)navigationItem {
    UINavigationItem *retval = [super navigationItem];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    
    @weakify(self);
    
    [cancelItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [subscriber sendNext:RACTuplePack(nil,nil)];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [doneItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [subscriber sendNext:RACTuplePack(nil,nil)];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [[RACSignal merge:@[cancelItem.rac_command.executionSignals.concat,
                        doneItem.rac_command.executionSignals.concat]]
     subscribeNext:^(RACTuple *value) {
         @strongify(self);
         
         RACTupleUnpack(MERTwitterKitTweetViewModel *viewModel, NSError *error) = value;
         
         [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
             @strongify(self);
             
             self.completionBlock(viewModel,error);
         }];
    }];
    
    [retval setLeftBarButtonItems:@[cancelItem]];
    [retval setRightBarButtonItems:@[doneItem]];
    
    return retval;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSParameterAssert(self.completionBlock);
}

@end
