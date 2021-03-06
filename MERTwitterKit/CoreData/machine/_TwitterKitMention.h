// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMention.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitMentionAttributes {
	__unsafe_unretained NSString *range;
} TwitterKitMentionAttributes;

extern const struct TwitterKitMentionRelationships {
	__unsafe_unretained NSString *tweet;
	__unsafe_unretained NSString *user;
} TwitterKitMentionRelationships;

extern const struct TwitterKitMentionFetchedProperties {
} TwitterKitMentionFetchedProperties;

@class TwitterKitTweet;
@class TwitterKitUser;

@class NSValue;

@interface TwitterKitMentionID : NSManagedObjectID {}
@end

@interface _TwitterKitMention : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitMentionID*)objectID;





@property (nonatomic, strong) NSValue* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TwitterKitUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitMention (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitMention (CoreDataGeneratedPrimitiveAccessors)


- (NSValue*)primitiveRange;
- (void)setPrimitiveRange:(NSValue*)value;





- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;



- (TwitterKitUser*)primitiveUser;
- (void)setPrimitiveUser:(TwitterKitUser*)value;


@end
