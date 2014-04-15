// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUser.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitUserAttributes {
	__unsafe_unretained NSString *followersCount;
	__unsafe_unretained NSString *friendsCount;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *profileImageUrl;
	__unsafe_unretained NSString *screenName;
} TwitterKitUserAttributes;

extern const struct TwitterKitUserRelationships {
	__unsafe_unretained NSString *mentions;
	__unsafe_unretained NSString *tweets;
} TwitterKitUserRelationships;

extern const struct TwitterKitUserFetchedProperties {
} TwitterKitUserFetchedProperties;

@class TwitterKitMention;
@class TwitterKitTweet;








@interface TwitterKitUserID : NSManagedObjectID {}
@end

@interface _TwitterKitUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitUserID*)objectID;





@property (nonatomic, strong) NSNumber* followersCount;



@property int32_t followersCountValue;
- (int32_t)followersCountValue;
- (void)setFollowersCountValue:(int32_t)value_;

//- (BOOL)validateFollowersCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* friendsCount;



@property int32_t friendsCountValue;
- (int32_t)friendsCountValue;
- (void)setFriendsCountValue:(int32_t)value_;

//- (BOOL)validateFriendsCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileImageUrl;



//- (BOOL)validateProfileImageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* screenName;



//- (BOOL)validateScreenName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *mentions;

- (NSMutableSet*)mentionsSet;




@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _TwitterKitUser (CoreDataGeneratedAccessors)

- (void)addMentions:(NSSet*)value_;
- (void)removeMentions:(NSSet*)value_;
- (void)addMentionsObject:(TwitterKitMention*)value_;
- (void)removeMentionsObject:(TwitterKitMention*)value_;

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(TwitterKitTweet*)value_;
- (void)removeTweetsObject:(TwitterKitTweet*)value_;

@end

@interface _TwitterKitUser (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveFollowersCount;
- (void)setPrimitiveFollowersCount:(NSNumber*)value;

- (int32_t)primitiveFollowersCountValue;
- (void)setPrimitiveFollowersCountValue:(int32_t)value_;




- (NSNumber*)primitiveFriendsCount;
- (void)setPrimitiveFriendsCount:(NSNumber*)value;

- (int32_t)primitiveFriendsCountValue;
- (void)setPrimitiveFriendsCountValue:(int32_t)value_;




- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveProfileImageUrl;
- (void)setPrimitiveProfileImageUrl:(NSString*)value;




- (NSString*)primitiveScreenName;
- (void)setPrimitiveScreenName:(NSString*)value;





- (NSMutableSet*)primitiveMentions;
- (void)setPrimitiveMentions:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
