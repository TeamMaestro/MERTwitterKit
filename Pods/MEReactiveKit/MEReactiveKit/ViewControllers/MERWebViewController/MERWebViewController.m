//
//  MERWebViewController.m
//  MEReactiveKit
//
//  Created by William Towe on 3/4/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERWebViewController.h"
#import "MERCommon.h"
#import <MEKit/UIImage+MEExtensions.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MEFoundation/MEDebugging.h>
#import "MERActivityOpenInSafari.h"
#import "MERActivityOpenInChrome.h"

@interface MERWebViewController () <UIWebViewDelegate>
@property (strong,nonatomic) UIWebView *webView;

@property (readwrite,assign,nonatomic,getter = isLoading) BOOL loading;
@property (strong,nonatomic) NSURLRequest *request;
@end

@implementation MERWebViewController
#pragma mark *** Subclass Overrides ***
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:NULL];
    UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:NULL];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage ME_imageNamed:@"web_view_back.png" inBundleNamed:MEReactiveKitResourcesBundleName] style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage ME_imageNamed:@"web_view_forward.png" inBundleNamed:MEReactiveKitResourcesBundleName] style:UIBarButtonItemStylePlain target:nil action:NULL];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:NULL];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    @weakify(self);
    
    [reloadItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.webView reload];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [stopItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.webView stopLoading];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [backItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.webView goBack];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [forwardItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.webView goForward];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [shareItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.request.URL] applicationActivities:@[[[MERActivityOpenInSafari alloc] init],[[MERActivityOpenInChrome alloc] init]]];
            
            [self presentViewController:viewController animated:YES completion:nil];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    RAC(self,toolbarItems) = [[RACSignal combineLatest:@[[RACObserve(self, loading) distinctUntilChanged]] reduce:^id(NSNumber *loading){
        return (loading.boolValue) ? @[flexibleSpaceItem,backItem,flexibleSpaceItem,forwardItem,flexibleSpaceItem,stopItem,flexibleSpaceItem,shareItem,flexibleSpaceItem] : @[flexibleSpaceItem,backItem,flexibleSpaceItem,forwardItem,flexibleSpaceItem,reloadItem,flexibleSpaceItem,shareItem,flexibleSpaceItem];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWebView:[[UIWebView alloc] initWithFrame:CGRectZero]];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    
    @weakify(self);
    
    [[[RACObserve(self, request)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSURLRequest *value) {
         @strongify(self);
         
         [self.webView stopLoading];
         
         if (value)
             [self.webView loadRequest:value];
    }];
    
    [[[RACObserve(self, loading)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:value.boolValue];
    }];
}
- (void)viewDidLayoutSubviews {
    [self.webView setFrame:self.view.bounds];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent) {
        [self.webView setDelegate:nil];
        [self.webView stopLoading];
    }
}
#pragma mark MERViewController
- (MERViewControllerNavigationItemOptions)navigationItemOptions {
    return MERViewControllerNavigationItemOptionViewWillAppear;
}
- (void)configureNavigationItem {
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [activityIndicatorView setHidesWhenStopped:YES];
    [activityIndicatorView setColor:self.view.tintColor];
    
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    
    @weakify(self);
    
    [doneItem setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }]];
    
    [[[RACObserve(self, loading)
       distinctUntilChanged]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         if (value.boolValue)
             [activityIndicatorView startAnimating];
         else
             [activityIndicatorView stopAnimating];
    }];
    
    if (self.presentingViewController) {
        [self.navigationItem setLeftBarButtonItems:@[doneItem]];
        [self.navigationItem setRightBarButtonItems:@[activityItem]];
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[activityItem]];
    }
}
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self setLoading:YES];
    [self setTitle:NSLocalizedStringFromTableInBundle(@"Loading…", nil, MEReactiveKitResourcesBundle(), @"web view controller loading with ellipsis")];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self setLoading:NO];
    [self setTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    MELogObject(error);
    
    [self setLoading:NO];
}
#pragma mark *** Public Methods ***
- (void)loadURLString:(NSString *)urlString; {
    [self loadURLRequest:(urlString) ? [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] : nil];
}
- (void)loadURL:(NSURL *)url; {
    [self loadURLRequest:(url) ? [NSURLRequest requestWithURL:url] : nil];
}
- (void)loadURLRequest:(NSURLRequest *)request; {
    [self setRequest:request];
}

@end
