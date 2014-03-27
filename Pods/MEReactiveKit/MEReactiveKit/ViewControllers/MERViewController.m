//
//  MERViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 11/18/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface MERViewController ()
@property (readwrite,assign,nonatomic) MERViewControllerNavigationItemOptions navigationItemOptions;

@property (readwrite,assign,nonatomic,getter = isKeyboardVisible) BOOL keyboardVisible;
@property (readwrite,assign,nonatomic) CGRect keyboardFrame;
@end

@implementation MERViewController
#pragma mark *** Subclass Overrides ***
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setNavigationItemOptions:MERViewControllerNavigationItemOptionInit];
    
    if ((self.navigationItemOptions & MERViewControllerNavigationItemOptionInit) != 0)
        [self configureNavigationItem];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ((self.navigationItemOptions & MERViewControllerNavigationItemOptionViewDidLoad) != 0)
        [self configureNavigationItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((self.navigationItemOptions & MERViewControllerNavigationItemOptionViewWillAppear) != 0)
        [self configureNavigationItem];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ((self.navigationItemOptions & MERViewControllerNavigationItemOptionWillAnimateRotationToInterfaceOrientation) != 0)
        [self configureNavigationItem];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if ((self.navigationItemOptions & MERViewControllerNavigationItemOptionDidRotateFromInterfaceOrientation) != 0)
        [self configureNavigationItem];
}
#pragma mark *** Public Methods ***
- (void)configureNavigationItem; {
    
}
#pragma mark Properties
- (RACSignal *)keyboardWillChangeFrameSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]
             takeUntil:[self rac_willDeallocSignal]]
            flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:YES];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame],@(animationDuration),@(animationCurve))];
            
            return nil;
        }];
    }];
}
- (RACSignal *)keyboardDidChangeFrameSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidChangeFrameNotification object:nil]
             takeUntil:[self rac_willDeallocSignal]]
            flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:YES];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame])];
            
            return nil;
        }];
    }];
}

- (RACSignal *)keyboardWillHideSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
             takeUntil:[self rac_willDeallocSignal]]
            flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:NO];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame],@(animationDuration),@(animationCurve))];
            
            return nil;
        }];
    }];
}
- (RACSignal *)keyboardDidHideSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] takeUntil:[self rac_willDeallocSignal]] flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:NO];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame])];
            
            return nil;
        }];
    }];
}

- (RACSignal *)keyboardWillShowSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] takeUntil:[self rac_willDeallocSignal]] flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:YES];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame],@(animationDuration),@(animationCurve))];
            
            return nil;
        }];
    }];
}
- (RACSignal *)keyboardDidShowSignal {
    @weakify(self);
    
    return [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] takeUntil:[self rac_willDeallocSignal]] flattenMap:^RACStream *(NSNotification *note) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
            
            endFrame = [self.view convertRect:[self.view.window convertRect:endFrame fromWindow:nil] fromView:nil];
            
            [self setKeyboardVisible:YES];
            [self setKeyboardFrame:endFrame];
            
            [subscriber sendNext:RACTuplePack([NSValue valueWithCGRect:endFrame])];
            
            return nil;
        }];
    }];
}

@end
