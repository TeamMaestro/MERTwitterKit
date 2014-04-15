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
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface MERTweetUpdateViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UITextView *textView;

@property (strong,nonatomic) UIImage *image;

- (void)_updateNavigationItem;
@end

@implementation MERTweetUpdateViewController

- (NSString *)title {
    return @"Update";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self _updateNavigationItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSParameterAssert(self.completionBlock);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self setImage:(info[UIImagePickerControllerEditedImage]) ?: info[UIImagePickerControllerOriginalImage]];
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)_updateNavigationItem; {
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:NULL];
    
    @weakify(self);
    
    [cancelItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:RACTuplePack(nil,nil)];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [doneItem setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[[self.textView rac_textSignal],RACObserve(self, image)] reduce:^id(NSString *text, UIImage *image){
        return @(text.length > 0 || image);
    }] signalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[[[[MERTwitterClient sharedClient] requestUpdateWithStatus:self.textView.text media:(self.image) ? @[self.image] : nil replyIdentity:0 location:kCLLocationCoordinate2DInvalid placeIdentity:nil] initially:^{
                [SVProgressHUD show];
            }] finally:^{
                [SVProgressHUD dismiss];
            }] subscribeNext:^(MERTwitterTweetViewModel *value) {
                [subscriber sendNext:RACTuplePack(value,nil)];
                [subscriber sendCompleted];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
    }]];
    
    [imageItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            if (self.image) {
                [self setImage:nil];
            }
            else {
                UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
                
                [viewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [viewController setMediaTypes:@[(__bridge id)kUTTypeImage]];
                [viewController setAllowsEditing:YES];
                [viewController setDelegate:self];
                
                [self presentViewController:viewController animated:YES completion:nil];
            }
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [[RACSignal merge:@[cancelItem.rac_command.executionSignals.concat,
                        doneItem.rac_command.executionSignals.concat]]
     subscribeNext:^(RACTuple *value) {
         @strongify(self);
         
         RACTupleUnpack(MERTwitterTweetViewModel *viewModel, NSError *error) = value;
         
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
    
    [self.navigationItem setLeftBarButtonItems:@[cancelItem]];
    [self.navigationItem setRightBarButtonItems:@[doneItem,imageItem]];
}

@end
