//
//  MERTwitterKitUserViewModel.m
//  MERTwitterKit
//
//  Created by William Towe on 3/31/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTwitterKitUserViewModel.h"
#import "TwitterKitUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <SDWebImage/SDWebImageManager.h>
#import "MERTwitterClient.h"

@interface MERTwitterKitUserViewModel ()
@property (strong,nonatomic) TwitterKitUser *user;

@property (readwrite,strong,nonatomic) UIImage *profileImage;

@property (strong,nonatomic) id<SDWebImageOperation> userProfileImageOperation;

- (instancetype)initWithUser:(TwitterKitUser *)user;
@end

@implementation MERTwitterKitUserViewModel

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
    
    MERTwitterKitUserViewModel *retval = [kCache objectForKey:user.identity];
    
    if (!retval) {
        retval = [[MERTwitterKitUserViewModel alloc] initWithUser:user];
        
        [kCache setObject:retval forKey:user.identity];
    }
    
    return retval;
}

- (instancetype)initWithUser:(TwitterKitUser *)user; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(user);
    
    [self setUser:user];
    
    @weakify(self);
    
    RAC(self,profileImage) = [[[RACSignal combineLatest:@[self.didBecomeActiveSignal,[RACSignal return:self.user.profileImageUrl]] reduce:^id(id _, NSString *value) {
        return value;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            id<SDWebImageOperation> operation = [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:value] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }];
            
            [self setUserProfileImageOperation:operation];
            
            return nil;
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    [self.didBecomeInactiveSignal
     subscribeNext:^(id _) {
         @strongify(self);
         
         [self.userProfileImageOperation cancel];
         [self setUserProfileImageOperation:nil];
     }];
    
    return self;
}

- (NSString *)name {
    return self.user.name;
}
- (NSString *)screenName {
    return [NSLocalizedStringFromTableInBundle(@"@", nil, MERTwitterKitResourcesBundle(), @"user view model screen name prefix") stringByAppendingString:self.user.screenName];
}

@end
