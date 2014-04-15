// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMediaRange.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitMediaRangeAttributes {
	__unsafe_unretained NSString *range;
} TwitterKitMediaRangeAttributes;

extern const struct TwitterKitMediaRangeRelationships {
	__unsafe_unretained NSString *media;
	__unsafe_unretained NSString *tweet;
} TwitterKitMediaRangeRelationships;

extern const struct TwitterKitMediaRangeFetchedProperties {
} TwitterKitMediaRangeFetchedProperties;

@class TwitterKitMedia;
@class TwitterKitTweet;

@class NSValue;

@interface TwitterKitMediaRangeID : NSManagedObjectID {}
@end

@interface _TwitterKitMediaRange : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitMediaRangeID*)objectID;





@property (nonatomic, strong) NSValue* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitMedia *media;

//- (BOOL)validateMedia:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitMediaRange (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitMediaRange (CoreDataGeneratedPrimitiveAccessors)


- (NSValue*)primitiveRange;
- (void)setPrimitiveRange:(NSValue*)value;





- (TwitterKitMedia*)primitiveMedia;
- (void)setPrimitiveMedia:(TwitterKitMedia*)value;



- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;


@end
