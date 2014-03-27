//
//  UIScrollView+MERPaginatedScrollingExtensions.m
//  MEReactiveKit
//
//  Created by William Towe on 3/11/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIScrollView+MERPaginatedScrollingExtensions.h"
#import "MERPaginatedScrollingView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>

#import <objc/runtime.h>

@interface UIScrollView (MERPaginatedScrollingExtensionsPrivate)
@property (readwrite,strong,nonatomic) UIView<MERPaginatedScrolling> *MER_paginatedScrollingView;
@property (readwrite,assign,nonatomic) MERPaginatedScrollingState MER_paginatedScrollingState;
@property (assign,nonatomic) UIEdgeInsets MER_originalContentInset;
@property (strong,nonatomic) RACCompoundDisposable *MER_paginatedScrollingDisposable;
@end

@implementation UIScrollView (MERPaginatedScrollingExtensions)

- (void)MER_addPaginatedScrollingViewWithBlock:(void (^)(MERPaginatedScrollingCompletionBlock completion))block; {
    [self MER_addPaginatedScrollingView:[[MERPaginatedScrollingView alloc] initWithFrame:CGRectZero] block:block];
}
- (void)MER_addPaginatedScrollingView:(UIView<MERPaginatedScrolling> *)view block:(void (^)(MERPaginatedScrollingCompletionBlock completion))block; {
    NSParameterAssert(view);
    NSParameterAssert(block);
    
    [self MER_removePaginatedScrollingView];
    
    [self setMER_paginatedScrollingEnabled:YES];
    
    [self setMER_paginatedScrollingView:view];
    [self.MER_paginatedScrollingView sizeToFit];
    [self addSubview:self.MER_paginatedScrollingView];
    
    [self setMER_paginatedScrollingDisposable:[RACCompoundDisposable compoundDisposable]];
    [self.rac_deallocDisposable addDisposable:self.MER_paginatedScrollingDisposable];
    
    @weakify(self);
    
    MERPaginatedScrollingCompletionBlock completion = ^{
        @strongify(self);
        
        [self setMER_paginatedScrollingState:MERPaginatedScrollingStateNone];
        
        [self.MER_paginatedScrollingView stopPaginating];
        
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            @strongify(self);
            
            [self setContentInset:self.MER_originalContentInset];
        } completion:nil];
    };
    
    [self.MER_paginatedScrollingDisposable addDisposable:
     [[[RACSignal combineLatest:@[[RACObserve(self, contentSize) distinctUntilChanged],RACObserve(self.MER_paginatedScrollingView, preferredHeight)]]
       deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(RACTuple *value) {
          @strongify(self);
          
          RACTupleUnpack(NSValue *contentSize, NSNumber *preferredHeight) = value;
          
          [self setNeedsLayout];
          [self layoutIfNeeded];
          
          [self.MER_paginatedScrollingView setFrame:CGRectMake(0, contentSize.CGSizeValue.height, CGRectGetWidth(self.bounds), preferredHeight.floatValue)];
    }]];
    
    [self.MER_paginatedScrollingDisposable addDisposable:
     [[[[[RACSignal combineLatest:@[[RACObserve(self, MER_paginatedScrollingEnabled) distinctUntilChanged],RACObserve(self, contentOffset)]] filter:^BOOL(RACTuple *value) {
        return [value.first boolValue];
    }] map:^id(RACTuple *value) {
        return value.second;
    }] deliverOn:[RACScheduler mainThreadScheduler]]
      subscribeNext:^(NSValue *value) {
          @strongify(self);
          
          switch (self.MER_paginatedScrollingState) {
              case MERPaginatedScrollingStateNone:
                  if (self.isDragging &&
                      (value.CGPointValue.y > self.contentSize.height - CGRectGetHeight(self.bounds))) {
                      [self setMER_paginatedScrollingState:MERPaginatedScrollingStateWillPaginate];
                      
                      [self.MER_paginatedScrollingView startPaginating];
                  }
                  break;
              case MERPaginatedScrollingStateWillPaginate:
                  if (!self.isDragging) {
                      [self setMER_paginatedScrollingState:MERPaginatedScrollingStatePaginating];
                      
                      [self.MER_paginatedScrollingView startPaginating];
                      
                      if (UIEdgeInsetsEqualToEdgeInsets(self.MER_originalContentInset, UIEdgeInsetsZero))
                          [self setMER_originalContentInset:UIEdgeInsetsMake(self.contentInset.top, 0, 0, 0)];
                      
                      [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
                          @strongify(self);
                          
                          [self setContentInset:UIEdgeInsetsMake(self.MER_originalContentInset.top, self.MER_originalContentInset.left, self.MER_originalContentInset.bottom + self.MER_paginatedScrollingView.preferredHeight, self.MER_originalContentInset.right)];
                      } completion:^(BOOL finished) {
                          block(completion);
                      }];
                  }
                  break;
              case MERPaginatedScrollingStatePaginating:
                  if (value.CGPointValue.y < self.contentSize.height - CGRectGetHeight(self.bounds)) {
                      [self setMER_paginatedScrollingState:MERPaginatedScrollingStateNone];
                      
                      [self.MER_paginatedScrollingView stopPaginating];
                  }
                  break;
              default:
                  break;
          }
    }]];
}

- (void)MER_removePaginatedScrollingView; {
    if (self.MER_paginatedScrollingView) {
        [self.MER_paginatedScrollingDisposable dispose];
        [self setMER_paginatedScrollingDisposable:nil];
        
        [self.MER_paginatedScrollingView removeFromSuperview];
        [self setMER_paginatedScrollingView:nil];
        
        [self setMER_paginatedScrollingEnabled:NO];
    }
}

static void const *kMER_paginatedScrollingEnabled = &kMER_paginatedScrollingEnabled;

@dynamic MER_paginatedScrollingEnabled;
- (BOOL)MER_paginatedScrollingEnabled {
    return (self.MER_paginatedScrollingView != nil && [objc_getAssociatedObject(self, kMER_paginatedScrollingEnabled) boolValue]);
}
- (void)setMER_paginatedScrollingEnabled:(BOOL)MER_paginatedScrollingEnabled {
    objc_setAssociatedObject(self, kMER_paginatedScrollingEnabled, @(MER_paginatedScrollingEnabled), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIScrollView (MERPaginatedScrollingExtensionsPrivate)

static void const *kMER_paginatedScrollingView = &kMER_paginatedScrollingView;
@dynamic MER_paginatedScrollingView;
- (UIView<MERPaginatedScrolling> *)MER_paginatedScrollingView {
    return objc_getAssociatedObject(self, kMER_paginatedScrollingView);
}
- (void)setMER_paginatedScrollingView:(UIView<MERPaginatedScrolling> *)MER_paginatedScrollingView {
    objc_setAssociatedObject(self, kMER_paginatedScrollingView, MER_paginatedScrollingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_paginatingScrollingState = &kMER_paginatingScrollingState;
@dynamic MER_paginatedScrollingState;
- (MERPaginatedScrollingState)MER_paginatedScrollingState {
    return [objc_getAssociatedObject(self, kMER_paginatingScrollingState) integerValue];
}
- (void)setMER_paginatedScrollingState:(MERPaginatedScrollingState)MER_paginatedScrollingState {
    objc_setAssociatedObject(self, kMER_paginatingScrollingState, @(MER_paginatedScrollingState), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static void const *kMER_originalContentInset = &kMER_originalContentInset;
@dynamic MER_originalContentInset;
- (UIEdgeInsets)MER_originalContentInset {
    return [objc_getAssociatedObject(self, kMER_originalContentInset) UIEdgeInsetsValue];
}
- (void)setMER_originalContentInset:(UIEdgeInsets)MER_originalContentInset {
    objc_setAssociatedObject(self, kMER_originalContentInset, [NSValue valueWithUIEdgeInsets:MER_originalContentInset], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static void const *kMER_paginatedScrollingDisposable = &kMER_paginatedScrollingDisposable;
@dynamic MER_paginatedScrollingDisposable;
- (RACCompoundDisposable *)MER_paginatedScrollingDisposable {
    return objc_getAssociatedObject(self, kMER_paginatedScrollingDisposable);
}
- (void)setMER_paginatedScrollingDisposable:(RACCompoundDisposable *)MER_paginatedScrollingDisposable {
    objc_setAssociatedObject(self, kMER_paginatedScrollingDisposable, MER_paginatedScrollingDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
