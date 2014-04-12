// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitUrl.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitUrlAttributes {
	__unsafe_unretained NSString *displayUrl;
	__unsafe_unretained NSString *expandedUrl;
	__unsafe_unretained NSString *range;
	__unsafe_unretained NSString *url;
} TwitterKitUrlAttributes;

extern const struct TwitterKitUrlRelationships {
	__unsafe_unretained NSString *tweet;
} TwitterKitUrlRelationships;

extern const struct TwitterKitUrlFetchedProperties {
} TwitterKitUrlFetchedProperties;

@class TwitterKitTweet;



@class NSValue;


@interface TwitterKitUrlID : NSManagedObjectID {}
@end

@interface _TwitterKitUrl : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitUrlID*)objectID;





@property (nonatomic, strong) NSString* displayUrl;



//- (BOOL)validateDisplayUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* expandedUrl;



//- (BOOL)validateExpandedUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSValue* range;



//- (BOOL)validateRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterKitTweet *tweet;

//- (BOOL)validateTweet:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitUrl (CoreDataGeneratedAccessors)

@end

@interface _TwitterKitUrl (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDisplayUrl;
- (void)setPrimitiveDisplayUrl:(NSString*)value;




- (NSString*)primitiveExpandedUrl;
- (void)setPrimitiveExpandedUrl:(NSString*)value;




- (NSValue*)primitiveRange;
- (void)setPrimitiveRange:(NSValue*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (TwitterKitTweet*)primitiveTweet;
- (void)setPrimitiveTweet:(TwitterKitTweet*)value;


@end
