// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitHashtag.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitHashtagAttributes {
	__unsafe_unretained NSString *endTextIndex;
	__unsafe_unretained NSString *startTextIndex;
	__unsafe_unretained NSString *text;
} TwitterKitHashtagAttributes;

extern const struct TwitterKitHashtagRelationships {
	__unsafe_unretained NSString *tweet;
} TwitterKitHashtagRelationships;

extern const struct TwitterKitHashtagFetchedProperties {
} TwitterKitHashtagFetchedProperties;

@class TwitterKitHashtag;





@interface TwitterKitHashtagID : NSManagedObjectID {}
@end

@interface _TwitterKitHashtag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitHashtagID*)objectID;





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





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitHashtag *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitHashtag (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitHashtag (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveEndTextIndex;
- (void)setPrimitiveEndTextIndex:(NSNumber*)value;

- (int16_t)primitiveEndTextIndexValue;
- (void)setPrimitiveEndTextIndexValue:(int16_t)value_;




- (NSNumber*)primitiveStartTextIndex;
- (void)setPrimitiveStartTextIndex:(NSNumber*)value;

- (int16_t)primitiveStartTextIndexValue;
- (void)setPrimitiveStartTextIndexValue:(int16_t)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (TwitterKitHashtag*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitHashtag*)value;


@end
