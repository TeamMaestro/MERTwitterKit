//
//  MESelectedLocalizationViewController.m
//  MEKit
//
//  Created by William Towe on 3/15/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MESelectedLocalizationViewController.h"
#import <MEFoundation/NSObject+MELocalizationExtensions.h>

static void *kMESelectedLocalizationViewControllerContext = &kMESelectedLocalizationViewControllerContext;

@interface MESelectedLocalizationViewController ()

@end

@implementation MESelectedLocalizationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:MELocalizationUserDefaultsKeySelectedLocalization options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:kMESelectedLocalizationViewControllerContext];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:MELocalizationUserDefaultsKeySelectedLocalization context:kMESelectedLocalizationViewControllerContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kMESelectedLocalizationViewControllerContext) {
        if ([keyPath isEqualToString:MELocalizationUserDefaultsKeySelectedLocalization]) {
            [self selectedLocalizationDidChange:change[NSKeyValueChangeNewKey]];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)selectedLocalizationDidChange:(NSString *)selectedLocalization; {
    
}

@dynamic selectedLocalication;
- (NSString *)selectedLocalication {
    return [self.class ME_selectedLocalization];
}
- (void)setSelectedLocalication:(NSString *)selectedLocalication {
    [self.class ME_setSelectedLocalization:selectedLocalication];
}

@end
