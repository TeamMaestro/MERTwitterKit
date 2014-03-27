//
//  UIScrollView+MERPullToRefreshExtensions.m
//  MEReactiveKit
//
//  Created by William Towe on 3/12/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIScrollView+MERPullToRefreshExtensions.h"
#import "MERPullToRefreshView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>
#import <MEFoundation/MEMacros.h>

#import <objc/runtime.h>

@interface UIScrollView (MERPullToRefreshExtensionsPrivate)
@property (readwrite,strong,nonatomic) UIView<MERPullToRefresh> *MER_pullToRefreshView;
@property (readwrite,assign,nonatomic) MERPullToRefreshState MER_pullToRefreshState;

@property (assign,nonatomic) UIEdgeInsets MER_pullToRefreshOriginalContentInset;
@property (assign,nonatomic) BOOL MER_pullToRefreshChangingContentInset;
@property (strong,nonatomic) RACCompoundDisposable *MER_pullToRefreshDisposable;
@end

@implementation UIScrollView (MERPullToRefreshExtensions)

- (void)MER_addPullToRefreshViewWithBlock:(void (^)(MERPullToRefreshCompletionBlock completion))block; {
    [self MER_addPullToRefreshView:[[MERPullToRefreshView alloc] initWithFrame:CGRectZero] block:block];
}
- (void)MER_addPullToRefreshView:(UIView<MERPullToRefresh> *)view block:(void (^)(MERPullToRefreshCompletionBlock completion))block; {
    NSParameterAssert(view);
    NSParameterAssert(block);
    
    [self MER_removePullToRefreshView];
    
    [self setMER_pullToRefreshEnabled:YES];
    
    [self setMER_pullToRefreshView:view];
    [self.MER_pullToRefreshView sizeToFit];
    [self addSubview:self.MER_pullToRefreshView];
    
    [self setMER_pullToRefreshDisposable:[RACCompoundDisposable compoundDisposable]];
    [self.rac_deallocDisposable addDisposable:self.MER_pullToRefreshDisposable];
    
    @weakify(self);
    
    MERPullToRefreshCompletionBlock completion = ^{
        @strongify(self);
        
        [self setMER_pullToRefreshState:MERPullToRefreshStateNone];
        
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            @strongify(self);
            
            [self setMER_pullToRefreshChangingContentInset:YES];
            [self setContentInset:self.MER_pullToRefreshOriginalContentInset];
            [self setMER_pullToRefreshChangingContentInset:NO];
        } completion:nil];
    };
    
    RAC(self.MER_pullToRefreshView,pullToRefreshState) = RACObserve(self, MER_pullToRefreshState);
    
    [self.MER_pullToRefreshDisposable addDisposable:
     [[[[[RACSignal combineLatest:@[RACObserve(self, MER_pullToRefreshChangingContentInset),
                                    RACObserve(self, contentInset)]]
         filter:^BOOL(RACTuple *value) {
        return (![value.first boolValue]);
    }] map:^id(RACTuple *value) {
        return value.second;
    }] deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(NSValue *value) {
          @strongify(self);
          
          [self setMER_pullToRefreshOriginalContentInset:value.UIEdgeInsetsValue];
    }]];
    
    [self.MER_pullToRefreshDisposable addDisposable:
     [[[RACSignal combineLatest:@[[RACObserve(self, frame) distinctUntilChanged],RACObserve(self.MER_pullToRefreshView, preferredHeight)] reduce:^id(NSValue *frame, NSNumber *preferredHeight) {
        return preferredHeight;
    }] deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(NSNumber *preferredHeight) {
          @strongify(self);
          
          [self setNeedsLayout];
          [self layoutIfNeeded];
          
          [self.MER_pullToRefreshView setFrame:CGRectMake(0, -preferredHeight.floatValue, CGRectGetWidth(self.bounds), preferredHeight.floatValue)];
      }]];
    
    [self.MER_pullToRefreshDisposable addDisposable:
     [[[[[RACSignal combineLatest:@[[RACObserve(self, MER_pullToRefreshEnabled) distinctUntilChanged],RACObserve(self, contentOffset)]] filter:^BOOL(RACTuple *value) {
        return [value.first boolValue];
    }] map:^id(RACTuple *value) {
        return value.second;
    }] deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(NSValue *value) {
          @strongify(self);
          
          if (UIEdgeInsetsEqualToEdgeInsets(self.MER_pullToRefreshOriginalContentInset, UIEdgeInsetsZero))
              [self setMER_pullToRefreshOriginalContentInset:self.contentInset];
          
          switch (self.MER_pullToRefreshState) {
              case MERPullToRefreshStateNone:
                  if (self.isDragging && value.CGPointValue.y < CGRectGetMinY(self.frame) - self.MER_pullToRefreshOriginalContentInset.top) {
                      [self setMER_pullToRefreshState:MERPullToRefreshStateWillRefresh];
                  }
                  break;
              case MERPullToRefreshStateWillRefresh:
                  if (!self.isDragging) {
                      [self setMER_pullToRefreshState:MERPullToRefreshStateRefreshing];
                      
                      block(completion);
                  }
                  else if (value.CGPointValue.y >= CGRectGetMinY(self.frame) - self.MER_pullToRefreshOriginalContentInset.top) {
                      [self setMER_pullToRefreshState:MERPullToRefreshStateNone];
                  }
                  break;
              case MERPullToRefreshStateRefreshing: {
                  CGFloat top = MAX(value.CGPointValue.y * -1, 0.0);
                  
                  top = MIN(top, self.MER_pullToRefreshOriginalContentInset.top + CGRectGetHeight(self.bounds));
                  
                  [self setMER_pullToRefreshChangingContentInset:YES];
                  [self setContentInset:UIEdgeInsetsMake(top, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)];
                  [self setMER_pullToRefreshChangingContentInset:NO];
              }
                  break;
              default:
                  break;
          }
    }]];
}

- (void)MER_removePullToRefreshView; {
    if (self.MER_pullToRefreshView) {
        [self.MER_pullToRefreshDisposable dispose];
        [self setMER_pullToRefreshDisposable:nil];
        
        [self.MER_pullToRefreshView removeFromSuperview];
        [self setMER_pullToRefreshView:nil];
    }
}

static void const *kMER_pullToRefreshEnabled = &kMER_pullToRefreshEnabled;
@dynamic MER_pullToRefreshEnabled;
- (BOOL)MER_pullToRefreshEnabled {
    return [objc_getAssociatedObject(self, kMER_pullToRefreshEnabled) boolValue];
}
- (void)setMER_pullToRefreshEnabled:(BOOL)MER_pullToRefreshEnabled {
    objc_setAssociatedObject(self, kMER_pullToRefreshEnabled, @(MER_pullToRefreshEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIScrollView (MERPullToRefreshExtensionsPrivate)

static void const *kMER_pullToRefreshView = &kMER_pullToRefreshView;
@dynamic MER_pullToRefreshView;
- (UIView<MERPullToRefresh> *)MER_pullToRefreshView {
    return objc_getAssociatedObject(self, kMER_pullToRefreshView);
}
- (void)setMER_pullToRefreshView:(UIView<MERPullToRefresh> *)MER_pullToRefreshView {
    objc_setAssociatedObject(self, kMER_pullToRefreshView, MER_pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_pullToRefreshState = &kMER_pullToRefreshState;
@dynamic MER_pullToRefreshState;
- (MERPullToRefreshState)MER_pullToRefreshState {
    return [objc_getAssociatedObject(self, kMER_pullToRefreshState) integerValue];
}
- (void)setMER_pullToRefreshState:(MERPullToRefreshState)MER_pullToRefreshState {
    objc_setAssociatedObject(self, kMER_pullToRefreshState, @(MER_pullToRefreshState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_pullToRefreshOriginalContentInset = &kMER_pullToRefreshOriginalContentInset;
@dynamic MER_pullToRefreshOriginalContentInset;
- (UIEdgeInsets)MER_pullToRefreshOriginalContentInset {
    return [objc_getAssociatedObject(self, kMER_pullToRefreshOriginalContentInset) UIEdgeInsetsValue];
}
- (void)setMER_pullToRefreshOriginalContentInset:(UIEdgeInsets)MER_pullToRefreshOriginalContentInset {
    objc_setAssociatedObject(self, kMER_pullToRefreshOriginalContentInset, [NSValue valueWithUIEdgeInsets:MER_pullToRefreshOriginalContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_pullToRefreshChangingContentInset = &kMER_pullToRefreshChangingContentInset;
@dynamic MER_pullToRefreshChangingContentInset;
- (BOOL)MER_pullToRefreshChangingContentInset {
    return [objc_getAssociatedObject(self, kMER_pullToRefreshChangingContentInset) boolValue];
}
- (void)setMER_pullToRefreshChangingContentInset:(BOOL)MER_pullToRefreshChangingContentInset {
    objc_setAssociatedObject(self, kMER_pullToRefreshChangingContentInset, @(MER_pullToRefreshChangingContentInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_pullToRefreshDisposable = &kMER_pullToRefreshDisposable;
@dynamic MER_pullToRefreshDisposable;
- (RACCompoundDisposable *)MER_pullToRefreshDisposable {
    return objc_getAssociatedObject(self, kMER_pullToRefreshDisposable);
}
- (void)setMER_pullToRefreshDisposable:(RACCompoundDisposable *)MER_pullToRefreshDisposable {
    objc_setAssociatedObject(self, kMER_pullToRefreshDisposable, MER_pullToRefreshDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
