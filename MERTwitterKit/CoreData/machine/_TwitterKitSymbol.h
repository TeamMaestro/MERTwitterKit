// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitSymbol.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitSymbolAttributes {
	__unsafe_unretained NSString *endTextIndex;
	__unsafe_unretained NSString *startTextIndex;
	__unsafe_unretained NSString *text;
} TwitterKitSymbolAttributes;

extern const struct TwitterKitSymbolRelationships {
	__unsafe_unretained NSString *tweets;
} TwitterKitSymbolRelationships;

extern const struct TwitterKitSymbolFetchedProperties {
} TwitterKitSymbolFetchedProperties;

@class TwitterKitTweet;





@interface TwitterKitSymbolID : NSManagedObjectID {}
@end

@interface _TwitterKitSymbol : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitSymbolID*)objectID;





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





@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _TwitterKitSymbol (CoreDataGeneratedAccessors)

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(TwitterKitTweet*)value_;
- (void)removeTweetsObject:(TwitterKitTweet*)value_;

@end

@interface _TwitterKitSymbol (CoreDataGeneratedPrimitiveAccessors)


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





- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
