// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitPlace.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitPlaceAttributes {
	__unsafe_unretained NSString *boundingBox;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *countryCode;
	__unsafe_unretained NSString *fullName;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *type;
} TwitterKitPlaceAttributes;

extern const struct TwitterKitPlaceRelationships {
	__unsafe_unretained NSString *containedWithin;
	__unsafe_unretained NSString *contains;
	__unsafe_unretained NSString *tweet;
} TwitterKitPlaceRelationships;

extern const struct TwitterKitPlaceFetchedProperties {
} TwitterKitPlaceFetchedProperties;

@class TwitterKitPlace;
@class TwitterKitPlace;
@class TwitterKitTweet;

@class NSArray;







@interface TwitterKitPlaceID : NSManagedObjectID {}
@end

@interface _TwitterKitPlace : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitPlaceID*)objectID;





@property (nonatomic, strong) NSArray* boundingBox;



//- (BOOL)validateBoundingBox:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* countryCode;



//- (BOOL)validateCountryCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fullName;



//- (BOOL)validateFullName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* identity;



//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *containedWithin;

- (NSMutableSet*)containedWithinSet;




@property (nonatomic, strong) NSSet *contains;

- (NSMutableSet*)containsSet;




@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitPlace (CoreDataGeneratedAccessors)

- (void)addContainedWithin:(NSSet*)value_;
- (void)removeContainedWithin:(NSSet*)value_;
- (void)addContainedWithinObject:(TwitterKitPlace*)value_;
- (void)removeContainedWithinObject:(TwitterKitPlace*)value_;

- (void)addContains:(NSSet*)value_;
- (void)removeContains:(NSSet*)value_;
- (void)addContainsObject:(TwitterKitPlace*)value_;
- (void)removeContainsObject:(TwitterKitPlace*)value_;

@end

@interface _TwitterKitPlace (CoreDataGeneratedPrimitiveAccessors)


- (NSArray*)primitiveBoundingBox;
- (void)setPrimitiveBoundingBox:(NSArray*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveCountryCode;
- (void)setPrimitiveCountryCode:(NSString*)value;




- (NSString*)primitiveFullName;
- (void)setPrimitiveFullName:(NSString*)value;




- (NSString*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (NSMutableSet*)primitiveContainedWithin;
- (void)setPrimitiveContainedWithin:(NSMutableSet*)value;



- (NSMutableSet*)primitiveContains;
- (void)setPrimitiveContains:(NSMutableSet*)value;



- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;


@end
