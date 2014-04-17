//
//  MERTwitterClient+PlacesAndGeo.h
//  MERTwitterKit
//
//  Created by William Towe on 4/15/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "MERTwitterClient.h"

/**
 Enum describing the granularity of a geo request.
 
 - `MERTwitterClientGeoGranularityNone`, use the default granularity, which is `MERTwitterClientGeoGranularityDefault`
 - `MERTwitterClientGeoGranularityPOI`, point of interest (e.g. Sbarro)
 - `MERTwitterClientGeoGranularityNeighborhood`, neighborhood (e.g. Theater District)
 - `MERTwitterClientGeoGranularityCity`, city (e.g. Kalamazoo)
 - `MERTwitterClientGeoGranularityAdmin`, administrative area, (e.g. Michigan)
 - `MERTwitterClientGeoGranularityCountry`, country (e.g. France)
 */
typedef NS_ENUM(NSInteger, MERTwitterClientGeoGranularity) {
    MERTwitterClientGeoGranularityNone,
    MERTwitterClientGeoGranularityPOI,
    MERTwitterClientGeoGranularityNeighborhood,
    MERTwitterClientGeoGranularityCity,
    MERTwitterClientGeoGranularityAdmin,
    MERTwitterClientGeoGranularityCountry,
    MERTwitterClientGeoGranularityDefault = MERTwitterClientGeoGranularityNeighborhood
};

/**
 Methods to interact with the _geo_ resource family of the Twitter API.
 */
@interface MERTwitterClient (PlacesAndGeo)

/**
 Returns a signal that sends `next` with a `MERTwitterPlaceViewModel` instance, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/geo/id/%3Aplace_id
 
 @param identity The identity of the place to request
 @return The signal
 @exception NSException Thrown if _identity_ is <= 0
 */
- (RACSignal *)requestPlaceWithIdentity:(NSString *)identity;
/**
 Returns a signal that sends `next` with an array of `MERTwitterPlaceViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/geo/reverse_geocode
 
 @param location The location (latitude/longitude) to search from
 @param accuracy The radius in meters from which to search outwards from _location_
 @param granularity The granularity of the returned results. The default is `MERTwitterClientGeoGranularityDefault`
 @param count The maximum number of places the request should return. The default is 0, which means no limit
 @return The signal
 @exception NSException Thrown if _location_ is invalid, as determined by `CLLocationCoordinate2DIsValid(location)`
 */
- (RACSignal *)requestPlacesWithLocation:(CLLocationCoordinate2D)location accuracy:(CLLocationDistance)accuracy granularity:(MERTwitterClientGeoGranularity)granularity count:(NSUInteger)count;
/**
 Returns a signal that sends `next` with an array of `MERTwitterPlaceViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide _latitude_, _longitude_, _ipAddress_, or _query_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/geo/search
 
 @param latitude The latitude to search from
 @param longitude The longitude to search from
 @param ipAddress The ip address to search from
 @param query The query to search from. This is generally used to match a place by name
 @param placeIdentity The identity of the place by which to constrain the results. If non-nil, the results will all be contained within the place with the provided identity
 @param accuracy The radius in meters from which to search outwards from the provided search parameter
 @param granularity The granularity of the returned results. The default is `MERTwitterClientGeoGranularityDefault`
 @param count The maximum number of places the request should return. The default is 0, which means no limit
 @return The signal
 @exception NSException Thrown if _latitude_ is 0, _longitude_ is 0, _ipAddress_, and _query_ are nil
 */
- (RACSignal *)requestPlacesMatchingLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude ipAddress:(NSString *)ipAddress query:(NSString *)query containedWithinPlaceWithIdentity:(NSString *)placeIdentity accuracy:(CLLocationDistance)accuracy granularity:(MERTwitterClientGeoGranularity)granularity count:(NSUInteger)count;
/**
 Returns a signal that sends `next` with an array of `MERTwitterPlaceViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide _name_ and _location_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/geo/similar_places
 
 @param name The name of the place for which to find similar places
 @param location The location from which to search
 @param placeIdentity The identity of the place by which to constrain the results. If non-nil, the results will all be contained within the place with the provided identity
 @return The signal
 @exception NSException Thrown if _name_ is nil or _location_ is invalid, as determined by `CLLocationCoordinate2DIsValid(location)`
 */
- (RACSignal *)requestPlacesSimilarToPlaceWithName:(NSString *)name location:(CLLocationCoordinate2D)location containedWithinPlaceWithIdentity:(NSString *)placeIdentity;

@end
