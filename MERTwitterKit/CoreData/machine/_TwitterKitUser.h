// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUser.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitUserAttributes {
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *profileImageUrl;
} TwitterKitUserAttributes;

extern const struct TwitterKitUserRelationships {
	__unsafe_unretained NSString *tweets;
} TwitterKitUserRelationships;

extern const struct TwitterKitUserFetchedProperties {
} TwitterKitUserFetchedProperties;

@class TwitterKitTweet;




@interface TwitterKitUserID : NSManagedObjectID {}
@end

@interface _TwitterKitUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitUserID*)objectID;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileImageUrl;



//- (BOOL)validateProfileImageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _TwitterKitUser (CoreDataGeneratedAccessors)

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(TwitterKitTweet*)value_;
- (void)removeTweetsObject:(TwitterKitTweet*)value_;

@end

@interface _TwitterKitUser (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSString*)primitiveProfileImageUrl;
- (void)setPrimitiveProfileImageUrl:(NSString*)value;





- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
