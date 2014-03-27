//
//  MERPaginatedScrollingView.m
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

#import "MERPaginatedScrollingView.h"
#import <MEFoundation/MEGeometry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>

@interface MERPaginatedScrollingView ()
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (readwrite,assign,nonatomic) CGFloat preferredHeight;
@property (strong,nonatomic) RACCompoundDisposable *compoundDisposable;
@end

@implementation MERPaginatedScrollingView

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _edgeInsets = UIEdgeInsetsMake(20, 0, 20, 0);
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    [self.activityIndicatorView sizeToFit];
    [self addSubview:self.activityIndicatorView];
    
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    [self.compoundDisposable dispose];
    [self setCompoundDisposable:nil];
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [self setCompoundDisposable:[RACCompoundDisposable compoundDisposable]];
        
        @weakify(self);
        
        [self.compoundDisposable addDisposable:
         [[[RACObserve(self, edgeInsets)
           distinctUntilChanged]
          deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(id _) {
             @strongify(self);

             [self setPreferredHeight:self.edgeInsets.top + CGRectGetHeight(self.activityIndicatorView.frame) + self.edgeInsets.bottom];
             
             [self setNeedsLayout];
         }]];
    }
}

- (void)layoutSubviews {
    [self.activityIndicatorView setFrame:ME_CGRectCenterX(CGRectMake(0, self.edgeInsets.top, CGRectGetWidth(self.activityIndicatorView.frame), CGRectGetHeight(self.activityIndicatorView.frame)), self.bounds)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(CGRectGetWidth(self.activityIndicatorView.frame), self.edgeInsets.top + CGRectGetHeight(self.activityIndicatorView.frame) + self.edgeInsets.bottom);
}

- (void)startPaginating {
    [self.activityIndicatorView startAnimating];
}
- (void)stopPaginating {
    [self.activityIndicatorView stopAnimating];
}

@end
