//
//  MERPickerViewButton.m
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

#import "MERPickerViewButton.h"
#import "MERNextPreviousInputAccessoryView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

NSString *const MERPickerViewButtonNotificationDidBecomeFirstResponder = @"MERPickerViewButtonNotificationDidBecomeFirstResponder";
NSString *const MERPickerViewButtonNotificationDidResignFirstResponder = @"MERPickerViewButtonNotificationDidResignFirstResponder";

@interface MERPickerViewButton () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (readwrite,retain) UIView *inputView;
@property (readwrite,retain) UIView *inputAccessoryView;

@property (strong,nonatomic) UIPickerView *pickerView;

- (void)_MERPickerViewButton_init;

+ (UIFont *)_defaultPickerTitleFont;
@end

@implementation MERPickerViewButton
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERPickerViewButton_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERPickerViewButton_init];
    
    return self;
}
#pragma mark Tint Color
- (void)tintColorDidChange {
    [self.pickerView setTintColor:self.tintColor];
}
#pragma mark UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    BOOL retval = [super becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MERPickerViewButtonNotificationDidBecomeFirstResponder object:self];
    
    return retval;
}
- (BOOL)resignFirstResponder {
    BOOL retval = [super resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MERPickerViewButtonNotificationDidResignFirstResponder object:self];
    
    return retval;
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource numberOfRowsInPickerViewButton:self];
}
#pragma mark UIPickerViewDelegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.dataSource respondsToSelector:@selector(pickerViewButton:attributedTitleForRowAtIndex:)])
        return [self.dataSource pickerViewButton:self attributedTitleForRowAtIndex:row];
    
    NSString *title = [self.dataSource pickerViewButton:self titleForRowAtIndex:row];
    
    return [[NSAttributedString alloc] initWithString:(title) ?: @"" attributes:@{NSFontAttributeName: [self.class _defaultPickerTitleFont]}];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setPickerSelectedRow:row];
}
#pragma mark *** Private Methods ***
- (void)_MERPickerViewButton_init; {
    [self setPickerView:[[UIPickerView alloc] initWithFrame:CGRectZero]];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self.pickerView sizeToFit];
    
    [self setInputView:self.pickerView];
    [self setInputAccessoryView:[MERNextPreviousInputAccessoryView inputAccessoryView]];
    
    @weakify(self);
    
    RACChannelTo(self.pickerView,showsSelectionIndicator) = RACChannelTo(self,pickerShowsSelectionIndicator);
    
    [[[RACObserve(self, pickerSelectedRow)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         
         if ([self.pickerView numberOfComponents] > 0) {
             if ([self.dataSource respondsToSelector:@selector(pickerViewButton:attributedTitleForRowAtIndex:)]) {
                 NSAttributedString *attributedString = [self.dataSource pickerViewButton:self attributedTitleForRowAtIndex:value.integerValue];
                 
                 [self setTitle:attributedString.string forState:UIControlStateNormal];
             }
             else {
                 NSString *string = [self.dataSource pickerViewButton:self titleForRowAtIndex:value.integerValue];
                 
                 [self setTitle:string forState:UIControlStateNormal];
             }
         }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MERNextPreviousInputAccessoryViewNotificationDidTapDoneItem object:self.inputAccessoryView]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self resignFirstResponder];
     }];
    
    [self setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            BOOL isFirstResponder = self.isFirstResponder;
            
            if (isFirstResponder)
                [self resignFirstResponder];
            else
                [self becomeFirstResponder];
            
            [subscriber sendNext:@(!isFirstResponder)];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
}

+ (UIFont *)_defaultPickerTitleFont; {
    return [UIFont systemFontOfSize:17];
}

@end
