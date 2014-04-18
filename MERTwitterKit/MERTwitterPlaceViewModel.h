//
//  MERTwitterPlaceViewModel.h
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

#import "RVMViewModel.h"

extern const struct MERTwitterPlaceViewModelType {
    __unsafe_unretained NSString *personOfInterest;
    __unsafe_unretained NSString *neighborhood;
    __unsafe_unretained NSString *city;
    __unsafe_unretained NSString *administrativeArea;
    __unsafe_unretained NSString *country;
} MERTwitterPlaceViewModelType;

/**
 `MERTwitterPlaceViewModel` is a `RVMViewModel` subclass representing a Place by the Twitter API.
 
 More information can be found at https://dev.twitter.com/docs/platform-objects/places
 */
@interface MERTwitterPlaceViewModel : RVMViewModel

/**
 The identity of the Place. This is unique.
 
 The `id` of the Place JSON object.
 */
@property (readonly,nonatomic) NSString *identity;

/**
 The type of location represented by the Place.
 
 The `place_type` of the Place JSON object.
 
 @see MERTwitterPlaceViewModelType
 */
@property (readonly,nonatomic) NSString *type;
/**
 The name of the country containing the Place.
 
 The `country` of the Place JSON object.
 */
@property (readonly,nonatomic) NSString *country;
/**
 The country code of the country containing the Place.
 
 The `country_code` of the Place JSON object.
 */
@property (readonly,nonatomic) NSString *countryCode;
/**
 The name of the Place.
 
 The `name` of the Place JSON object.
 */
@property (readonly,nonatomic) NSString *name;
/**
 The full name of the Place.
 
 The `full_name` of the Place JSON object.
 */
@property (readonly,nonatomic) NSString *fullName;

@end
