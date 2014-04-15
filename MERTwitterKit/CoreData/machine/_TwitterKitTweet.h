// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterKitTweetAttributes {
	__unsafe_unretained NSString *coordinates;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *favoriteCount;
	__unsafe_unretained NSString *favorited;
	__unsafe_unretained NSString *identity;
	__unsafe_unretained NSString *replyIdentity;
	__unsafe_unretained NSString *retweetCount;
	__unsafe_unretained NSString *retweeted;
	__unsafe_unretained NSString *text;
} TwitterKitTweetAttributes;

extern const struct TwitterKitTweetRelationships {
	__unsafe_unretained NSString *hashtags;
	__unsafe_unretained NSString *mediaRanges;
	__unsafe_unretained NSString *mentions;
	__unsafe_unretained NSString *place;
	__unsafe_unretained NSString *replies;
	__unsafe_unretained NSString *reply;
	__unsafe_unretained NSString *retweet;
	__unsafe_unretained NSString *retweets;
	__unsafe_unretained NSString *symbols;
	__unsafe_unretained NSString *urls;
	__unsafe_unretained NSString *user;
} TwitterKitTweetRelationships;

extern const struct TwitterKitTweetFetchedProperties {
} TwitterKitTweetFetchedProperties;

@class TwitterKitHashtag;
@class TwitterKitMediaRange;
@class TwitterKitMention;
@class TwitterKitPlace;
@class TwitterKitTweet;
@class TwitterKitTweet;
@class TwitterKitTweet;
@class TwitterKitTweet;
@class TwitterKitSymbol;
@class TwitterKitUrl;
@class TwitterKitUser;

@class NSValue;









@interface TwitterKitTweetID : NSManagedObjectID {}
@end

@interface _TwitterKitTweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterKitTweetID*)objectID;





@property (nonatomic, strong) NSValue* coordinates;



//- (BOOL)validateCoordinates:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSNumber* replyIdentity;



@property int64_t replyIdentityValue;
- (int64_t)replyIdentityValue;
- (void)setReplyIdentityValue:(int64_t)value_;

//- (BOOL)validateReplyIdentity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* retweetCount;



@property int32_t retweetCountValue;
- (int32_t)retweetCountValue;
- (void)setRetweetCountValue:(int32_t)value_;

//- (BOOL)validateRetweetCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* retweeted;



@property BOOL retweetedValue;
- (BOOL)retweetedValue;
- (void)setRetweetedValue:(BOOL)value_;

//- (BOOL)validateRetweeted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *hashtags;

- (NSMutableSet*)hashtagsSet;




@property (nonatomic, strong) NSSet *mediaRanges;

- (NSMutableSet*)mediaRangesSet;




@property (nonatomic, strong) NSSet *mentions;

- (NSMutableSet*)mentionsSet;




@property (nonatomic, strong) TwitterKitPlace *place;

//- (BOOL)validatePlace:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *replies;

- (NSMutableSet*)repliesSet;




@property (nonatomic, strong) TwitterKitTweet *reply;

//- (BOOL)validateReply:(id*)value_ error:(NSError**)error_;




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

- (void)addHashtags:(NSSet*)value_;
- (void)removeHashtags:(NSSet*)value_;
- (void)addHashtagsObject:(TwitterKitHashtag*)value_;
- (void)removeHashtagsObject:(TwitterKitHashtag*)value_;

- (void)addMediaRanges:(NSSet*)value_;
- (void)removeMediaRanges:(NSSet*)value_;
- (void)addMediaRangesObject:(TwitterKitMediaRange*)value_;
- (void)removeMediaRangesObject:(TwitterKitMediaRange*)value_;

- (void)addMentions:(NSSet*)value_;
- (void)removeMentions:(NSSet*)value_;
- (void)addMentionsObject:(TwitterKitMention*)value_;
- (void)removeMentionsObject:(TwitterKitMention*)value_;

- (void)addReplies:(NSSet*)value_;
- (void)removeReplies:(NSSet*)value_;
- (void)addRepliesObject:(TwitterKitTweet*)value_;
- (void)removeRepliesObject:(TwitterKitTweet*)value_;

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
- (void)addUrlsObject:(TwitterKitUrl*)value_;
- (void)removeUrlsObject:(TwitterKitUrl*)value_;

@end

@interface _TwitterKitTweet (CoreDataGeneratedPrimitiveAccessors)


- (NSValue*)primitiveCoordinates;
- (void)setPrimitiveCoordinates:(NSValue*)value;




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




- (NSNumber*)primitiveReplyIdentity;
- (void)setPrimitiveReplyIdentity:(NSNumber*)value;

- (int64_t)primitiveReplyIdentityValue;
- (void)setPrimitiveReplyIdentityValue:(int64_t)value_;




- (NSNumber*)primitiveRetweetCount;
- (void)setPrimitiveRetweetCount:(NSNumber*)value;

- (int32_t)primitiveRetweetCountValue;
- (void)setPrimitiveRetweetCountValue:(int32_t)value_;




- (NSNumber*)primitiveRetweeted;
- (void)setPrimitiveRetweeted:(NSNumber*)value;

- (BOOL)primitiveRetweetedValue;
- (void)setPrimitiveRetweetedValue:(BOOL)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (NSMutableSet*)primitiveHashtags;
- (void)setPrimitiveHashtags:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMediaRanges;
- (void)setPrimitiveMediaRanges:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMentions;
- (void)setPrimitiveMentions:(NSMutableSet*)value;



- (TwitterKitPlace*)primitivePlace;
- (void)setPrimitivePlace:(TwitterKitPlace*)value;



- (NSMutableSet*)primitiveReplies;
- (void)setPrimitiveReplies:(NSMutableSet*)value;



- (TwitterKitTweet*)primitiveReply;
- (void)setPrimitiveReply:(TwitterKitTweet*)value;



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
