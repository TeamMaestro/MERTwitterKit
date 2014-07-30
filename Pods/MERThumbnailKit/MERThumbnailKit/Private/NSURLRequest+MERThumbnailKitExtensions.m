//
//  NSURLRequest+MERThumbnailKitExtensions.m
//  MERThumbnailKit
//
//  Created by William Towe on 5/4/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSURLRequest+MERThumbnailKitExtensions.h"
#import <ReactiveCocoa/RACSubscriber.h>

static NSString *const kMER_subscriberKey = @"kMER_subscriberKey";
static NSString *const kMER_downloadProgressBlock = @"kMER_downloadProgressBlock";

@implementation NSURLRequest (MERThumbnailKitExtensions)

- (id<RACSubscriber>)MER_subscriber {
    return [NSURLProtocol propertyForKey:kMER_subscriberKey inRequest:self];
}
- (MERThumbnailManagerDownloadProgressBlock)MER_downloadProgressBlock {
    return [NSURLProtocol propertyForKey:kMER_downloadProgressBlock inRequest:self];
}

@end

@implementation NSMutableURLRequest (MERThumbnailKitExtensions)

- (void)setMER_subscriber:(id<RACSubscriber>)MER_subscriber {
    [NSURLProtocol setProperty:MER_subscriber forKey:kMER_subscriberKey inRequest:self];
}
- (void)setMER_downloadProgressBlock:(MERThumbnailManagerDownloadProgressBlock)MER_downloadProgressBlock {
    [NSURLProtocol setProperty:MER_downloadProgressBlock forKey:kMER_downloadProgressBlock inRequest:self];
}

@end
