//
//  MERTwitterClient.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

typedef void(^MERTwitterClientRequestTwitterAccountsCompletionBlock)(ACAccount *selectedAccount);

extern NSString *const MERTwitterClientErrorDomain;
extern NSInteger const MERTwitterClientErrorCodeNoAccounts;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle;
extern NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle;

extern NSString *const MERTwitterKitResourcesBundleName;
extern NSBundle *MERTwitterKitResourcesBundle(void);

@class RACSignal;

@interface MERTwitterClient : NSObject

@property (readonly,strong,nonatomic) NSArray *accounts;
@property (readonly,strong,nonatomic) ACAccount *selectedAccount;

+ (instancetype)sharedClient;

- (RACSignal *)requestAccounts;
- (RACSignal *)selectAccount;

- (RACSignal *)requestHomeTimelineTweets;

@end
