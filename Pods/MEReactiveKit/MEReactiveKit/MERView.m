//
//  MERView.m
//  MEReactiveKit
//
//  Created by William Towe on 2/7/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

@interface MERView ()
@property (strong,nonatomic) CALayer *topSeparatorLayer;
@property (strong,nonatomic) CALayer *bottomSeparatorLayer;
@property (strong,nonatomic) CALayer *leftSeparatorLayer;
@property (strong,nonatomic) CALayer *rightSeparatorLayer;

- (void)_MERView_init;

+ (UIColor *)_defaultSeparatorColor;
@end

@implementation MERView
#pragma mark *** Subclass Overrides ***
- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERView_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERView_init];
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    if ([layer isEqual:self.layer]) {
        [self.topSeparatorLayer setFrame:CGRectMake(0, 0, CGRectGetWidth(layer.bounds), 1)];
        [self.bottomSeparatorLayer setFrame:CGRectMake(0, CGRectGetHeight(layer.bounds) - 1, CGRectGetWidth(layer.bounds), 1)];
        [self.leftSeparatorLayer setFrame:CGRectMake(0, 0, 1, CGRectGetHeight(layer.bounds))];
        [self.rightSeparatorLayer setFrame:CGRectMake(CGRectGetWidth(layer.bounds) - 1, 0, 1, CGRectGetHeight(layer.bounds))];
    }
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = (separatorColor) ?: [self.class _defaultSeparatorColor];
}
#pragma mark *** Private Methods ***
- (void)_MERView_init; {
    [self setSeparatorColor:[self.class _defaultSeparatorColor]];
    
    @weakify(self);
    
    RACSignal *cellSeparatorColorSignal = [[[RACObserve(self, separatorColor) distinctUntilChanged] map:^id(UIColor *value) {
        return (__bridge id)value.CGColor;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    void(^createSeparatorLayersIfNecessary)(void) = ^{
        @strongify(self);
        
        if (!self.topSeparatorLayer ||
            !self.bottomSeparatorLayer ||
            !self.leftSeparatorLayer ||
            !self.rightSeparatorLayer) {
            
            [self setTopSeparatorLayer:[CALayer layer]];
            [self setBottomSeparatorLayer:[CALayer layer]];
            [self setLeftSeparatorLayer:[CALayer layer]];
            [self setRightSeparatorLayer:[CALayer layer]];
            
            RAC(self.topSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
            RAC(self.bottomSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
            RAC(self.leftSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
            RAC(self.rightSeparatorLayer,backgroundColor) = cellSeparatorColorSignal;
        }
    };
    
    [[[[RACObserve(self, separatorOptions)
        distinctUntilChanged]
       deliverOn:[RACScheduler mainThreadScheduler]]
      initially:createSeparatorLayersIfNecessary]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         
         MERViewSeparatorOptions options = value.integerValue;
         
         if (options & MERViewSeparatorOptionTop)
             [self.layer addSublayer:self.topSeparatorLayer];
         else
             [self.topSeparatorLayer removeFromSuperlayer];
         
         if (options & MERViewSeparatorOptionBottom)
             [self.layer addSublayer:self.bottomSeparatorLayer];
         else
             [self.bottomSeparatorLayer removeFromSuperlayer];
         
         if (options & MERViewSeparatorOptionLeft)
             [self.layer addSublayer:self.leftSeparatorLayer];
         else
             [self.leftSeparatorLayer removeFromSuperlayer];
         
         if (options & MERViewSeparatorOptionRight)
             [self.layer addSublayer:self.rightSeparatorLayer];
         else
             [self.rightSeparatorLayer removeFromSuperlayer];
     }];
}

+ (UIColor *)_defaultSeparatorColor; {
    return [UIColor lightGrayColor];
}

@end
