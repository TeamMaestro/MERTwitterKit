//
//  MERScrollView.m
//  MEReactiveKit
//
//  Created by William Towe on 3/16/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERScrollView.h"
#import <MEFoundation/MEMacros.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <MEKit/CAGradientLayer+MEExtensions.h>
#import <MEKit/CATransaction+MEExtensions.h>
#import <MEFoundation/MEDebugging.h>

@interface MERScrollView ()
@property (strong,nonatomic) CAGradientLayer *topGradientLayer;
@property (strong,nonatomic) CAGradientLayer *middleGradientLayer;
@property (strong,nonatomic) CAGradientLayer *bottomGradientLayer;

- (void)_MERScrollView_init;
@end

@implementation MERScrollView

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _MERScrollView_init];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERScrollView_init];
    
    return self;
}

- (void)setTopGradientPercentage:(CGFloat)topGradientPercentage {
    _topGradientPercentage = MEBoundedValue(topGradientPercentage, 0.0, 1.0);
}
- (void)setBottomGradientPercentage:(CGFloat)bottomGradientPercentage {
    _bottomGradientPercentage = MEBoundedValue(bottomGradientPercentage, 0.0, 1.0);
}

- (void)_MERScrollView_init; {
    @weakify(self);
    
    void(^createGradientLayersIfNecessary)(void) = ^{
        @strongify(self);
        
        if (self.topGradientPercentage > 0.0 ||
            self.bottomGradientPercentage > 0.0) {
            
            [self setTopGradientLayer:[CAGradientLayer ME_gradientLayerWithBounds:self.bounds colors:@[[UIColor colorWithWhite:0 alpha:1],[UIColor colorWithWhite:0 alpha:1],[UIColor colorWithWhite:0 alpha:0]] locations:@[@0,@(1 - self.bottomGradientPercentage),@1]]];
            [self setMiddleGradientLayer:[CAGradientLayer ME_gradientLayerWithBounds:self.bounds colors:@[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:1],[UIColor colorWithWhite:0 alpha:1],[UIColor colorWithWhite:0 alpha:0]] locations:@[@0,@(self.topGradientPercentage),@(1 - self.bottomGradientPercentage),@1]]];
            [self setBottomGradientLayer:[CAGradientLayer ME_gradientLayerWithBounds:self.bounds colors:@[[UIColor colorWithWhite:0 alpha:0],[UIColor colorWithWhite:0 alpha:1],[UIColor colorWithWhite:0 alpha:1]] locations:@[@0,@(self.topGradientPercentage),@1]]];
        }
    };
    
    [[[[RACSignal merge:@[RACObserve(self, topGradientPercentage),
                          RACObserve(self, bottomGradientPercentage),
                          RACObserve(self, frame),
                          RACObserve(self, contentSize)]]
        deliverOn:[RACScheduler mainThreadScheduler]]
      flattenMap:^RACStream *(id value) {
        return [RACObserve(self, contentOffset)
                initially:createGradientLayersIfNecessary];
    }] subscribeNext:^(NSValue *value) {
         @strongify(self);
        
         if (value.CGPointValue.y <= 0) {
             if (self.layer.mask != self.topGradientLayer)
                 [self.layer setMask:self.topGradientLayer];
         }
         else if (value.CGPointValue.y >= self.contentSize.height - CGRectGetHeight(self.frame)) {
             if (self.layer.mask != self.bottomGradientLayer)
                 [self.layer setMask:self.bottomGradientLayer];
         }
         else {
             if (self.layer.mask != self.middleGradientLayer)
                 [self.layer setMask:self.middleGradientLayer];
         }
         
         [CATransaction ME_beginForAnimations:^{
             @strongify(self);
             
             [self.layer.mask setPosition:CGPointMake(0, self.contentOffset.y)];
         } disableActions:YES];
    }];
}

@end
