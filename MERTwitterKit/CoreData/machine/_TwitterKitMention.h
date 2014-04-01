// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMention.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitMentionAttributes {
	__unsafe_unretained NSString *endTextIndex;
	__unsafe_unretained NSString *startTextIndex;
} TwitterKitMentionAttributes;

extern const struct TwitterKitMentionRelationships {
	__unsafe_unretained NSString *tweet;
	__unsafe_unretained NSString *user;
} TwitterKitMentionRelationships;

extern const struct TwitterKitMentionFetchedProperties {
} TwitterKitMentionFetchedProperties;

@class TwitterKitTweet;
@class TwitterKitUser;




@interface TwitterKitMentionID : NSManagedObjectID {}
@end

@interface _TwitterKitMention : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitMentionID*)objectID;





@property (nonatomic, strong) NSNumber* endTextIndex;



@property int16_t endTextIndexValue;
- (int16_t)endTextIndexValue;
- (void)setEndTextIndexValue:(int16_t)value_;

//- (BOOL)validateEndTextIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startTextIndex;



@property int16_t startTextIndexValue;
- (int16_t)startTextIndexValue;
- (void)setStartTextIndexValue:(int16_t)value_;

//- (BOOL)validateStartTextIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TwitterKitUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitMention (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitMention (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveEndTextIndex;
- (void)setPrimitiveEndTextIndex:(NSNumber*)value;

- (int16_t)primitiveEndTextIndexValue;
- (void)setPrimitiveEndTextIndexValue:(int16_t)value_;




- (NSNumber*)primitiveStartTextIndex;
- (void)setPrimitiveStartTextIndex:(NSNumber*)value;

- (int16_t)primitiveStartTextIndexValue;
- (void)setPrimitiveStartTextIndexValue:(int16_t)value_;





- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;



- (TwitterKitUser*)primitiveUser;
- (void)setPrimitiveUser:(TwitterKitUser*)value;


@end
