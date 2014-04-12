// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitHashtag.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitHashtagAttributes {
	__unsafe_unretained NSString *range;
	__unsafe_unretained NSString *text;
} TwitterKitHashtagAttributes;

extern const struct TwitterKitHashtagRelationships {
	__unsafe_unretained NSString *tweet;
} TwitterKitHashtagRelationships;

extern const struct TwitterKitHashtagFetchedProperties {
} TwitterKitHashtagFetchedProperties;

@class TwitterKitHashtag;

@class NSValue;


@interface TwitterKitHashtagID : NSManagedObjectID {}
@end

@interface _TwitterKitHashtag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitHashtagID*)objectID;





@property (nonatomic, strong) NSValue* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitHashtag *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitHashtag (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitHashtag (CoreDataGeneratedPrimitiveAccessors)


- (NSValue*)primitiveRange;
- (void)setPrimitiveRange:(NSValue*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (TwitterKitHashtag*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitHashtag*)value;


@end
