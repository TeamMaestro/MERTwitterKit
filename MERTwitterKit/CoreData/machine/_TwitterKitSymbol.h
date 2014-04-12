// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitSymbol.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitSymbolAttributes {
	__unsafe_unretained NSString *range;
	__unsafe_unretained NSString *text;
} TwitterKitSymbolAttributes;

extern const struct TwitterKitSymbolRelationships {
	__unsafe_unretained NSString *tweet;
} TwitterKitSymbolRelationships;

extern const struct TwitterKitSymbolFetchedProperties {
} TwitterKitSymbolFetchedProperties;

@class TwitterKitTweet;

@class NSValue;


@interface TwitterKitSymbolID : NSManagedObjectID {}
@end

@interface _TwitterKitSymbol : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitSymbolID*)objectID;





@property (nonatomic, strong) NSValue* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitSymbol (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitSymbol (CoreDataGeneratedPrimitiveAccessors)


- (NSValue*)primitiveRange;
- (void)setPrimitiveRange:(NSValue*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;


@end
