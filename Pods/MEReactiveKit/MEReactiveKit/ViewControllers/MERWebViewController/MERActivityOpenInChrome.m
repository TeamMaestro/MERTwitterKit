//
//  MERActivityOpenInChrome.m
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

#import "MERActivityOpenInChrome.h"
#import "MERCommon.h"
#import <MEKit/UIImage+MEExtensions.h>

static NSString *const kMERActivityOpenInChromePrefix = @"googlechrome://";

@interface MERActivityOpenInChrome ()
@property (copy,nonatomic) NSURL *url;
@end

@implementation MERActivityOpenInChrome

- (NSString *)activityType {
    return NSStringFromClass(self.class);
}
- (NSString *)activityTitle {
    return NSLocalizedStringFromTableInBundle(@"Open in Chrome", nil, MEReactiveKitResourcesBundle(), @"activity open in chrome title");
}
- (UIImage *)activityImage {
    return [UIImage ME_imageNamed:@"web_view_open_in_chrome.png" inBundleNamed:MEReactiveKitResourcesBundleName];
}
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] &&
            [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kMERActivityOpenInChromePrefix]]) {
            
			return YES;
		}
	}
	return NO;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			[self setUrl:activityItem];
            break;
		}
	}
}
- (void)performActivity {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[kMERActivityOpenInChromePrefix stringByAppendingString:[self.url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
    [self activityDidFinish:YES];
}

@end
