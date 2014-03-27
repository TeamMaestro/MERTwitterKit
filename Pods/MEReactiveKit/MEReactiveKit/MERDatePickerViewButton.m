//
//  MERDatePickerViewButton.m
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

#import "MERDatePickerViewButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>
#import "MERNextPreviousInputAccessoryView.h"

NSString *const MERDatePickerViewButtonNotificationDidBecomeFirstResponder = @"MERDatePickerViewButtonNotificationDidBecomeFirstResponder";
NSString *const MERDatePickerViewButtonNotificationDidResignFirstResponder = @"MERDatePickerViewButtonNotificationDidResignFirstResponder";

@interface MERDatePickerViewButton ()
@property (readwrite,retain) UIView *inputView;
@property (readwrite,retain) UIView *inputAccessoryView;

@property (strong,nonatomic) UIDatePicker *datePicker;

- (void)_MERDatePickerViewButton_init;

+ (NSDate *)_defaultDatePickerDate;
+ (NSDateFormatter *)_defaultDateFormatter;
@end

@implementation MERDatePickerViewButton
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERDatePickerViewButton_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERDatePickerViewButton_init];
    
    return self;
}
#pragma mark Tint Color
- (void)tintColorDidChange {
    [self.datePicker setTintColor:self.tintColor];
}
#pragma mark UIResponder
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    BOOL retval = [super becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MERDatePickerViewButtonNotificationDidBecomeFirstResponder object:self];
    
    return retval;
}
- (BOOL)resignFirstResponder {
    BOOL retval = [super resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MERDatePickerViewButtonNotificationDidResignFirstResponder object:self];
    
    return retval;
}
#pragma mark *** Public Methods ***
- (void)setDatePickerDate:(NSDate *)datePickerDate {
    _datePickerDate = (datePickerDate) ?: [self.class _defaultDatePickerDate];
}
- (void)setDateFormatter:(NSDateFormatter *)dateFormatter {
    _dateFormatter = (dateFormatter) ?: [self.class _defaultDateFormatter];
}
#pragma mark *** Private Methods ***
- (void)_MERDatePickerViewButton_init; {
    _datePickerDate = [self.class _defaultDatePickerDate];
    _dateFormatter = [self.class _defaultDateFormatter];
    
    [self setDatePickerMode:UIDatePickerModeDateAndTime];
    
    [self setDatePicker:[[UIDatePicker alloc] initWithFrame:CGRectZero]];
    [self.datePicker sizeToFit];
    
    [self setInputView:self.datePicker];
    [self setInputAccessoryView:[MERNextPreviousInputAccessoryView inputAccessoryView]];
    
    @weakify(self);
    
    RACChannelTo(self.datePicker,datePickerMode) = RACChannelTo(self,datePickerMode);
    RACChannelTo(self.datePicker,minimumDate) = RACChannelTo(self,datePickerMinimumDate);
    RACChannelTo(self.datePicker,maximumDate) = RACChannelTo(self,datePickerMaximumDate);
    
    RAC(self.datePicker,date) = [RACObserve(self, datePickerDate) map:^id(NSDate *value) {
        return (value) ?: [NSDate date];
    }];
    
    [[self.datePicker rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(UIDatePicker *control) {
         @strongify(self);
         
         [self setDatePickerDate:control.date];
    }];
    
    [[[RACSignal combineLatest:@[RACObserve(self, datePickerDate),RACObserve(self, dateFormatter)]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);

         RACTupleUnpack(NSDate *date, NSDateFormatter *dateFormatter) = tuple;
         
         [self setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
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

+ (NSDate *)_defaultDatePickerDate; {
    return [NSDate date];
}
+ (NSDateFormatter *)_defaultDateFormatter {
    static NSDateFormatter *retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[NSDateFormatter alloc] init];
        
        [retval setDateStyle:NSDateFormatterShortStyle];
        [retval setTimeStyle:NSDateFormatterShortStyle];
    });
    return retval;
}

@end
