// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterKitTweet.m instead.

#import "_TwitterKitTweet.h"

const struct TwitterKitTweetAttributes TwitterKitTweetAttributes = {
	.createdAt = @"createdAt",
	.favoriteCount = @"favoriteCount",
	.favorited = @"favorited",
	.identity = @"identity",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.text = @"text",
};

const struct TwitterKitTweetRelationships TwitterKitTweetRelationships = {
	.hashTags = @"hashTags",
	.media = @"media",
	.mentions = @"mentions",
	.place = @"place",
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
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




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





@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic text;






@dynamic hashTags;

	
- (NSMutableSet*)hashTagsSet {
	[self willAccessValueForKey:@"hashTags"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"hashTags"];
  
	[self didAccessValueForKey:@"hashTags"];
	return result;
}
	

@dynamic media;

	
- (NSMutableSet*)mediaSet {
	[self willAccessValueForKey:@"media"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"media"];
  
	[self didAccessValueForKey:@"media"];
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
