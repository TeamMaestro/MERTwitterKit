//
//  MERTwitterClient.m
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

#import "MERTwitterClient.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TwitterKitTweet.h"
#import "TwitterKitUser.h"
#import <MECoreDataKit/MECoreDataKit.h>
#import <MEFoundation/NSFileManager+MEExtensions.h>
#import <MEFoundation/MEDebugging.h>
#import <MEReactiveFoundation/MEReactiveFoundation.h>
#import "MERTwitterKitTweetViewModel+Private.h"
#import "MERTwitterKitUserViewModel+Private.h"
#import "TwitterKitMedia.h"
#import "TwitterKitHashtag.h"
#import "TwitterKitSymbol.h"
#import "TwitterKitUrl.h"
#import "TwitterKitMediaSize.h"
#import "TwitterKitMention.h"
#import "TwitterKitPlace.h"
#import <MEFoundation/NSArray+MEExtensions.h>
#import <libextobjc/EXTScope.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACDelegateProxy.h>
#import "MERTwitterKitPlaceViewModel+Private.h"

#import <Social/Social.h>

int64_t const MERTwitterClientCursorInitial = -1;

NSString *const MERTwitterClientErrorDomain = @"MERTwitterClientErrorDomain";
NSInteger const MERTwitterClientErrorCodeNoAccounts = 1;
NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle = @"MERTwitterClientErrorUserInfoKeyAlertTitle";
NSString *const MERTwitterClientErrorUserInfoKeyAlertMessage = @"MERTwitterClientErrorUserInfoKeyAlertMessage";
NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle = @"MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle";

NSString *const MERTwitterKitResourcesBundleName = @"MERTwitterKitResources.bundle";
NSBundle *MERTwitterKitResourcesBundle(void) {
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:MERTwitterKitResourcesBundleName.stringByDeletingPathExtension withExtension:MERTwitterKitResourcesBundleName.pathExtension]];
}

static NSString *const kMERTwitterClientHelpConfigurationName = @"MERTwitterKit.help.configuration.json";

@interface MERTwitterClient (Private)
- (RACSignal *)requestHelpConfiguration;
@end

@interface MERTwitterClient ()
@property (strong,nonatomic) ACAccountStore *accountStore;

@property (strong,nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSManagedObjectContext *writeManagedObjectContext;

@property (copy,nonatomic) NSDictionary *helpConfiguration;

+ (NSDictionary *)_geoGranularityEnumsToGranularityStrings;

- (RACSignal *)_importTweetJSON:(NSArray *)json;
- (RACSignal *)_importUserJSON:(NSArray *)json;
- (RACSignal *)_importPlaceJSON:(NSArray *)json;

- (TwitterKitTweet *)_tweetWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitUser *)_userWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitHashtag *)_hashtagWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitUrl *)_urlWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitMedia *)_mediaWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitMediaSize *)_mediaSizeWithName:(NSString *)name dictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitMention *)_mentionWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitPlace *)_placeWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitSymbol *)_symbolWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
@end

@implementation MERTwitterClient
#pragma mark *** Subclass Overrides ***
- (id)init {
    if (!(self = [super init]))
        return nil;
    
    NSURL *modelURL = [MERTwitterKitResourcesBundle() URLForResource:@"MERTwitterKit" withExtension:@"momd"];
    
    [self setPersistentStoreCoordinator:[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]]];
    
    NSURL *storeURL = [[NSFileManager defaultManager].ME_applicationSupportDirectoryURL URLByAppendingPathComponent:@"MERTwitterKit.sqlite" isDirectory:NO];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,NSInferMappingModelAutomaticallyOption : @YES};
    
    NSError *outError;
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&outError]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
        
        if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&outError]) {
            MELogObject(outError);
        }
    }
    
    [self setWriteManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [self.writeManagedObjectContext setUndoManager:nil];
    [self.writeManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [self.managedObjectContext setUndoManager:nil];
    [self.managedObjectContext setParentContext:self.writeManagedObjectContext];
    
    [self setAccountStore:[[ACAccountStore alloc] init]];
    
    [self setHttpSessionManager:[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]]];
    [self.httpSessionManager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:0]];
    [self.httpSessionManager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:0]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSURL *helpConfigurationUrl = [[NSFileManager defaultManager].ME_applicationSupportDirectoryURL URLByAppendingPathComponent:kMERTwitterClientHelpConfigurationName isDirectory:NO];
    
    if ([helpConfigurationUrl checkResourceIsReachableAndReturnError:NULL]) {
        NSData *data = [NSData dataWithContentsOfURL:helpConfigurationUrl options:0 error:NULL];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        [self setHelpConfiguration:json];
    }
    
    @weakify(self);
    
    [[[RACObserve(self, selectedAccount)
       distinctUntilChanged]
      ignore:nil]
     subscribeNext:^(id _) {
         @strongify(self);
         
         if (!self.helpConfiguration) {
             [[self requestHelpConfiguration] subscribeNext:^(NSDictionary *value) {
                 @strongify(self);
                 
                 NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:NULL];
                 
                 [[NSFileManager defaultManager] removeItemAtURL:helpConfigurationUrl error:NULL];
                 
                 [data writeToURL:helpConfigurationUrl options:NSDataWritingAtomic error:NULL];
                 
                 [self setHelpConfiguration:value];
             }];
         }
    }];
    
    return self;
}
#pragma mark *** Public Methods ***
+ (instancetype)sharedClient; {
    static id retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[[self class] alloc] init];
    });
    return retval;
}
#pragma mark Accounts
- (RACSignal *)requestAccounts; {
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            @strongify(self);
            
            if (granted) {
                NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                
                if (accounts.count > 0) {
                    [subscriber sendNext:accounts];
                    [subscriber sendCompleted];
                }
                else {
                    [subscriber sendError:[NSError errorWithDomain:MERTwitterClientErrorDomain code:MERTwitterClientErrorCodeNoAccounts userInfo:@{MERTwitterClientErrorUserInfoKeyAlertMessage: NSLocalizedStringFromTableInBundle(@"No Twitter accounts. Setup a Twitter account in the Settings application.", nil, MERTwitterKitResourcesBundle(), @"no accounts localized description"), MERTwitterClientErrorUserInfoKeyAlertTitle: NSLocalizedStringFromTableInBundle(@"Error", nil, MERTwitterKitResourcesBundle(), @"no accounts alert title"), MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle: NSLocalizedStringFromTableInBundle(@"Dismiss", nil, MERTwitterKitResourcesBundle(), @"no accounts alert cancel title")}]];
                }
            }
            else {
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Timelines
static NSString *const kSinceIdKey = @"since_id";
static NSString *const kMaxIdKey = @"max_id";
static NSString *const kCountKey = @"count";

- (RACSignal *)requestMentionsTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/mentions_timeline.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

static NSString *const kScreenNameKey = @"screen_name";
static NSString *const kUserIdKey = @"user_id";

- (RACSignal *)requestUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSParameterAssert(userIdentity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (userIdentity > 0)
            [parameters setObject:@(userIdentity) forKey:kUserIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/user_timeline.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (NSArray *)fetchUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSParameterAssert(userIdentity > 0 || screenName);
    
    TwitterKitUser *user = (userIdentity > 0) ? [self.managedObjectContext ME_fetchEntityNamed:[TwitterKitUser entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitUserAttributes.identity,@(userIdentity)] sortDescriptors:nil error:NULL].firstObject : [self.managedObjectContext ME_fetchEntityNamed:[TwitterKitUser entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitUserAttributes.screenName,screenName] sortDescriptors:nil error:NULL].firstObject;
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitTweetRelationships.user,user]];
    
    if (afterIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K > %@",TwitterKitTweetAttributes.identity,@(afterIdentity)]];
    if (beforeIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K < 0",TwitterKitTweetAttributes.identity]];
    
    return [[self.managedObjectContext ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:count predicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:TwitterKitUserAttributes.identity ascending:NO]] error:NULL] MER_map:^id(id value) {
        return [MERTwitterKitTweetViewModel viewModelWithTweet:value];
    }];
}
- (RACSignal *)requestHomeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/home_timeline.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)requestRetweetsOfMeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/retweets_of_me.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Tweets
- (NSArray *)fetchTweetsAfterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (afterIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K > %@",TwitterKitTweetAttributes.identity,@(afterIdentity)]];
    if (beforeIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K < 0",TwitterKitTweetAttributes.identity]];
    
    return [[self.managedObjectContext ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:count predicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:TwitterKitUserAttributes.identity ascending:NO]] error:NULL] MER_map:^id(id value) {
        return [MERTwitterKitTweetViewModel viewModelWithTweet:value];
    }];
}

- (RACSignal *)requestRetweetsOfTweetWithIdentity:(int64_t)identity count:(NSUInteger)count; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:[NSString stringWithFormat:@"statuses/retweets/%@.json",@(identity)] relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (MERTwitterKitTweetViewModel *)fetchTweetWithIdentity:(int64_t)identity; {
    NSParameterAssert(identity > 0);
    
    TwitterKitTweet *tweet = [self.managedObjectContext ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitTweetAttributes.identity,@(identity)] sortDescriptors:nil error:NULL].firstObject;
    
    return (tweet) ? [MERTwitterKitTweetViewModel viewModelWithTweet:tweet] : nil;
}
- (RACSignal *)requestTweetWithIdentity:(int64_t)identity; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:@(identity) forKey:kIdKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/show.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [[self _importTweetJSON:value] map:^id(NSArray *value) {
            return value.firstObject;
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)requestDestroyTweetWithIdentity:(int16_t)identity; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:[NSString stringWithFormat:@"statuses/destroy/%@.json",@(identity)] relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            @strongify(self);
            
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [self.managedObjectContext performBlock:^{
                    @strongify(self);
                    
                    TwitterKitTweet *tweet = [self.managedObjectContext ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitTweetAttributes.identity,@(identity)] sortDescriptors:nil error:NULL].firstObject;
                    
                    NSParameterAssert(tweet);
                    
                    [self.managedObjectContext deleteObject:tweet];
                    [self.managedObjectContext ME_saveRecursively:NULL];
                    
                    [subscriber sendNext:@YES];
                    [subscriber sendCompleted];
                }];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)requestUpdateWithStatus:(NSString *)status; {
    return [self requestUpdateWithStatus:status media:nil replyIdentity:0 location:kCLLocationCoordinate2DInvalid placeIdentity:nil];
}
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity; {
    return [self requestUpdateWithStatus:status media:nil replyIdentity:replyIdentity location:kCLLocationCoordinate2DInvalid placeIdentity:nil];
}
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity; {
    return [self requestUpdateWithStatus:status media:nil replyIdentity:replyIdentity location:location placeIdentity:placeIdentity];
}

static NSString *const kMultipartFormDataKey = @"multipart/form-data";
static NSString *const kPlaceIdKey = @"place_id";
static NSString *const kLatitudeKey = @"lat";
static NSString *const kLongitudeKey = @"long";

- (RACSignal *)requestUpdateWithStatus:(NSString *)status media:(NSArray *)media replyIdentity:(int64_t)replyIdentity location:(CLLocationCoordinate2D)location placeIdentity:(NSString *)placeIdentity; {
    NSParameterAssert(status);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kStatusKey = @"status";
        NSString *const kInReplyToStatusIdKey = @"in_reply_to_status_id";
        NSString *const kMediaKey = @"media[]";
        NSString *const kPhotoSizeLimitKey = @"photo_size_limit";
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:(media) ? @"statuses/update_with_media.json" : @"statuses/update.json" relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        [request addMultipartData:[(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)status, CFSTR("!@#$%^*()-+/'\" "), CFSTR("&"), kCFStringEncodingUTF8) dataUsingEncoding:NSUTF8StringEncoding] withName:kStatusKey type:kMultipartFormDataKey filename:nil];
        
        for (UIImage *image in media) {
            CGFloat compression = 1.0;
            NSData *data = UIImageJPEGRepresentation(image, compression);
            
            if (data.length > [self.helpConfiguration[kPhotoSizeLimitKey] unsignedIntegerValue]) {
                while (data.length > [self.helpConfiguration[kPhotoSizeLimitKey] unsignedIntegerValue]) {
                    compression -= 0.1;
                    
                    data = UIImageJPEGRepresentation(image, compression);
                }
            }
            
            [request addMultipartData:data withName:kMediaKey type:kMultipartFormDataKey filename:[[NSUUID UUID] UUIDString]];
        }
        
        if (replyIdentity > 0)
            [request addMultipartData:[@(replyIdentity).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kInReplyToStatusIdKey type:kMultipartFormDataKey filename:nil];
        if (CLLocationCoordinate2DIsValid(location)) {
            [request addMultipartData:[@(location.latitude).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kLatitudeKey type:kMultipartFormDataKey filename:nil];
            [request addMultipartData:[@(location.longitude).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kLongitudeKey type:kMultipartFormDataKey filename:nil];
        }
        if (placeIdentity)
            [request addMultipartData:[placeIdentity dataUsingEncoding:NSUTF8StringEncoding] withName:kPlaceIdKey type:kMultipartFormDataKey filename:nil];
        
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            
            if (urlResponse.statusCode == 200) {
                [subscriber sendNext:[NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL]];
                [subscriber sendCompleted];
            }
            else {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
                
                [subscriber sendError:[NSError errorWithDomain:MERTwitterClientErrorDomain code:[json[@"errors"][0][@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey: json[@"errors"][0][@"message"]}]];
            }
        }];
        
        return nil;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [[self _importTweetJSON:@[value]] map:^id(NSArray *value) {
            return value.firstObject;
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)requestRetweetOfTweetWithIdentity:(int64_t)identity; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:[NSString stringWithFormat:@"statuses/retweet/%@.json",@(identity)] relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [[self _importTweetJSON:@[value]] map:^id(NSArray *value) {
            return value.firstObject;
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

static NSString *const kCursorKey = @"cursor";
static NSString *const kIdsKey = @"ids";
static NSString *const kNextCursorKey = @"next_cursor";
static NSString *const kPreviousCursorKey = @"previous_cursor";

- (RACSignal *)requestRetweetersOfTweetWithIdentity:(int64_t)identity cursor:(int64_t)cursor; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:@(identity) forKey:kIdKey];
        
        if (cursor != MERTwitterClientCursorInitial)
            [parameters setObject:@(cursor) forKey:kCursorKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/retweeters/ids.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(NSDictionary *dict) {
        @strongify(self);
        
        NSArray *ids = dict[kIdsKey];
        
        return [[self _importUserJSON:[ids MER_map:^id(NSNumber *value) {
            return @{kIdKey: @(value.longLongValue)};
        }]] map:^id(id value) {
            return RACTuplePack(value,dict[kNextCursorKey],dict[kPreviousCursorKey]);
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Search
- (NSArray *)fetchTweetsMatchingSearch:(NSString *)search afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    [predicates addObject:[NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@",TwitterKitTweetAttributes.text,search]];
    
    if (afterIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K > %@",TwitterKitTweetAttributes.identity,@(afterIdentity)]];
    if (beforeIdentity > 0)
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K < 0",TwitterKitTweetAttributes.identity]];
    
    return [[self.managedObjectContext ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:count predicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates] sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:TwitterKitTweetAttributes.identity ascending:NO]] error:NULL] MER_map:^id(id value) {
        return [MERTwitterKitTweetViewModel viewModelWithTweet:value];
    }];
}

static NSString *const kStatusesKey = @"statuses";

- (RACSignal *)requestTweetsMatchingSearch:(NSString *)search type:(MERTwitterClientSearchType)type afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSParameterAssert(search);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kQueryKey = @"q";
        NSString *const kResultTypeKey = @"result_type";
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)search, NULL, NULL, kCFStringEncodingUTF8) forKey:kQueryKey];
        
        switch (type) {
            case MERTwitterClientSearchTypeMixed:
                [parameters setObject:@"mixed" forKey:kResultTypeKey];
                break;
            case MERTwitterClientSearchTypePopular:
                [parameters setObject:@"popular" forKey:kResultTypeKey];
                break;
            case MERTwitterClientSearchTypeRecent:
                [parameters setObject:@"recent" forKey:kResultTypeKey];
                break;
            default:
                break;
        }
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"search/tweets.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(NSDictionary *value) {
        @strongify(self);
        
        return [self _importTweetJSON:value[kStatusesKey]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Streaming
- (RACSignal *)requestStreamForTweetsMatchingKeywords:(NSArray *)keywords userIdentities:(NSArray *)userIdentities locations:(NSArray *)locations; {
    NSParameterAssert(keywords || userIdentities || locations);
    
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kTrackKey = @"track";
        NSString *const kFollowKey = @"follow";
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (keywords)
            [parameters setObject:[keywords componentsJoinedByString:@","] forKey:kTrackKey];
        if (userIdentities) {
            [parameters setObject:[[userIdentities MER_map:^id(NSNumber *value) {
                return value.stringValue;
            }] componentsJoinedByString:@","] forKey:kFollowKey];
        }
        if (locations) {
            // TODO: add support for locations parameter
        }
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://stream.twitter.com/1.1/statuses/filter.json"] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        RACDelegateProxy *proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(NSURLConnectionDataDelegate)];
        
        [[proxy signalForSelector:@selector(connection:didFailWithError:)]
         subscribeNext:^(RACTuple *value) {
             [subscriber sendError:value.second];
         }];
        
        [[proxy signalForSelector:@selector(connectionDidFinishLoading:)]
         subscribeNext:^(id x) {
             [subscriber sendCompleted];
         }];
        
        [[proxy signalForSelector:@selector(connection:didReceiveData:)]
         subscribeNext:^(RACTuple *value) {
             @strongify(self);
             
             NSData *data = value.second;
             NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSMutableArray *json = [[NSMutableArray alloc] init];
             
             for (NSString *chunk in [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
                 if (chunk.length == 0)
                     continue;
                 
                 NSData *chunkData = [chunk dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *chunkJson = [NSJSONSerialization JSONObjectWithData:chunkData options:0 error:NULL];
                 
                 if (chunkJson[kIdKey])
                     [json addObject:chunkJson];
             }
             
             if (json.count > 0) {
                 [[self _importTweetJSON:json] subscribeNext:^(id x) {
                     [subscriber sendNext:x];
                 }];
             }
         }];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[request preparedURLRequest] delegate:proxy startImmediately:NO];
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start];
        
        return [RACDisposable disposableWithBlock:^{
            [connection cancel];
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Friends & Followers
- (RACSignal *)requestFriendshipCreateForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName; {
    NSParameterAssert(identity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identity > 0)
            [parameters setObject:@(identity) forKey:kUserIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"friendships/create.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importUserJSON:@[value]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
- (RACSignal *)requestFriendshipDestroyForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName; {
    NSParameterAssert(identity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identity > 0)
            [parameters setObject:@(identity) forKey:kUserIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"friendships/destroy.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importUserJSON:@[value]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

static NSString *const kUsersKey = @"users";

- (RACSignal *)requestFriendsForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor; {
    NSParameterAssert(identity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identity > 0)
            [parameters setObject:@(identity) forKey:kUserIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        if (cursor != MERTwitterClientCursorInitial)
            [parameters setObject:@(cursor) forKey:kCursorKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"friends/list.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(NSDictionary *dict) {
        @strongify(self);
        
        return [[self _importUserJSON:dict[kUsersKey]] map:^id(id value) {
            return RACTuplePack(value,dict[kNextCursorKey],dict[kPreviousCursorKey]);
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
- (RACSignal *)requestFollowersForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName count:(NSUInteger)count cursor:(int64_t)cursor; {
    NSParameterAssert(identity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identity > 0)
            [parameters setObject:@(identity) forKey:kUserIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        if (cursor != MERTwitterClientCursorInitial)
            [parameters setObject:@(cursor) forKey:kCursorKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"followers/list.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(NSDictionary *dict) {
        @strongify(self);
        
        return [[self _importUserJSON:dict[kUsersKey]] map:^id(id value) {
            return RACTuplePack(value,dict[kNextCursorKey],dict[kPreviousCursorKey]);
        }];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)requestFriendshipStatusForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName; {
    return [self requestFriendshipStatusForUsersWithIdentities:(identity > 0) ? @[@(identity)] : nil screenNames:(screenName) ? @[screenName] : nil];
}
- (RACSignal *)requestFriendshipStatusForUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames; {
    NSParameterAssert(identities || screenNames);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kConnectionsKey = @"connections";
        NSString *const kFollowingKey = @"following";
        NSString *const kFollowingRequestedKey = @"following_requested";
        NSString *const kFollowedBy = @"followed_by";
        NSString *const kNoneKey = @"none";
        NSString *const kBlockingKey = @"blocking";
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identities) {
            [parameters setObject:[[identities MER_map:^id(NSNumber *value) {
                return value.stringValue;
            }] componentsJoinedByString:@","] forKey:kUserIdKey];
        }
        if (screenNames)
            [parameters setObject:[screenNames componentsJoinedByString:@","] forKey:kUserIdKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"friendships/lookup.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                NSArray *json = responseObject;
                
                [[[self _importUserJSON:json] zipWith:[RACSignal return:[json MER_map:^id(NSDictionary *value) {
                    NSArray *connections = value[kConnectionsKey];
                    NSSet *connectionsSet = [connections ME_set];
                    MERTwitterClientFriendshipStatus status = MERTwitterClientFriendshipStatusNone;
                    
                    if ([connectionsSet containsObject:kFollowedBy])
                        status |= MERTwitterClientFriendshipStatusFollowedBy;
                    if ([connectionsSet containsObject:kFollowingKey])
                        status |= MERTwitterClientFriendshipStatusFollowing;
                    if ([connectionsSet containsObject:kFollowingRequestedKey])
                        status |= MERTwitterClientFriendshipStatusFollowingRequested;
                    if ([connectionsSet containsObject:kBlockingKey])
                        status |= MERTwitterClientFriendshipStatusBlocking;
                    if ([connectionsSet containsObject:kNoneKey])
                        status |= MERTwitterClientFriendshipStatusNone;
                    
                    return @(status);
                }]]] subscribe:subscriber];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
#pragma mark Favorites
- (RACSignal *)requestFavoritesForUserWithIdentity:(int64_t)identity screenName:(NSString *)screenName afterIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSParameterAssert(identity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (identity > 0)
            [parameters setObject:@(identity) forKey:kIdKey];
        if (screenName)
            [parameters setObject:screenName forKey:kScreenNameKey];
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:kSinceIdKey];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:kMaxIdKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kCountKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"favorites/list.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)requestFavoriteCreateForTweetWithIdentity:(int64_t)identity; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:@(identity) forKey:kIdKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"favorites/create.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:@[value]];
    }] flattenMap:^RACStream *(MERTwitterKitTweetViewModel *value) {
        @strongify(self);
        
        [value.tweet setFavorited:@YES];
        
        [self.managedObjectContext ME_saveRecursively:NULL];
        
        return [RACSignal return:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
- (RACSignal *)requestFavoriteDestroyForTweetWithIdentity:(int64_t)identity; {
    NSParameterAssert(identity > 0);
    
    @weakify(self);
    
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:@(identity) forKey:kIdKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"favorites/destroy.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importTweetJSON:@[value]];
    }] flattenMap:^RACStream *(MERTwitterKitTweetViewModel *value) {
        @strongify(self);
        
        [value.tweet setFavorited:@NO];
        
        [self.managedObjectContext ME_saveRecursively:NULL];
        
        return [RACSignal return:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark Places & Geo
- (RACSignal *)requestPlaceWithIdentity:(NSString *)identity; {
    NSParameterAssert(identity);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:[NSString stringWithFormat:@"geo/id/%@.json",identity] relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        
        return [self _importPlaceJSON:@[value]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}

static NSString *const kMaxResultsKey = @"max_results";
static NSString *const kResultKey = @"result";
static NSString *const kPlacesKey = @"places";

- (RACSignal *)requestPlacesWithLocation:(CLLocationCoordinate2D)location accuracy:(CLLocationDistance)accuracy granularity:(MERTwitterClientGeoGranularity)granularity count:(NSUInteger)count; {
    NSParameterAssert(CLLocationCoordinate2DIsValid(location));
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kAccuracyKey = @"accuracy";
        NSString *const kGranularityKey = @"granularity";
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters setObject:@(location.latitude) forKey:kLatitudeKey];
        [parameters setObject:@(location.longitude) forKey:kLongitudeKey];
        [parameters setObject:[self.class _geoGranularityEnumsToGranularityStrings][@(granularity)] forKey:kGranularityKey];
        
        if (accuracy != 0.0)
            [parameters setObject:@(accuracy) forKey:kAccuracyKey];
        if (count > 0)
            [parameters setObject:@(count) forKey:kMaxResultsKey];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"geo/reverse_geocode.json" relativeToURL:self.httpSessionManager.baseURL] parameters:parameters];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] flattenMap:^RACStream *(NSDictionary *value) {
        @strongify(self);
        
        return [self _importPlaceJSON:value[kResultKey][kPlacesKey]];
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark *** Private Methods ***
#pragma mark Class
+ (NSDictionary *)_geoGranularityEnumsToGranularityStrings; {
    static NSDictionary *retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = @{@(MERTwitterClientGeoGranularityAdmin): @"admin",
                   @(MERTwitterClientGeoGranularityCity): @"city",
                   @(MERTwitterClientGeoGranularityCountry): @"country",
                   @(MERTwitterClientGeoGranularityNeighborhood): @"neighborhood",
                   @(MERTwitterClientGeoGranularityPOI): @"poi"};
    });
    return retval;
}
#pragma mark Signals
- (RACSignal *)_importTweetJSON:(NSArray *)json; {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [context setUndoManager:nil];
        [context setParentContext:self.managedObjectContext];
        [context performBlock:^{
            @strongify(self);
            
            NSMutableArray *objectIds = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in json) {
                TwitterKitTweet *tweet = [self _tweetWithDictionary:dict context:context];
                
                [objectIds addObject:tweet.objectID];
            }
            
            NSError *outError;
            if ([context ME_saveRecursively:&outError]) {
                [self.managedObjectContext performBlock:^{
                    NSArray *objects = [[context.parentContext ME_objectsForObjectIDs:objectIds] MER_map:^id(id value) {
                        return [MERTwitterKitTweetViewModel viewModelWithTweet:value];
                    }];
                    
                    [subscriber sendNext:objects];
                    [subscriber sendCompleted];
                }];
            }
            else {
                [subscriber sendError:outError];
            }
        }];
        
        return nil;
    }];
}

- (RACSignal *)_importUserJSON:(NSArray *)json; {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [context setUndoManager:nil];
        [context setParentContext:self.managedObjectContext];
        [context performBlock:^{
            @strongify(self);
            
            NSMutableArray *objectIds = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in json) {
                TwitterKitUser *user = [self _userWithDictionary:dict context:context];
                
                [objectIds addObject:user.objectID];
            }
            
            NSError *outError;
            if ([context ME_saveRecursively:&outError]) {
                [self.managedObjectContext performBlock:^{
                    NSArray *objects = [[context.parentContext ME_objectsForObjectIDs:objectIds] MER_map:^id(id value) {
                        return [MERTwitterKitUserViewModel viewModelWithUser:value];
                    }];
                    
                    [subscriber sendNext:objects];
                    [subscriber sendCompleted];
                }];
            }
            else {
                [subscriber sendError:outError];
            }
        }];
        
        return nil;
    }];
}
- (RACSignal *)_importPlaceJSON:(NSArray *)json; {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [context setUndoManager:nil];
        [context setParentContext:self.managedObjectContext];
        [context performBlock:^{
            @strongify(self);
            
            NSMutableArray *objectIds = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in json) {
                TwitterKitPlace *place = [self _placeWithDictionary:dict context:context];
                
                [objectIds addObject:place.objectID];
            }
            
            NSError *outError;
            if ([context ME_saveRecursively:&outError]) {
                [self.managedObjectContext performBlock:^{
                    NSArray *objects = [[context.parentContext ME_objectsForObjectIDs:objectIds] MER_map:^id(id value) {
                        return [MERTwitterKitPlaceViewModel viewModelWithPlace:value];
                    }];
                    
                    [subscriber sendNext:objects];
                    [subscriber sendCompleted];
                }];
            }
            else {
                [subscriber sendError:outError];
            }
        }];
        
        return nil;
    }];
}
#pragma mark Creation
static NSString *const kIdKey = @"id";
static NSString *const kTextKey = @"text";
static NSString *const kIndicesKey = @"indices";
static NSString *const kUrlKey = @"url";
static NSString *const kDisplayUrlKey = @"display_url";
static NSString *const kExpandedUrlKey = @"expanded_url";
static NSString *const kCoordinatesKey = @"coordinates";

- (TwitterKitTweet *)_tweetWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kCreatedAtKey = @"created_at";
    NSString *const kUserKey = @"user";
    NSString *const kEntitiesKey = @"entities";
    NSString *const kHashtagsKey = @"hashtags";
    NSString *const kUrlsKey = @"urls";
    NSString *const kMediaKey = @"media";
    NSString *const kMentionsKey = @"user_mentions";
    NSString *const kPlaceKey = @"place";
    NSString *const kSymbolsKey = @"symbols";
    NSString *const kRetweetedStatusKey = @"retweeted_status";
    NSString *const kRetweetedKey = @"retweeted";
    NSString *const kRetweetCountKey = @"retweet_count";
    NSString *const kFavoritedKey = @"favorited";
    NSString *const kFavoriteCountKey = @"favorite_count";
    
    NSNumber *identity = dict[kIdKey];
    
    NSParameterAssert(identity);
    
    TwitterKitTweet *retval = [context ME_fetchEntityNamed:[TwitterKitTweet entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitTweetAttributes.identity,identity] sortDescriptors:nil error:NULL].firstObject;
    
    if (!retval) {
        NSDateFormatter *createdAtDateFormatter = [NSThread currentThread].threadDictionary[TwitterKitTweetAttributes.createdAt];
        
        if (!createdAtDateFormatter) {
            createdAtDateFormatter = [[NSDateFormatter alloc] init];
            
            [createdAtDateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
            
            [[NSThread currentThread].threadDictionary setObject:createdAtDateFormatter forKey:TwitterKitTweetAttributes.createdAt];
        }
        
        retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitTweet entityName] inManagedObjectContext:context];
        
        [retval setIdentity:identity];
        [retval setText:dict[kTextKey]];
        [retval setCreatedAt:[createdAtDateFormatter dateFromString:dict[kCreatedAtKey]]];
        
        if ([dict[kCoordinatesKey] isKindOfClass:[NSDictionary class]]) {
            [retval setCoordinates:[NSValue valueWithCGPoint:CGPointMake([dict[kCoordinatesKey][kCoordinatesKey][1] doubleValue], [dict[kCoordinatesKey][kCoordinatesKey][0] doubleValue])]];
        }
        
        if ([dict[kEntitiesKey] isKindOfClass:[NSDictionary class]]) {
            [retval setHashtags:[[dict[kEntitiesKey][kHashtagsKey] MER_map:^id(NSDictionary *value) {
                return [self _hashtagWithDictionary:value context:context];
            }] ME_set]];
            
            [retval setUrls:[[dict[kEntitiesKey][kUrlsKey] MER_map:^id(NSDictionary *value) {
                return [self _urlWithDictionary:value context:context];
            }] ME_set]];
            
            [retval setMedia:[[dict[kEntitiesKey][kMediaKey] MER_map:^id(NSDictionary *value) {
                return [self _mediaWithDictionary:value context:context];
            }] ME_set]];
            
            [retval setMentions:[[dict[kEntitiesKey][kMentionsKey] MER_map:^id(NSDictionary *value) {
                return [self _mentionWithDictionary:value context:context];
            }] ME_set]];
            
            [retval setSymbols:[[dict[kEntitiesKey][kSymbolsKey] MER_map:^id(NSDictionary *value) {
                return [self _symbolWithDictionary:value context:context];
            }] ME_set]];
        }
        
        if ([dict[kPlaceKey] isKindOfClass:[NSDictionary class]]) {
            [retval setPlace:[self _placeWithDictionary:dict[kPlaceKey] context:context]];
        }
        
        if (dict[kUserKey]) {
            TwitterKitUser *user = [self _userWithDictionary:dict[kUserKey] context:context];
            
            [retval setUser:user];
        }
        
        if (dict[kRetweetedStatusKey]) {
            TwitterKitTweet *retweet = [self _tweetWithDictionary:dict[kRetweetedStatusKey] context:context];
            
            [retval setRetweet:retweet];
        }
        
        MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    }
    
    [retval setRetweeted:dict[kRetweetedKey]];
    [retval setRetweetCount:dict[kRetweetCountKey]];
    [retval setFavorited:dict[kFavoritedKey]];
    [retval setFavoriteCount:dict[kFavoriteCountKey]];
    
    return retval;
}
- (TwitterKitUser *)_userWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kProfileImageUrlKey = @"profile_image_url_https";
    NSString *const kNameKey = @"name";
    NSString *const kFollowersCountKey = @"followers_count";
    NSString *const kFriendsCountKey = @"friends_count";
    
    NSNumber *identity = dict[@"id"];
    
    NSParameterAssert(identity);
    
    TwitterKitUser *retval = [context ME_fetchEntityNamed:[TwitterKitUser entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitUserAttributes.identity,identity] sortDescriptors:nil error:NULL].firstObject;
    
    if (!retval) {
        retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitUser entityName] inManagedObjectContext:context];
        
        [retval setIdentity:identity];
        
        MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    }
    
    if (dict[kProfileImageUrlKey])
        [retval setProfileImageUrl:dict[kProfileImageUrlKey]];
    if (dict[kNameKey])
        [retval setName:dict[kNameKey]];
    if (dict[kScreenNameKey])
        [retval setScreenName:dict[kScreenNameKey]];
    if (dict[kFollowersCountKey])
        [retval setFollowersCount:dict[kFollowersCountKey]];
    if (dict[kFriendsCountKey])
        [retval setFriendsCount:dict[kFriendsCountKey]];
    
    return retval;
}
- (TwitterKitHashtag *)_hashtagWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *text = dict[kTextKey];
    
    NSParameterAssert(text);
    
    TwitterKitHashtag *retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitHashtag entityName] inManagedObjectContext:context];
    
    [retval setText:text];
    [retval setRange:[NSValue valueWithRange:NSMakeRange([dict[kIndicesKey][0] unsignedIntegerValue], [dict[kIndicesKey][1] unsignedIntegerValue] - [dict[kIndicesKey][0] unsignedIntegerValue])]];
    
    MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    
    return retval;
}
- (TwitterKitUrl *)_urlWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *url = dict[kUrlKey];
    
    NSParameterAssert(url);
    
    TwitterKitUrl *retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitUrl entityName] inManagedObjectContext:context];
    
    [retval setUrl:url];
    [retval setDisplayUrl:dict[kDisplayUrlKey]];
    [retval setExpandedUrl:dict[kExpandedUrlKey]];
    [retval setRange:[NSValue valueWithRange:NSMakeRange([dict[kIndicesKey][0] unsignedIntegerValue], [dict[kIndicesKey][1] unsignedIntegerValue] - [dict[kIndicesKey][0] unsignedIntegerValue])]];
    
    MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    
    return retval;
}
- (TwitterKitMedia *)_mediaWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kMediaUrlKey = @"media_url_https";
    NSString *const kTypeKey = @"type";
    NSString *const kSizesKey = @"sizes";
    
    NSNumber *identity = dict[kIdKey];
    
    NSParameterAssert(identity);
    
    TwitterKitMedia *retval = [context ME_fetchEntityNamed:[TwitterKitMedia entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitMediaAttributes.identity,identity] sortDescriptors:nil error:NULL].firstObject;
    
    if (!retval) {
        retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitMedia entityName] inManagedObjectContext:context];
        
        [retval setIdentity:identity];
        [retval setUrl:dict[kUrlKey]];
        [retval setDisplayUrl:dict[kDisplayUrlKey]];
        [retval setExpandedUrl:dict[kExpandedUrlKey]];
        [retval setMediaUrl:dict[kMediaUrlKey]];
        [retval setType:dict[kTypeKey]];
        [retval setRange:[NSValue valueWithRange:NSMakeRange([dict[kIndicesKey][0] unsignedIntegerValue], [dict[kIndicesKey][1] unsignedIntegerValue] - [dict[kIndicesKey][0] unsignedIntegerValue])]];
        
        [dict[kSizesKey] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *value, BOOL *stop) {
            [retval.sizesSet addObject:[self _mediaSizeWithName:key dictionary:value context:context]];
        }];
        
        MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    }
    
    return retval;
}
- (TwitterKitMediaSize *)_mediaSizeWithName:(NSString *)name dictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(name);
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kResizeKey = @"resize";
    NSString *const kWidthKey = @"w";
    NSString *const kHeightKey = @"h";
    
    TwitterKitMediaSize *retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitMediaSize entityName] inManagedObjectContext:context];
    
    [retval setName:name];
    [retval setResize:dict[kResizeKey]];
    [retval setWidth:dict[kWidthKey]];
    [retval setHeight:dict[kHeightKey]];
    
    MELog(@"created entity %@ with name %@ and dict %@",retval.entity.name,name,dict);
    
    return retval;
}
- (TwitterKitMention *)_mentionWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    TwitterKitMention *retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitMention entityName] inManagedObjectContext:context];
    
    [retval setRange:[NSValue valueWithRange:NSMakeRange([dict[kIndicesKey][0] unsignedIntegerValue], [dict[kIndicesKey][1] unsignedIntegerValue] - [dict[kIndicesKey][0] unsignedIntegerValue])]];
    [retval setUser:[self _userWithDictionary:dict context:context]];
    
    MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    
    return retval;
}
- (TwitterKitPlace *)_placeWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kBoundingBoxKey = @"bounding_box";
    NSString *const kCountryKey = @"country";
    NSString *const kCountryCodeKey = @"country_code";
    NSString *const kFullNameKey = @"full_name";
    NSString *const kNameKey = @"name";
    NSString *const kPlaceTypeKey = @"place_type";
    NSString *const kContainedWithinKey = @"contained_within";
    
    NSString *identity = dict[kIdKey];
    
    NSParameterAssert(identity);
    
    TwitterKitPlace *retval = [context ME_fetchEntityNamed:[TwitterKitPlace entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitPlaceAttributes.identity,identity] sortDescriptors:nil error:NULL].firstObject;
    
    if (!retval) {
        retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitPlace entityName] inManagedObjectContext:context];
        
        [retval setIdentity:identity];
    }
    
    [retval setBoundingBox:dict[kBoundingBoxKey][kCoordinatesKey]];
    [retval setCountry:dict[kCountryKey]];
    [retval setCountryCode:dict[kCountryCodeKey]];
    [retval setFullName:dict[kFullNameKey]];
    [retval setName:dict[kNameKey]];
    [retval setType:dict[kPlaceTypeKey]];
    
    if ([dict[kContainedWithinKey] isKindOfClass:[NSArray class]]) {
        [retval setContainedWithin:[[dict[kContainedWithinKey] MER_map:^id(id value) {
            return [self _placeWithDictionary:value context:context];
        }] ME_set]];
    }
    
    return retval;
}
- (TwitterKitSymbol *)_symbolWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *text = dict[kTextKey];
    
    NSParameterAssert(text);
    
    TwitterKitSymbol *retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitSymbol entityName] inManagedObjectContext:context];
    
    [retval setText:text];
    [retval setRange:[NSValue valueWithRange:NSMakeRange([dict[kIndicesKey][0] unsignedIntegerValue], [dict[kIndicesKey][1] unsignedIntegerValue] - [dict[kIndicesKey][0] unsignedIntegerValue])]];
    
    return retval;
}

@end

@implementation MERTwitterClient (Private)

- (RACSignal *)requestHelpConfiguration; {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"help/configuration.json" relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        NSURLSessionDataTask *task = [self.httpSessionManager dataTaskWithRequest:[request preparedURLRequest] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

@end
