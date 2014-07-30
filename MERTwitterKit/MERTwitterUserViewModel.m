//
//  MERTwitterUserViewModel.m
//  MERTwitterKit
//
//  Created by William Towe on 3/31/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTwitterUserViewModel.h"
#import "MERTwitterUserViewModel+Private.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <MERThumbnailKit/MERThumbnailKit.h>
#import "MERTwitterClient.h"

@interface MERTwitterUserViewModel ()
@property (readwrite,strong,nonatomic) TwitterKitUser *user;

@property (readwrite,strong,nonatomic) UIImage *profileImage;

- (instancetype)initWithUser:(TwitterKitUser *)user;
@end

@implementation MERTwitterUserViewModel

- (NSUInteger)hash {
    return self.user.hash;
}
- (BOOL)isEqual:(id)object {
    return [self.user isEqual:object];
}

+ (instancetype)viewModelWithUser:(TwitterKitUser *)user; {
    static NSCache *kCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kCache = [[NSCache alloc] init];
    });
    
    MERTwitterUserViewModel *retval = [kCache objectForKey:user.identity];
    
    if (!retval) {
        retval = [[MERTwitterUserViewModel alloc] initWithUser:user];
        
        [kCache setObject:retval forKey:user.identity];
    }
    
    return retval;
}

- (instancetype)initWithUser:(TwitterKitUser *)user; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(user);
    
    [self setUser:user];
    
    RAC(self,profileImage) = [[[RACSignal combineLatest:@[self.didBecomeActiveSignal,[RACSignal return:self.user.profileImageUrl]] reduce:^id(id _, NSString *value) {
        return value;
    }] flattenMap:^RACStream *(id value) {
        return [[[MERThumbnailManager sharedManager] downloadFileWithURL:[NSURL URLWithString:value] progress:nil] reduceEach:^id (NSURL *url, NSURL *fileURL, NSNumber *_){
            return [UIImage imageWithContentsOfFile:fileURL.path];
        }];
        
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}

- (int64_t)identity {
    return self.user.identity.longLongValue;
}

- (NSString *)name {
    return self.user.name;
}
- (NSString *)screenName {
    return [NSLocalizedStringFromTableInBundle(@"@", nil, MERTwitterKitResourcesBundle(), @"user view model screen name prefix") stringByAppendingString:self.user.screenName];
}

@end
