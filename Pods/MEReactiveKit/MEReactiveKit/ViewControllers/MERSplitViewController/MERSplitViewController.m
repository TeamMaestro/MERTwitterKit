//
//  MERSplitViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/3/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERSplitViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MERSplitViewDividerView.h"
#import <MEKit/MEAnythingGestureRecognizer.h>
#import <MEFoundation/MEDebugging.h>

NSString *const MERSplitViewControllerNotificationWillPresentMasterViewController = @"MERSplitViewControllerNotificationWillPresentMasterViewController";
NSString *const MERSplitViewControllerNotificationDidPresentMasterViewController = @"MERSplitViewControllerNotificationDidPresentMasterViewController";

NSString *const MERSplitViewControllerNotificationWillDismissMasterViewController = @"MERSplitViewControllerNotificationWillDismissMasterViewController";
NSString *const MERSplitViewControllerNotificationDidDismissMasterViewController = @"MERSplitViewControllerNotificationDidDismissMasterViewController";

@interface MERSplitViewController () <UIGestureRecognizerDelegate>
@property (strong,nonatomic) UIView<MERSplitViewDividerViewClass> *dividerView;

@property (readwrite,assign,nonatomic) MERSplitViewControllerMasterViewControllerState masterViewControllerState;

@property (strong,nonatomic) MEAnythingGestureRecognizer *gestureRecognizer;

- (CGFloat)_masterViewControllerWidth;

+ (Class)_defaultDividerViewClass;
+ (NSTimeInterval)_defaultMasterViewControllerAnimationDuration;
+ (CGFloat)_defaultMasterViewControllerWidthForSplitViewController:(MERSplitViewController *)splitViewController;
@end

@implementation MERSplitViewController
#pragma mark *** Subclass Overrides ***
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    _dividerViewClass = [self.class _defaultDividerViewClass];
    _masterViewControllerAnimationDuration = [self.class _defaultMasterViewControllerAnimationDuration];
    
    @weakify(self);
    
    [[[[RACObserve(self, gestureRecognizer)
        distinctUntilChanged]
       deliverOn:[RACScheduler mainThreadScheduler]]
      combinePreviousWithStart:nil reduce:^id(id previous, id current) {
          return RACTuplePack(previous,current);
    }] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        
        RACTupleUnpack(UIGestureRecognizer *previous, UIGestureRecognizer *current) = value;
        
        if (previous) {
            [previous.view removeGestureRecognizer:previous];
        }
        
        if (current) {
            [current setDelegate:self];
            
            [[current rac_gestureSignal] subscribeNext:^(id x) {
                 @strongify(self);
                
                [self toggleMasterViewControllerAnimated:YES animations:nil completion:nil];
            }];
            
            [self.view addGestureRecognizer:current];
        }
    }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.masterViewController,@"masterViewController cannot be nil!");
    NSAssert(self.detailViewController,@"detailViewController cannot be nil!");
    
    [self.view addSubview:self.masterViewController.view];
    [self.view addSubview:self.detailViewController.view];
    
    [self setDividerView:[[self.dividerViewClass alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.dividerView];
}
- (void)viewWillLayoutSubviews {
    [self.view bringSubviewToFront:self.masterViewController.view];
    [self.view bringSubviewToFront:self.dividerView];
}
- (void)viewDidLayoutSubviews {
    if (!self.view.isUserInteractionEnabled)
        return;
    
    CGFloat const kMasterViewControllerWidth = [self _masterViewControllerWidth];
    
    if (self.masterViewControllerState == MERSplitViewControllerMasterViewControllerStatePresented) {
        [self.detailViewController.view setFrame:self.view.bounds];
        [self.dividerView setFrame:CGRectMake(CGRectGetMinX(self.detailViewController.view.frame), 0, [self.dividerView dividerWidth], CGRectGetHeight(self.view.bounds))];
        [self.masterViewController.view setFrame:CGRectMake(0, 0, kMasterViewControllerWidth, CGRectGetHeight(self.view.bounds))];
    }
    else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self.detailViewController.view setFrame:self.view.bounds];
        [self.dividerView setFrame:CGRectMake(CGRectGetMinX(self.detailViewController.view.frame), 0, [self.dividerView dividerWidth], CGRectGetHeight(self.view.bounds))];
        [self.masterViewController.view setFrame:CGRectMake(CGRectGetMinX(self.dividerView.frame) - kMasterViewControllerWidth, 0, kMasterViewControllerWidth, CGRectGetHeight(self.view.bounds))];
    }
    else {
        [self.masterViewController.view setFrame:CGRectMake(0, 0, kMasterViewControllerWidth, CGRectGetHeight(self.view.bounds))];
        [self.dividerView setFrame:CGRectMake(CGRectGetMaxX(self.masterViewController.view.frame), 0, [self.dividerView dividerWidth], CGRectGetHeight(self.view.bounds))];
        [self.detailViewController.view setFrame:CGRectMake(CGRectGetMaxX(self.dividerView.frame), 0, CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(self.dividerView.frame), CGRectGetHeight(self.view.bounds))];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.masterViewControllerState == MERSplitViewControllerMasterViewControllerStatePresented &&
        UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
        [self setMasterViewControllerState:MERSplitViewControllerMasterViewControllerStateDismissed];
        [self setGestureRecognizer:nil];
    }
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (!CGRectContainsPoint(self.masterViewController.view.bounds, [touch locationInView:self.masterViewController.view]));
}
#pragma mark *** Public Methods ***
- (void)toggleMasterViewControllerAnimated:(BOOL)animated; {
    [self toggleMasterViewControllerAnimated:animated animations:nil completion:nil];
}
- (void)toggleMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion; {
    [self toggleMasterViewControllerAnimated:animated animations:nil completion:completion];
}
- (void)toggleMasterViewControllerAnimated:(BOOL)animated animations:(void (^)(void))animations completion:(void (^)(void))completion; {
    if (!UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        return;
    
    CGFloat const kMasterViewControllerWidth = [self _masterViewControllerWidth];
    
    @weakify(self);
    
    [self.view setUserInteractionEnabled:NO];
    
    if (self.masterViewControllerState == MERSplitViewControllerMasterViewControllerStateDismissed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MERSplitViewControllerNotificationWillPresentMasterViewController object:self];
        
        [UIView animateWithDuration:(animated) ? self.masterViewControllerAnimationDuration : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            @strongify(self);
            
            [self.masterViewController.view setFrame:CGRectMake(0, 0, kMasterViewControllerWidth, CGRectGetHeight(self.view.bounds))];
            
            if (animations)
                animations();
            
        } completion:^(BOOL finished) {
            @strongify(self);
            
            [self setMasterViewControllerState:MERSplitViewControllerMasterViewControllerStatePresented];
            [self setGestureRecognizer:[[MEAnythingGestureRecognizer alloc] init]];
            
            [self.view setUserInteractionEnabled:YES];

            if (completion)
                completion();
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MERSplitViewControllerNotificationDidPresentMasterViewController object:self];
        }];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:MERSplitViewControllerNotificationWillDismissMasterViewController object:self];
        
        [UIView animateWithDuration:(animated) ? self.masterViewControllerAnimationDuration : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            @strongify(self);
            
            [self.masterViewController.view setFrame:CGRectMake(CGRectGetMinX(self.dividerView.frame) - kMasterViewControllerWidth, 0, kMasterViewControllerWidth, CGRectGetHeight(self.view.bounds))];
            
            if (animations)
                animations();
            
        } completion:^(BOOL finished) {
            @strongify(self);
            
            [self setMasterViewControllerState:MERSplitViewControllerMasterViewControllerStateDismissed];
            [self setGestureRecognizer:nil];
            
            [self.view setUserInteractionEnabled:YES];
            
            if (completion)
                completion();
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MERSplitViewControllerNotificationDidDismissMasterViewController object:self];
        }];
    }
}
#pragma mark Properties
- (void)setMasterViewController:(UIViewController *)masterViewController {
    [_masterViewController willMoveToParentViewController:nil];
    [_masterViewController.view removeFromSuperview];
    [_masterViewController removeFromParentViewController];
    
    _masterViewController = masterViewController;
    
    if (self.masterViewController) {
        [self addChildViewController:self.masterViewController];
        if (self.isViewLoaded)
            [self.view addSubview:self.masterViewController.view];
        [self.masterViewController didMoveToParentViewController:self];
    }
}
- (void)setDetailViewController:(UIViewController *)detailViewController {
    [_detailViewController willMoveToParentViewController:nil];
    [_detailViewController.view removeFromSuperview];
    [_detailViewController removeFromParentViewController];
    
    _detailViewController = detailViewController;
    
    if (self.detailViewController) {
        [self addChildViewController:self.detailViewController];
        if (self.isViewLoaded)
            [self.view addSubview:self.detailViewController.view];
        [self.detailViewController didMoveToParentViewController:self];
    }
}

- (void)setDividerViewClass:(Class)dividerViewClass {
    _dividerViewClass = (dividerViewClass) ?: [self.class _defaultDividerViewClass];
}
- (void)setMasterViewControllerAnimationDuration:(NSTimeInterval)masterViewControllerAnimationDuration {
    _masterViewControllerAnimationDuration = (masterViewControllerAnimationDuration <= 0.0) ? [self.class _defaultMasterViewControllerAnimationDuration] : masterViewControllerAnimationDuration;
}
#pragma mark *** Private Methosd ***
- (CGFloat)_masterViewControllerWidth; {
    CGFloat retval = self.masterViewController.preferredContentSize.width;
    
    if (retval <= 0.0)
        retval = [self.class _defaultMasterViewControllerWidthForSplitViewController:self];
    
    return retval;
}

+ (Class)_defaultDividerViewClass {
    return [MERSplitViewDividerView class];
}
+ (NSTimeInterval)_defaultMasterViewControllerAnimationDuration; {
    return 0.33;
}
+ (CGFloat)_defaultMasterViewControllerWidthForSplitViewController:(MERSplitViewController *)splitViewController; {
    return ceil(CGRectGetWidth(splitViewController.view.bounds) * 0.33);
}

@end

@implementation UIViewController (MERSplitViewControllerExtensions)

- (MERSplitViewController *)MER_splitViewController {
    UIViewController *viewController = self.parentViewController ? self.parentViewController : self.presentingViewController;
    
    while (!(viewController == nil || [viewController isKindOfClass:[MERSplitViewController class]])) {
        viewController = viewController.parentViewController ? viewController.parentViewController : viewController.presentingViewController;
    }
    
    return (MERSplitViewController *)viewController;
}

@end
