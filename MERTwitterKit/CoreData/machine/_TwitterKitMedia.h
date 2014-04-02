// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitMedia.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitMediaAttributes {
	__unsafe_unretained NSString *displayUrl;
	__unsafe_unretained NSString *endTextIndex;
	__unsafe_unretained NSString *expandedUrl;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *mediaUrl;
	__unsafe_unretained NSString *startTextIndex;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *url;
} TwitterKitMediaAttributes;

extern const struct TwitterKitMediaRelationships {
	__unsafe_unretained NSString *sizes;
	__unsafe_unretained NSString *tweet;
} TwitterKitMediaRelationships;

extern const struct TwitterKitMediaFetchedProperties {
} TwitterKitMediaFetchedProperties;

@class TwitterKitMediaSize;
@class TwitterKitTweet;










@interface TwitterKitMediaID : NSManagedObjectID {}
@end

@interface _TwitterKitMedia : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitMediaID*)objectID;





@property (nonatomic, strong) NSString* displayUrl;



//- (BOOL)validateDisplayUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* endTextIndex;



@property int16_t endTextIndexValue;
- (int16_t)endTextIndexValue;
- (void)setEndTextIndexValue:(int16_t)value_;

//- (BOOL)validateEndTextIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* expandedUrl;



//- (BOOL)validateExpandedUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mediaUrl;



//- (BOOL)validateMediaUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startTextIndex;



@property int16_t startTextIndexValue;
- (int16_t)startTextIndexValue;
- (void)setStartTextIndexValue:(int16_t)value_;

//- (BOOL)validateStartTextIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *sizes;

- (NSMutableSet*)sizesSet;




@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitMedia (CoreDataGeneratedAccessors)

- (void)addSizes:(NSSet*)value_;
- (void)removeSizes:(NSSet*)value_;
- (void)addSizesObject:(TwitterKitMediaSize*)value_;
- (void)removeSizesObject:(TwitterKitMediaSize*)value_;

@end

@interface _TwitterKitMedia (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayUrl;
- (void)setPrimitiveDisplayUrl:(NSString*)value;




- (NSNumber*)primitiveEndTextIndex;
- (void)setPrimitiveEndTextIndex:(NSNumber*)value;

- (int16_t)primitiveEndTextIndexValue;
- (void)setPrimitiveEndTextIndexValue:(int16_t)value_;




- (NSString*)primitiveExpandedUrl;
- (void)setPrimitiveExpandedUrl:(NSString*)value;




- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSString*)primitiveMediaUrl;
- (void)setPrimitiveMediaUrl:(NSString*)value;




- (NSNumber*)primitiveStartTextIndex;
- (void)setPrimitiveStartTextIndex:(NSNumber*)value;

- (int16_t)primitiveStartTextIndexValue;
- (void)setPrimitiveStartTextIndexValue:(int16_t)value_;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (NSMutableSet*)primitiveSizes;
- (void)setPrimitiveSizes:(NSMutableSet*)value;



- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;


@end
