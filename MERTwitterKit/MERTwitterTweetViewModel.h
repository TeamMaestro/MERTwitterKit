//
//  MERTwitterTweetViewModel.h
//  MERTwitterKit
//
//  Created by William Towe on 3/27/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RVMViewModel.h"
#import <UIKit/UIImage.h>

@class MERTwitterUserViewModel;

/**
 `MERTwitterTweetViewModel` is a `RVMViewModel` subclass that represents a Tweet returned by the Twitter API.
 
 More information can be found at https://dev.twitter.com/docs/platform-objects/tweets
 */
@interface MERTwitterTweetViewModel : RVMViewModel

/**
 The identity of the Tweet. This is unique.
 
 The `id` of the Tweet JSON object.
 */
@property (readonly,nonatomic) int64_t identity;

/**
 The UTF-8 text of the Tweet.
 
 The `text` of the Tweet JSON object.
 */
@property (readonly,nonatomic) NSString *text;
/**
 The set of `NSValue` instances wrapping `NSRange` structures representing the locations of hashtags within the receiver's `text` property.
 
 The `entities.hashtags` of the Tweet JSON object.
 
 More information can be found at https://dev.twitter.com/docs/entities#tweets
 */
@property (readonly,nonatomic) NSSet *hashtagRanges;
/**
 The set of `NSValue` instances wrapping `NSRange` structures representing the locations of media within the receiver's `text` property.
 
 The `entities.media` of the Tweet JSON object.
 
 More information can be found at https://dev.twitter.com/docs/entities#tweets
 */
@property (readonly,nonatomic) NSSet *mediaRanges;
/**
 The set of `NSValue` instances wrapping `NSRange` structures representing the locations of mentions (e.g. @screenname) within the receiver's `text` property.
 
 The `entities.user_mentions` of the Tweet JSON object.
 
 More information can be found at https://dev.twitter.com/docs/entities#tweets
 */
@property (readonly,nonatomic) NSSet *mentionRanges;
/**
 The set of `NSValue` instances wrapping `NSRange` structures representing the locations of financial symbols within the receiver's `text` property.
 
 The `entities.symbols` of the Tweet JSON object.
 
 More information can be found at https://dev.twitter.com/docs/entities#tweets
 */
@property (readonly,nonatomic) NSSet *symbolRanges;
/**
 The set of `NSValue` instances wrapping `NSRange` structures representing the locations of urls within the receiver's `text` property.
 
 The `entities.urls` of the Tweet JSON object.
 
 More information can be found at https://dev.twitter.com/docs/entities#tweets
 */
@property (readonly,nonatomic) NSSet *urlRanges;

/**
 The date the receiver was created at.
 
 The `created_at` of the Tweet JSON object.
 */
@property (readonly,nonatomic) NSDate *createdAt;
/**
 A string representing the `createdAt` property.
 */
@property (readonly,nonatomic) NSString *relativeCreatedAtString;

/**
 The approximate favorite count of the Tweet.
 
 The `favorite_count` of the Tweet JSON object.
 */
@property (readonly,nonatomic) NSUInteger favoriteCount;
/**
 The approximate retweet count of the Tweet.
 
 The `retweet_count` of the Tweet JSON object.
 */
@property (readonly,nonatomic) NSUInteger retweetCount;

/**
 A thumbnail of the receiver's attached media, if any.
 
 The property is initially nil, and is fetched asynchronously once the receiver's `active` property is set to YES. You should bind to this property with ReactiveCocoa to be notified when the thumbanil is fetched.
 
 See `MERTweetTableViewCell` within the MERTwitterKitDemo group for an example.
 */
@property (readonly,strong,nonatomic) UIImage *mediaThumbnailImage;

/**
 The `MERTwitterUserViewModel` instance that represents the owning user of the Tweet.
 */
@property (readonly,strong,nonatomic) MERTwitterUserViewModel *userViewModel;
/**
 The array of discussion tweets rooted at the receiver.
 
 @see [MERTwitterClient fetchThreadForTweetWithIdentity]
 */
@property (readonly,nonatomic) NSArray *threadTweets;

@end
