//
//  MERWebViewController.h
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

#import "MERViewController.h"

/**
 `MERWebViewController` is a `MERViewController` subclass that manages a `UIWebView` instance.
 */
@interface MERWebViewController : MERViewController

/**
 Returns whether the receiver's `UIWebView` is loading.
 */
@property (readonly,assign,nonatomic,getter = isLoading) BOOL loading;

/**
 Calls `loadURLRequest:`, passing `[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]`.
 
 @see loadURLRequest:
 */
- (void)loadURLString:(NSString *)urlString;
/**
 Calls `loadURLRequest:`, passing `[NSURLRequest requestWithURL:url]`.
 
 @see loadURLRequest:
 */
- (void)loadURL:(NSURL *)url;
/**
 Calls `loadRequest:` on the receiver's `UIWebView`, passing _request_.
 
 @param request The request to load, passing nil will stop any existing load
 */
- (void)loadURLRequest:(NSURLRequest *)request;

@end
