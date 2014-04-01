// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitTweetAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *text;
} TwitterKitTweetAttributes;

extern const struct TwitterKitTweetRelationships {
	__unsafe_unretained NSString *user;
} TwitterKitTweetRelationships;

extern const struct TwitterKitTweetFetchedProperties {
} TwitterKitTweetFetchedProperties;

@class TwitterKitUser;





@interface TwitterKitTweetID : NSManagedObjectID {}
@end

@interface _TwitterKitTweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitTweetID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitTweet (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitTweet (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (TwitterKitUser*)primitiveUser;
- (void)setPrimitiveUser:(TwitterKitUser*)value;


@end
