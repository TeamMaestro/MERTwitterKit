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
@property (weak,nonatomic) IBOutlet UITextView *textView;
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
            [subscriber sendNext:RACTuplePack(nil,nil)];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [doneItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[[MERTwitterClient sharedClient] requestUpdateWithStatus:self.textView.text inReplyToTweetWithIdentity:0 latitude:0 longitude:0 placeIdentity:nil] subscribeNext:^(MERTwitterKitTweetViewModel *value) {
                [subscriber sendNext:RACTuplePack(value,nil)];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
            
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
    
    [doneItem.rac_command.errors
     subscribeNext:^(NSError *error) {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
         
         [alertView show];
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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

@end
