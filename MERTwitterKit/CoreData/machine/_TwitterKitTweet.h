// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitTweetAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *favoriteCount;
	__unsafe_unretained NSString *favorited;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *text;
} TwitterKitTweetAttributes;

extern const struct TwitterKitTweetRelationships {
	__unsafe_unretained NSString *hashTags;
	__unsafe_unretained NSString *media;
	__unsafe_unretained NSString *mentions;
	__unsafe_unretained NSString *place;
	__unsafe_unretained NSString *retweet;
	__unsafe_unretained NSString *retweets;
	__unsafe_unretained NSString *symbols;
	__unsafe_unretained NSString *urls;
	__unsafe_unretained NSString *user;
} TwitterKitTweetRelationships;

extern const struct TwitterKitTweetFetchedProperties {
} TwitterKitTweetFetchedProperties;

@class TwitterKitHashTag;
@class TwitterKitMedia;
@class TwitterKitMention;
@class TwitterKitPlace;
@class TwitterKitTweet;
@class TwitterKitTweet;
@class TwitterKitSymbol;
@class TwitterKitURL;
@class TwitterKitUser;









@interface TwitterKitTweetID : NSManagedObjectID {}
@end

@interface _TwitterKitTweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitTweetID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favoriteCount;



@property int32_t favoriteCountValue;
- (int32_t)favoriteCountValue;
- (void)setFavoriteCountValue:(int32_t)value_;

//- (BOOL)validateFavoriteCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favorited;



@property BOOL favoritedValue;
- (BOOL)favoritedValue;
- (void)setFavoritedValue:(BOOL)value_;

//- (BOOL)validateFavorited:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* identity;



@property int64_t identityValue;
- (int64_t)identityValue;
- (void)setIdentityValue:(int64_t)value_;

//- (BOOL)validateIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *hashTags;

- (NSMutableSet*)hashTagsSet;




@property (nonatomic, strong) NSSet *media;

- (NSMutableSet*)mediaSet;




@property (nonatomic, strong) NSSet *mentions;

- (NSMutableSet*)mentionsSet;




@property (nonatomic, strong) TwitterKitPlace *place;

//- (BOOL)validatePlace:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TwitterKitTweet *retweet;

//- (BOOL)validateRetweet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *retweets;

- (NSMutableSet*)retweetsSet;




@property (nonatomic, strong) NSSet *symbols;

- (NSMutableSet*)symbolsSet;




@property (nonatomic, strong) NSSet *urls;

- (NSMutableSet*)urlsSet;




@property (nonatomic, strong) TwitterKitUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _TwitterKitTweet (CoreDataGeneratedAccessors)

- (void)addHashTags:(NSSet*)value_;
- (void)removeHashTags:(NSSet*)value_;
- (void)addHashTagsObject:(TwitterKitHashTag*)value_;
- (void)removeHashTagsObject:(TwitterKitHashTag*)value_;

- (void)addMedia:(NSSet*)value_;
- (void)removeMedia:(NSSet*)value_;
- (void)addMediaObject:(TwitterKitMedia*)value_;
- (void)removeMediaObject:(TwitterKitMedia*)value_;

- (void)addMentions:(NSSet*)value_;
- (void)removeMentions:(NSSet*)value_;
- (void)addMentionsObject:(TwitterKitMention*)value_;
- (void)removeMentionsObject:(TwitterKitMention*)value_;

- (void)addRetweets:(NSSet*)value_;
- (void)removeRetweets:(NSSet*)value_;
- (void)addRetweetsObject:(TwitterKitTweet*)value_;
- (void)removeRetweetsObject:(TwitterKitTweet*)value_;

- (void)addSymbols:(NSSet*)value_;
- (void)removeSymbols:(NSSet*)value_;
- (void)addSymbolsObject:(TwitterKitSymbol*)value_;
- (void)removeSymbolsObject:(TwitterKitSymbol*)value_;

- (void)addUrls:(NSSet*)value_;
- (void)removeUrls:(NSSet*)value_;
- (void)addUrlsObject:(TwitterKitURL*)value_;
- (void)removeUrlsObject:(TwitterKitURL*)value_;

@end

@interface _TwitterKitTweet (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveFavoriteCount;
- (void)setPrimitiveFavoriteCount:(NSNumber*)value;

- (int32_t)primitiveFavoriteCountValue;
- (void)setPrimitiveFavoriteCountValue:(int32_t)value_;




- (NSNumber*)primitiveFavorited;
- (void)setPrimitiveFavorited:(NSNumber*)value;

- (BOOL)primitiveFavoritedValue;
- (void)setPrimitiveFavoritedValue:(BOOL)value_;




- (NSNumber*)primitiveIdentity;
- (void)setPrimitiveIdentity:(NSNumber*)value;

- (int64_t)primitiveIdentityValue;
- (void)setPrimitiveIdentityValue:(int64_t)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (NSMutableSet*)primitiveHashTags;
- (void)setPrimitiveHashTags:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMedia;
- (void)setPrimitiveMedia:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMentions;
- (void)setPrimitiveMentions:(NSMutableSet*)value;



- (TwitterKitPlace*)primitivePlace;
- (void)setPrimitivePlace:(TwitterKitPlace*)value;



- (TwitterKitTweet*)primitiveRetweet;
- (void)setPrimitiveRetweet:(TwitterKitTweet*)value;



- (NSMutableSet*)primitiveRetweets;
- (void)setPrimitiveRetweets:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSymbols;
- (void)setPrimitiveSymbols:(NSMutableSet*)value;



- (NSMutableSet*)primitiveUrls;
- (void)setPrimitiveUrls:(NSMutableSet*)value;



- (TwitterKitUser*)primitiveUser;
- (void)setPrimitiveUser:(TwitterKitUser*)value;


@end
