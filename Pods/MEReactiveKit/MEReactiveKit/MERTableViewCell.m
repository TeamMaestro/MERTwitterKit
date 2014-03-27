//
//  MERTableViewCell.m
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

#import "MERTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

#import <QuartzCore/QuartzCore.h>

@interface MERTableViewCell ()
@property (strong,nonatomic) CALayer *topSeparatorLayer;
@property (strong,nonatomic) CALayer *bottomSeparatorLayer;

@property (strong,nonatomic) RACSubject *highlightedTupleSubject;
@property (strong,nonatomic) RACSubject *selectedTupleSubject;

- (void)_MERTableViewCell_init;
@end

@implementation MERTableViewCell
#pragma mark *** Subclass Overrides ***
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self _MERTableViewCell_init];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERTableViewCell_init];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView setFrame:UIEdgeInsetsInsetRect(self.contentView.frame, self.contentViewEdgeInsets)];
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    if ([layer isEqual:self.layer]) {
        [self.topSeparatorLayer setFrame:CGRectMake(self.separatorInset.left, 0, CGRectGetWidth(layer.bounds) - self.separatorInset.left - self.separatorInset.right, 1)];
        [self.bottomSeparatorLayer setFrame:CGRectMake(self.separatorInset.left, CGRectGetHeight(layer.bounds) - 1, CGRectGetWidth(layer.bounds) - self.separatorInset.left - self.separatorInset.right, 1)];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [self.highlightedTupleSubject sendNext:RACTuplePack(@(highlighted),@(animated))];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self.selectedTupleSubject sendNext:RACTuplePack(@(selected),@(animated))];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setCellSeparatorColor:(UIColor *)cellSeparatorColor {
    _cellSeparatorColor = (cellSeparatorColor) ?: [UIColor blackColor];
}

- (RACSignal *)highlightedSignal {
    return [self.highlightedTupleSignal map:^id(RACTuple *value) {
        return value.first;
    }];
}
- (RACSignal *)highlightedTupleSignal {
    return self.highlightedTupleSubject;
}
- (RACSignal *)selectedSignal {
    return [self.selectedTupleSignal map:^id(RACTuple *value) {
        return value.first;
    }];
}
- (RACSignal *)selectedTupleSignal {
    return self.selectedTupleSubject;
}
#pragma mark *** Private Methods ***
- (void)_MERTableViewCell_init; {
    [self setCellSeparatorColor:[UIColor blackColor]];
    
    [self setHighlightedTupleSubject:[RACReplaySubject replaySubjectWithCapacity:1]];
    [self setSelectedTupleSubject:[RACReplaySubject replaySubjectWithCapacity:1]];
    
    @weakify(self);
    
    void(^createSeparatorLayersIfNecessary)(void) = ^{
        @strongify(self);
        
        if (!self.topSeparatorLayer ||
            !self.bottomSeparatorLayer) {
            
            [self setTopSeparatorLayer:[CALayer layer]];
            [self setBottomSeparatorLayer:[CALayer layer]];
            
            RACSignal *cellSeparatorColorSignal = [[[RACObserve(self, cellSeparatorColor) distinctUntilChanged] map:^id(UIColor *value) {
                return (__bridge id)value.CGColor;
            }] deliverOn:[RACScheduler mainThreadScheduler]];
            
            RAC(self.topSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
            RAC(self.bottomSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
        }
    };
    
    [[[[RACObserve(self, cellSeparatorOptions)
        distinctUntilChanged]
       deliverOn:[RACScheduler mainThreadScheduler]]
      initially:createSeparatorLayersIfNecessary]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         
         MERTableViewCellSeparatorOptions options = value.integerValue;
         
         if (options & MERTableViewCellSeparatorOptionTop)
             [self.layer addSublayer:self.topSeparatorLayer];
         else
             [self.topSeparatorLayer removeFromSuperlayer];
         
         if (options & MERTableViewCellSeparatorOptionBottom)
             [self.layer addSublayer:self.bottomSeparatorLayer];
         else
             [self.bottomSeparatorLayer removeFromSuperlayer];
    }];
}

@end
