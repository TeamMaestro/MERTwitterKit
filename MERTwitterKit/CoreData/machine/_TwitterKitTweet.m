// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.m instead.

#import "_TwitterKitTweet.h"

const struct TwitterKitTweetAttributes TwitterKitTweetAttributes = {
	.coordinates = @"coordinates",
	.createdAt = @"createdAt",
	.favoriteCount = @"favoriteCount",
	.favorited = @"favorited",
	.identity = @"identity",
	.replyIdentity = @"replyIdentity",
	.retweetCount = @"retweetCount",
	.retweeted = @"retweeted",
	.text = @"text",
};

const struct TwitterKitTweetRelationships TwitterKitTweetRelationships = {
	.hashtags = @"hashtags",
	.mediaRanges = @"mediaRanges",
	.mentions = @"mentions",
	.place = @"place",
	.replied = @"replied",
	.replies = @"replies",
	.retweet = @"retweet",
	.retweets = @"retweets",
	.symbols = @"symbols",
	.urls = @"urls",
	.user = @"user",
};

const struct TwitterKitTweetFetchedProperties TwitterKitTweetFetchedProperties = {
};

@implementation TwitterKitTweetID
@end

@implementation _TwitterKitTweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterKitTweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterKitTweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterKitTweet" inManagedObjectContext:moc_];
}

- (TwitterKitTweetID*)objectID {
	return (TwitterKitTweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"favoriteCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favoriteCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"favoritedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorited"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"replyIdentityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"replyIdentity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"retweetCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"retweetCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"retweetedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"retweeted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic coordinates;






@dynamic createdAt;






@dynamic favoriteCount;



- (int32_t)favoriteCountValue {
	NSNumber *result = [self favoriteCount];
	return [result intValue];
}

- (void)setFavoriteCountValue:(int32_t)value_ {
	[self setFavoriteCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFavoriteCountValue {
	NSNumber *result = [self primitiveFavoriteCount];
	return [result intValue];
}

- (void)setPrimitiveFavoriteCountValue:(int32_t)value_ {
	[self setPrimitiveFavoriteCount:[NSNumber numberWithInt:value_]];
}





@dynamic favorited;



- (BOOL)favoritedValue {
	NSNumber *result = [self favorited];
	return [result boolValue];
}

- (void)setFavoritedValue:(BOOL)value_ {
	[self setFavorited:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoritedValue {
	NSNumber *result = [self primitiveFavorited];
	return [result boolValue];
}

- (void)setPrimitiveFavoritedValue:(BOOL)value_ {
	[self setPrimitiveFavorited:[NSNumber numberWithBool:value_]];
}





@dynamic identity;



- (int64_t)identityValue {
	NSNumber *result = [self identity];
	return [result longLongValue];
}

- (void)setIdentityValue:(int64_t)value_ {
	[self setIdentity:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdentityValue {
	NSNumber *result = [self primitiveIdentity];
	return [result longLongValue];
}

- (void)setPrimitiveIdentityValue:(int64_t)value_ {
	[self setPrimitiveIdentity:[NSNumber numberWithLongLong:value_]];
}





@dynamic replyIdentity;



- (int64_t)replyIdentityValue {
	NSNumber *result = [self replyIdentity];
	return [result longLongValue];
}

- (void)setReplyIdentityValue:(int64_t)value_ {
	[self setReplyIdentity:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveReplyIdentityValue {
	NSNumber *result = [self primitiveReplyIdentity];
	return [result longLongValue];
}

- (void)setPrimitiveReplyIdentityValue:(int64_t)value_ {
	[self setPrimitiveReplyIdentity:[NSNumber numberWithLongLong:value_]];
}





@dynamic retweetCount;



- (int32_t)retweetCountValue {
	NSNumber *result = [self retweetCount];
	return [result intValue];
}

- (void)setRetweetCountValue:(int32_t)value_ {
	[self setRetweetCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRetweetCountValue {
	NSNumber *result = [self primitiveRetweetCount];
	return [result intValue];
}

- (void)setPrimitiveRetweetCountValue:(int32_t)value_ {
	[self setPrimitiveRetweetCount:[NSNumber numberWithInt:value_]];
}





@dynamic retweeted;



- (BOOL)retweetedValue {
	NSNumber *result = [self retweeted];
	return [result boolValue];
}

- (void)setRetweetedValue:(BOOL)value_ {
	[self setRetweeted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRetweetedValue {
	NSNumber *result = [self primitiveRetweeted];
	return [result boolValue];
}

- (void)setPrimitiveRetweetedValue:(BOOL)value_ {
	[self setPrimitiveRetweeted:[NSNumber numberWithBool:value_]];
}





@dynamic text;






@dynamic hashtags;

	
- (NSMutableSet*)hashtagsSet {
	[self willAccessValueForKey:@"hashtags"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"hashtags"];
  
	[self didAccessValueForKey:@"hashtags"];
	return result;
}
	

@dynamic mediaRanges;

	
- (NSMutableSet*)mediaRangesSet {
	[self willAccessValueForKey:@"mediaRanges"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mediaRanges"];
  
	[self didAccessValueForKey:@"mediaRanges"];
	return result;
}
	

@dynamic mentions;

	
- (NSMutableSet*)mentionsSet {
	[self willAccessValueForKey:@"mentions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mentions"];
  
	[self didAccessValueForKey:@"mentions"];
	return result;
}
	

@dynamic place;

	

@dynamic replied;

	

@dynamic replies;

	
- (NSMutableSet*)repliesSet {
	[self willAccessValueForKey:@"replies"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"replies"];
  
	[self didAccessValueForKey:@"replies"];
	return result;
}
	

@dynamic retweet;

	

@dynamic retweets;

	
- (NSMutableSet*)retweetsSet {
	[self willAccessValueForKey:@"retweets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"retweets"];
  
	[self didAccessValueForKey:@"retweets"];
	return result;
}
	

@dynamic symbols;

	
- (NSMutableSet*)symbolsSet {
	[self willAccessValueForKey:@"symbols"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"symbols"];
  
	[self didAccessValueForKey:@"symbols"];
	return result;
}
	

@dynamic urls;

	
- (NSMutableSet*)urlsSet {
	[self willAccessValueForKey:@"urls"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"urls"];
  
	[self didAccessValueForKey:@"urls"];
	return result;
}
	

@dynamic user;

	






@end
