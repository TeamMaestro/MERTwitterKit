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

#import <Social/Social.h>

NSString *const MERTwitterClientErrorDomain = @"MERTwitterClientErrorDomain";
NSInteger const MERTwitterClientErrorCodeNoAccounts = 1;
NSString *const MERTwitterClientErrorUserInfoKeyAlertTitle = @"MERTwitterClientErrorUserInfoKeyAlertTitle";
NSString *const MERTwitterClientErrorUserInfoKeyAlertMessage = @"MERTwitterClientErrorUserInfoKeyAlertMessage";
NSString *const MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle = @"MERTwitterClientErrorUserInfoKeyAlertCancelButtonTitle";

NSString *const MERTwitterKitResourcesBundleName = @"MERTwitterKitResources.bundle";
NSBundle *MERTwitterKitResourcesBundle(void) {
    return [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:MERTwitterKitResourcesBundleName.stringByDeletingPathExtension withExtension:MERTwitterKitResourcesBundleName.pathExtension]];
}

@interface MERTwitterClient ()
@property (strong,nonatomic) ACAccountStore *accountStore;

@property (strong,nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSManagedObjectContext *writeManagedObjectContext;

- (RACSignal *)_importTweetJSON:(NSArray *)json;

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

- (RACSignal *)requestUserTimelineTweetsForUserWithIdentity:(int64_t)userIdentity screenName:(NSString *)screenName afterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    NSParameterAssert(userIdentity > 0 || screenName);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kUserIdKey = @"user_id";
        
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
    return [self requestUpdateWithStatus:status media:nil replyIdentity:0 latitude:0 longitude:0 placeIdentity:nil];
}
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity; {
    return [self requestUpdateWithStatus:status media:nil replyIdentity:replyIdentity latitude:0 longitude:0 placeIdentity:nil];
}
- (RACSignal *)requestUpdateWithStatus:(NSString *)status replyIdentity:(int64_t)replyIdentity latitude:(CGFloat)latitude longitude:(CGFloat)longitude placeIdentity:(NSString *)placeIdentity; {
    return [self requestUpdateWithStatus:status media:nil replyIdentity:replyIdentity latitude:latitude longitude:longitude placeIdentity:placeIdentity];
}
- (RACSignal *)requestUpdateWithStatus:(NSString *)status media:(NSArray *)media replyIdentity:(int64_t)replyIdentity latitude:(CGFloat)latitude longitude:(CGFloat)longitude placeIdentity:(NSString *)placeIdentity; {
    NSParameterAssert(status);
    
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *const kStatusKey = @"status";
        NSString *const kInReplyToStatusIdKey = @"in_reply_to_status_id";
        NSString *const kMultipartFormDataKey = @"multipart/form-data";
        NSString *const kLatitudeKey = @"lat";
        NSString *const kLongitudeKey = @"long";
        NSString *const kPlaceIdKey = @"place_id";
        NSString *const kMediaKey = @"media[]";
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:(media) ? @"statuses/update_with_media.json" : @"statuses/update.json" relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
        [request setAccount:self.selectedAccount];
        
        [request addMultipartData:[(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)status, CFSTR("!@#$%^*()-+/'\" "), CFSTR("&"), kCFStringEncodingUTF8) dataUsingEncoding:NSUTF8StringEncoding] withName:kStatusKey type:kMultipartFormDataKey filename:nil];
        
        for (UIImage *image in media) {
            CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
            NSData *data = (__bridge_transfer NSData *)CGDataProviderCopyData(dataProvider);
            
            [request addMultipartData:data withName:kMediaKey type:kMultipartFormDataKey filename:[[NSUUID UUID] UUIDString]];
        }
        
        if (replyIdentity > 0)
            [request addMultipartData:[@(replyIdentity).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kInReplyToStatusIdKey type:kMultipartFormDataKey filename:nil];
        if (latitude != 0.0)
            [request addMultipartData:[@(latitude).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kLatitudeKey type:kMultipartFormDataKey filename:nil];
        if (longitude != 0.0)
            [request addMultipartData:[@(longitude).stringValue dataUsingEncoding:NSUTF8StringEncoding] withName:kLongitudeKey type:kMultipartFormDataKey filename:nil];
        if (placeIdentity)
            [request addMultipartData:[placeIdentity dataUsingEncoding:NSUTF8StringEncoding] withName:kPlaceIdKey type:kMultipartFormDataKey filename:nil];
        
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
    }] deliverOn:[RACScheduler mainThreadScheduler]];
}
#pragma mark *** Private Methods ***
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
            
            if ([context ME_saveRecursively:NULL]) {
                [self.managedObjectContext performBlock:^{
                    NSArray *objects = [[context.parentContext ME_objectsForObjectIDs:objectIds] MER_map:^id(id value) {
                        return [MERTwitterKitTweetViewModel viewModelWithTweet:value];
                    }];
                    
                    [subscriber sendNext:objects];
                    [subscriber sendCompleted];
                }];
            }
            else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
}

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
        
        MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    }
    
    return retval;
}
- (TwitterKitUser *)_userWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSParameterAssert(dict);
    NSParameterAssert(context);
    
    NSString *const kProfileImageUrlKey = @"profile_image_url_https";
    NSString *const kNameKey = @"name";
    
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
