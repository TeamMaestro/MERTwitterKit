//
//  MERTextField.m
//  MEReactiveKit
//
//  Created by William Towe on 2/22/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTextField.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>
#import "MERNextPreviousInputAccessoryView.h"

@interface MERTextField ()
- (void)_MERTextField_init;
@end

@implementation MERTextField

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERTextField_init];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERTextField_init];
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.textEdgeInsets.top, self.leftViewEdgeInsets.left + self.textEdgeInsets.left + self.rightViewEdgeInsets.left, self.textEdgeInsets.bottom, self.leftViewEdgeInsets.right + self.textEdgeInsets.right + self.rightViewEdgeInsets.right));
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.textEdgeInsets.top, self.leftViewEdgeInsets.left + self.textEdgeInsets.left + self.rightViewEdgeInsets.left, self.textEdgeInsets.bottom, self.leftViewEdgeInsets.right + self.textEdgeInsets.right + self.rightViewEdgeInsets.right));
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.textEdgeInsets.top, self.leftViewEdgeInsets.left + self.textEdgeInsets.left + self.rightViewEdgeInsets.left, self.textEdgeInsets.bottom, self.leftViewEdgeInsets.right + self.textEdgeInsets.right + self.rightViewEdgeInsets.right));
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect retval = [super leftViewRectForBounds:bounds];
    
    retval.origin.x += self.leftViewEdgeInsets.left;
    
    return retval;
}
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect retval = [super rightViewRectForBounds:bounds];
    
    retval.origin.x -= self.rightViewEdgeInsets.right;
    
    return retval;
}

- (void)_MERTextField_init; {
    [self setInputAccessoryView:[MERNextPreviousInputAccessoryView inputAccessoryView]];
    
    @weakify(self);
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MERNextPreviousInputAccessoryViewNotificationDidTapDoneItem object:self.inputAccessoryView]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self resignFirstResponder];
     }];
    
    [[[RACSignal merge:@[[RACObserve(self, textEdgeInsets) distinctUntilChanged],
                         [RACObserve(self, leftViewEdgeInsets) distinctUntilChanged],
                         [RACObserve(self, rightViewEdgeInsets) distinctUntilChanged]]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         
         [self setNeedsLayout];
    }];
}

@end
