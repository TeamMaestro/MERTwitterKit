//
//  MERTextView.m
//  MEReactiveKit
//
//  Created by William Towe on 1/8/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTextView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEKit/CATransaction+MEExtensions.h>
#import <MEKit/CAGradientLayer+MEExtensions.h>
#import <MEFoundation/MEMacros.h>

@interface MERTextView ()
@property (strong,nonatomic) UILabel *placeholderLabel;

@property (strong,nonatomic) CAGradientLayer *topGradientLayer;
@property (strong,nonatomic) CAGradientLayer *middleGradientLayer;
@property (strong,nonatomic) CAGradientLayer *bottomGradientLayer;

- (void)_MERTextView_init;

+ (UIFont *)_defaultPlaceholderFont;
+ (UIColor *)_defaultPlaceholderTextColor;
@end

@implementation MERTextView
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (!(self = [super initWithFrame:frame textContainer:textContainer]))
        return nil;
    
    [self _MERTextView_init];
    
    return self;
}
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _MERTextView_init];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat const kPlaceholderLabelMaxWidth = CGRectGetWidth(self.bounds) - self.placeholderEdgeInsets.left - self.placeholderEdgeInsets.right;
    
    [self.placeholderLabel setFrame:CGRectMake(self.placeholderEdgeInsets.left, self.placeholderEdgeInsets.top, kPlaceholderLabelMaxWidth, [self.placeholderLabel sizeThatFits:CGSizeMake(kPlaceholderLabelMaxWidth, CGFLOAT_MAX)].height)];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setPlaceholderFont:self.font];
}
- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    [self setPlaceholderTextColor:self.textColor];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setTopGradientPercentage:(CGFloat)topGradientPercentage {
    _topGradientPercentage = MEBoundedValue(topGradientPercentage, 0.0, 1.0);
}
- (void)setBottomGradientPercentage:(CGFloat)bottomGradientPercentage {
    _bottomGradientPercentage = MEBoundedValue(bottomGradientPercentage, 0.0, 1.0);
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = (placeholderFont) ?: [self.class _defaultPlaceholderFont];
}
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = (placeholderTextColor) ?: [self.class _defaultPlaceholderTextColor];
}
#pragma mark *** Private Methods ***
- (void)_MERTextView_init; {
    _placeholder = @"";
    _placeholderFont = [self.class _defaultPlaceholderFont];
    _placeholderTextColor = [self.class _defaultPlaceholderTextColor];
    
    [self setPlaceholderLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderLabel setNumberOfLines:0];
    [self addSubview:self.placeholderLabel];
    
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
    
    RAC(self.placeholderLabel,hidden) = [RACSignal combineLatest:@[RACObserve(self, text),[self rac_textSignal]] reduce:^id(NSString *value1, NSString *value2) {
        return @(value1.length > 0 || value2.length > 0);
    }];
    RAC(self.placeholderLabel,attributedText) = RACObserve(self, attributedPlaceholder);
    
    [[[RACSignal combineLatest:@[[RACObserve(self, placeholder) distinctUntilChanged],
                                 [RACObserve(self, placeholderFont) distinctUntilChanged],
                                 [RACObserve(self, placeholderTextColor) distinctUntilChanged],
                                 [RACObserve(self, placeholderAlignment) distinctUntilChanged]]]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self);
         
         RACTupleUnpack(NSString *placeholder, UIFont *font, UIColor *foregroundColor, NSNumber *alignment) = tuple;
         
         NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
         
         [style setAlignment:alignment.integerValue];
         
         [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName: foregroundColor,NSParagraphStyleAttributeName: style}]];
     }];
}

+ (UIFont *)_defaultPlaceholderFont; {
    return [UIFont systemFontOfSize:17];
}
+ (UIColor *)_defaultPlaceholderTextColor; {
    return [UIColor blackColor];
}

@end
