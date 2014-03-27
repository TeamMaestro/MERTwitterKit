// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MERTweet.h instead.

#import <CoreData/CoreData.h>


extern const struct MERTweetAttributes {
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *text;
} MERTweetAttributes;

extern const struct MERTweetRelationships {
} MERTweetRelationships;

extern const struct MERTweetFetchedProperties {
} MERTweetFetchedProperties;





@interface MERTweetID : NSManagedObjectID {}
@end

@interface _MERTweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MERTweetID*)objectID;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;






@end

@interface _MERTweet (CoreDataGeneratedAccessors)

@end

@interface _MERTweet (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




@end
