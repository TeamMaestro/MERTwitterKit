//
//  MERPullToRefreshView.m
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

#import "MERPullToRefreshView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEGeometry.h>

@interface MERPullToRefreshView ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (readwrite,assign,nonatomic) CGFloat preferredHeight;
@property (strong,nonatomic) RACCompoundDisposable *compoundDisposable;
@end

@implementation MERPullToRefreshView

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _edgeInsets = UIEdgeInsetsMake(32, 0, 32, 0);
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setText:@"Pull to Refresh…"];
    [self addSubview:self.titleLabel];
    
    [self setActivityIndicatorView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]];
    [self.activityIndicatorView sizeToFit];
    [self addSubview:self.activityIndicatorView];
    
    @weakify(self);
    
    [[[RACObserve(self, pullToRefreshState)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         
         switch (value.integerValue) {
             case MERPullToRefreshStateNone:
                 [self.titleLabel setHidden:NO];
                 [self.activityIndicatorView stopAnimating];
                 break;
             case MERPullToRefreshStateWillRefresh:
                 [self.titleLabel setHidden:NO];
                 [self.activityIndicatorView stopAnimating];
                 break;
             case MERPullToRefreshStateRefreshing:
                 [self.titleLabel setHidden:YES];
                 [self.activityIndicatorView startAnimating];
                 break;
             default:
                 break;
         }
    }];
    
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
              
              [self setPreferredHeight:self.edgeInsets.top + MAX(ceil(self.titleLabel.font.lineHeight), CGRectGetHeight(self.activityIndicatorView.frame)) + self.edgeInsets.bottom];
              
              [self setNeedsLayout];
          }]];
    }
}

- (void)layoutSubviews {
    [self.titleLabel setFrame:self.bounds];
    [self.activityIndicatorView setFrame:ME_CGRectCenterX(CGRectMake(0, self.edgeInsets.top, CGRectGetWidth(self.activityIndicatorView.frame), CGRectGetHeight(self.activityIndicatorView.frame)), self.bounds)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(CGRectGetWidth(self.activityIndicatorView.frame), self.edgeInsets.top + CGRectGetHeight(self.activityIndicatorView.frame) + self.edgeInsets.bottom);
}

@synthesize pullToRefreshState=_pullToRefreshState;

@end
