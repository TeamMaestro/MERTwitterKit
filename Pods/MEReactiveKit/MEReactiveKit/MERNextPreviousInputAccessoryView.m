//
//  MERNextPreviousInputAccessoryView.m
//  MEReactiveKit
//
//  Created by William Towe on 2/21/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERNextPreviousInputAccessoryView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MERCommon.h"

NSString *const MERNextPreviousInputAccessoryViewNotificationDidTapNextItem = @"MERNextPreviousInputAccessoryViewNotificationDidTapNextItem";
NSString *const MERNextPreviousInputAccessoryViewNotificationDidTapPreviousItem = @"MERNextPreviousInputAccessoryViewNotificationDidTapPreviousItem";
NSString *const MERNextPreviousInputAccessoryViewNotificationDidTapDoneItem = @"MERNextPreviousInputAccessoryViewNotificationDidTapDoneItem";

@interface MERNextPreviousInputAccessoryView ()
@property (strong,nonatomic) UIToolbar *toolbar;
@end

@implementation MERNextPreviousInputAccessoryView
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setToolbar:[[UIToolbar alloc] initWithFrame:CGRectZero]];
    [self.toolbar sizeToFit];
    [self addSubview:self.toolbar];
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Next", nil, MEReactiveKitResourcesBundle(), @"next previous input accessory view next item title") style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Previous", nil, MEReactiveKitResourcesBundle(), @"next previous input accessory view previous item title") style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    
    @weakify(self);
    
    [nextItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MERNextPreviousInputAccessoryViewNotificationDidTapNextItem object:self];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [previousItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MERNextPreviousInputAccessoryViewNotificationDidTapPreviousItem object:self];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [doneItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MERNextPreviousInputAccessoryViewNotificationDidTapDoneItem object:self];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [self.toolbar setItems:@[previousItem,
                             nextItem,
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                             doneItem]];
    
    return self;
}

- (void)layoutSubviews {
    [self.toolbar setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.toolbar sizeThatFits:size];
}
#pragma mark *** Public Methods ***
+ (instancetype)inputAccessoryView; {
    MERNextPreviousInputAccessoryView *retval = [[[self class] alloc] initWithFrame:CGRectZero];
    
    [retval sizeToFit];
    
    return retval;
}

@end
