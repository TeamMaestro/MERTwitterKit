//
//  MERTweetViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RVMViewModel.h"
#import <UIKit/UIImage.h>

@class MERTwitterKitUserViewModel;

@interface MERTwitterKitTweetViewModel : RVMViewModel

@property (readonly,nonatomic) int64_t identity;

@property (readonly,nonatomic) NSString *text;
@property (readonly,nonatomic) NSSet *hashtagRanges;
@property (readonly,nonatomic) NSSet *mediaRanges;
@property (readonly,nonatomic) NSSet *mentionRanges;
@property (readonly,nonatomic) NSSet *symbolRanges;
@property (readonly,nonatomic) NSSet *urlRanges;

@property (readonly,nonatomic) NSDate *createdAt;
@property (readonly,nonatomic) NSString *relativeCreatedAtString;

@property (readonly,strong,nonatomic) UIImage *mediaThumbnailImage;

@property (readonly,strong,nonatomic) MERTwitterKitUserViewModel *userViewModel;

@end
