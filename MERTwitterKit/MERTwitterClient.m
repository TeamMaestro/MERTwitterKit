//
//  MERTwitterClient.m
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//

#import "MERTwitterClient.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "TwitterKitTweet.h"
#import "TwitterKitUser.h"
#import <MECoreDataKit/MECoreDataKit.h>
#import <MEFoundation/NSFileManager+MEExtensions.h>
#import <MEFoundation/MEDebugging.h>
#import <MEReactiveFoundation/MEReactiveFoundation.h>
#import "MERTwitterKitTweetViewModel.h"

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
@property (readwrite,strong,nonatomic) NSArray *accounts;
@property (readwrite,strong,nonatomic) ACAccount *selectedAccount;

@property (strong,nonatomic) AFHTTPSessionManager *httpSessionManager;

@property (strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) NSManagedObjectContext *writeManagedObjectContext;

- (RACSignal *)_importTweetJSON:(NSArray *)json;

- (TwitterKitTweet *)_tweetWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
- (TwitterKitUser *)_userWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context;
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
- (RACSignal *)selectAccount; {
    @weakify(self);
    
    return [[self requestAccounts] flattenMap:^RACStream *(NSArray *value) {
        @strongify(self);
        
        MERTwitterClientRequestTwitterAccountsCompletionBlock completionBlock = ^(ACAccount *selectedAccount) {
            @strongify(self);
            
            [self setSelectedAccount:selectedAccount];
        };
        
        return [RACSignal return:@[value,completionBlock]];
    }];
}

- (RACSignal *)requestHomeTimelineTweetsAfterTweetWithIdentity:(int64_t)afterIdentity beforeIdentity:(int64_t)beforeIdentity count:(NSUInteger)count; {
    @weakify(self);
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        if (afterIdentity > 0)
            [parameters setObject:@(afterIdentity) forKey:@"since_id"];
        if (beforeIdentity > 0)
            [parameters setObject:@(beforeIdentity) forKey:@"max_id"];
        if (count > 0)
            [parameters setObject:@(count) forKey:@"count"];
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"statuses/home_timeline.json" relativeToURL:self.httpSessionManager.baseURL] parameters:nil];
        
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
                        return [[MERTwitterKitTweetViewModel alloc] initWithTweet:value];
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

- (TwitterKitTweet *)_tweetWithDictionary:(NSDictionary *)dict context:(NSManagedObjectContext *)context; {
    NSString *const kTextKey = @"text";
    NSString *const kCreatedAtKey = @"created_at";
    NSString *const kUserKey = @"user";
    NSString *const kIdKey = @"id";
    NSString *const kCoordinatesKey = @"coordinates";
    NSString *const kEntities = @"entities";
    
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
            [retval setLongitude:dict[kCoordinatesKey][kCoordinatesKey][0]];
            [retval setLatitude:dict[kCoordinatesKey][kCoordinatesKey][1]];
        }
        
        if ([dict[kEntities] isKindOfClass:[NSDictionary class]]) {
            
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
    NSNumber *identity = dict[@"id"];
    
    NSParameterAssert(identity);
    
    TwitterKitUser *retval = [context ME_fetchEntityNamed:[TwitterKitUser entityName] limit:1 predicate:[NSPredicate predicateWithFormat:@"%K == %@",TwitterKitUserAttributes.identity,identity] sortDescriptors:nil error:NULL].firstObject;
    
    if (!retval) {
        retval = [NSEntityDescription insertNewObjectForEntityForName:[TwitterKitUser entityName] inManagedObjectContext:context];
        
        [retval setIdentity:identity];
        [retval setProfileImageUrl:dict[@"profile_image_url_https"]];
        [retval setName:dict[@"name"]];
        [retval setScreenName:dict[@"screen_name"]];
        
        MELog(@"created entity %@ with dict %@",retval.entity.name,dict);
    }
    
    return retval;
}

@end
