// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitHashTag.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitHashTagAttributes {
	__unsafe_unretained NSString *endStartIndex;
	__unsafe_unretained NSString *startTextIndex;
	__unsafe_unretained NSString *text;
} TwitterKitHashTagAttributes;

extern const struct TwitterKitHashTagRelationships {
	__unsafe_unretained NSString *tweets;
} TwitterKitHashTagRelationships;

extern const struct TwitterKitHashTagFetchedProperties {
} TwitterKitHashTagFetchedProperties;

@class TwitterKitHashTag;





@interface TwitterKitHashTagID : NSManagedObjectID {}
@end

@interface _TwitterKitHashTag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitHashTagID*)objectID;





@property (nonatomic, strong) NSNumber* endStartIndex;



@property int16_t endStartIndexValue;
- (int16_t)endStartIndexValue;
- (void)setEndStartIndexValue:(int16_t)value_;

//- (BOOL)validateEndStartIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startTextIndex;



@property int16_t startTextIndexValue;
- (int16_t)startTextIndexValue;
- (void)setStartTextIndexValue:(int16_t)value_;

//- (BOOL)validateStartTextIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _TwitterKitHashTag (CoreDataGeneratedAccessors)

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(TwitterKitHashTag*)value_;
- (void)removeTweetsObject:(TwitterKitHashTag*)value_;

@end

@interface _TwitterKitHashTag (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveEndStartIndex;
- (void)setPrimitiveEndStartIndex:(NSNumber*)value;

- (int16_t)primitiveEndStartIndexValue;
- (void)setPrimitiveEndStartIndexValue:(int16_t)value_;




- (NSNumber*)primitiveStartTextIndex;
- (void)setPrimitiveStartTextIndex:(NSNumber*)value;

- (int16_t)primitiveStartTextIndexValue;
- (void)setPrimitiveStartTextIndexValue:(int16_t)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
