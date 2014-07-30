//
//  UIWebView+MERThumbnailKitExtensions.m
//  MERThumbnailKit
//
//  Created by William Towe on 5/2/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UIWebView+MERThumbnailKitExtensions.h"
#import <ReactiveCocoa/RACSubscriber.h>

#import <objc/runtime.h>

@implementation UIWebView (MERThumbnailKitExtensions)

static void const *kMER_subscriberKey = &kMER_subscriberKey;

@dynamic MER_subscriber;
- (id<RACSubscriber>)MER_subscriber {
    return objc_getAssociatedObject(self, kMER_subscriberKey);
}
- (void)setMER_subscriber:(id<RACSubscriber>)MER_subscriber {
    objc_setAssociatedObject(self, kMER_subscriberKey, MER_subscriber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_originalURLKey = &kMER_originalURLKey;

@dynamic MER_originalURL;
- (NSURL *)MER_originalURL {
    return objc_getAssociatedObject(self, kMER_originalURLKey);
}
- (void)setMER_originalURL:(NSURL *)MER_originalURL {
    objc_setAssociatedObject(self, kMER_originalURLKey, MER_originalURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_concurrentRequestCountKey = &kMER_concurrentRequestCountKey;

@dynamic MER_concurrentRequestCount;
- (NSInteger)MER_concurrentRequestCount {
    return [objc_getAssociatedObject(self, kMER_concurrentRequestCountKey) integerValue];
}
- (void)setMER_concurrentRequestCount:(NSInteger)MER_concurrentRequestCount {
    objc_setAssociatedObject(self, kMER_concurrentRequestCountKey, @(MER_concurrentRequestCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static void const *kMER_hasInjectedJavascriptKey = &kMER_hasInjectedJavascriptKey;

@dynamic MER_hasInjectedJavascript;
- (BOOL)MER_hasInjectedJavascript {
    return [objc_getAssociatedObject(self, kMER_hasInjectedJavascriptKey) boolValue];
}
- (void)setMER_hasInjectedJavascript:(BOOL)MER_hasInjectedJavascript {
    objc_setAssociatedObject(self, kMER_hasInjectedJavascriptKey, @(MER_hasInjectedJavascript), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
