//
//  MESelectedLocalizationViewController.h
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

#import <UIKit/UIKit.h>

/**
 `MESelectedLocalizationViewController` is a light wrapper around the localization methods provided in `MEFoundation/NSObject+MELocalizationExtensions.h`.
 
 It provides a property to retrieve the selected localization and a public method to override and respond to changes when the selected localization does change.
 */
@interface MESelectedLocalizationViewController : UIViewController

/**
 Returns the selected localization.
 
 Calls through to `ME_selectedLocalization` and `ME_setSelectedLocalization:`.
 */
@property (strong,nonatomic) NSString *selectedLocalication;

/**
 This method is called whenever `ME_selectedLocalization` changes. The receiver can use this method to update anything that depends on the selected localization.
 
 @param selectedLocalization The selected localization (e.g. `@"en"`)
 */
- (void)selectedLocalizationDidChange:(NSString *)selectedLocalization;

@end
