//
//  MERThumbnailManager.h
//  MERThumbnailKit
//
//  Created by William Towe on 5/1/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

/**
 Enum that describes the cache type that was used, if any, when generating a thumbnail.
 
 - `MERThumbnailManagerCacheTypeNone`, no cache was used
 - `MERThumbnailManagerCacheTypeFile`, the file cache was used
 - `MERThumbnailManagerCacheTypeMemory`, the memory cache was used
 */
typedef NS_ENUM(NSInteger, MERThumbnailManagerCacheType) {
    MERThumbnailManagerCacheTypeNone,
    MERThumbnailManagerCacheTypeFile,
    MERThumbnailManagerCacheTypeMemory
};

/**
 Mask that describes the cache options used when storing a generated thumbnail.
 
 - `MERThumbnailManagerCacheOptionsNone`, thumbnails are never cached
 - `MERThumbnailManagerCacheOptionsFile`, thumbnails are cached on disk
 - `MERThumbnailManagerCacheOptionsMemory`, thumbnails are cached in memory
 - `MERThumbnailManagerCacheOptionsAll`, thumbnails are cached on disk and in memory
 - `MERThumbnailManagerCacheOptionsDefault`, the default caching options
 */
typedef NS_OPTIONS(NSInteger, MERThumbnailManagerCacheOptions) {
    MERThumbnailManagerCacheOptionsNone = 0,
    MERThumbnailManagerCacheOptionsFile = 1 << 0,
    MERThumbnailManagerCacheOptionsMemory = 1 << 1,
    MERThumbnailManagerCacheOptionsAll = MERThumbnailManagerCacheOptionsFile | MERThumbnailManagerCacheOptionsMemory,
    MERThumbnailManagerCacheOptionsDefault = MERThumbnailManagerCacheOptionsAll
};

typedef void(^MERThumbnailManagerDownloadProgressBlock)(NSURL *url, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

/**
 The error domain for `MERThumbnailManager` errors.
 */
extern NSString *const MERThumbnailManagerErrorDomain;
/**
 The `NSURLResponse` of the `NSURLSessionTask` that generated the error.
 */
extern NSString *const MERThumbnailManagerErrorUserInfoKeyURLResponse;

@class RACSignal;

/**
 `MERThumbnailManager` is a class for generating thumbnails from urls, both local and remote. The `thumbnailForURL:size:page:time:` method and its variants return a signal that sends `next` with a thumbnail for the provided url, then `completes`. If the thumbnail cannot be generated, which may happen if the url is remote, sends `error`.
 */
@interface MERThumbnailManager : NSObject

/**
 Returns the cache options assigned to the receiver.
 
 @see MERThumbnailManagerCacheOptions
 */
@property (assign,nonatomic) MERThumbnailManagerCacheOptions cacheOptions;
/**
 Returns whether the receiver has file caching enabled.
 
 @see MERThumbnailManagerCacheOptionsFile
 */
@property (readonly,nonatomic,getter = isFileCachingEnabled) BOOL fileCachingEnabled;
/**
 Returns whether the receiver has memory caching enabled.
 
 @see MERThumbnailManagerCacheOptionsMemory
 */
@property (readonly,nonatomic,getter = isMemoryCachingEnabled) BOOL memoryCachingEnabled;

/**
 Returns the directory url used for downloaded file caching. The directory will be created if it does not exist.
 
 The default is `Caches/MERThumbnailKitBundleIdentifier/downloads`.
 */
@property (copy,nonatomic) NSURL *downloadedFileCacheDirectoryURL;
/**
 Returns the directory url used for thumbnail file caching.
 */
@property (readonly,strong,nonatomic) NSURL *thumbnailFileCacheDirectoryURL;

/**
 Return the thumbnail size assigned to the receiver. This size is used for any method that does not contain an explicit _size_ parameter.
 
 The default is `CGSizeMake(175, 175)`.
 */
@property (assign,nonatomic) CGSize thumbnailSize;
/**
 Return the thumbnail page assigned to the receiver. This page is used for any method that does not contain an explicit _page_ parameter and is only used for UTIs conforming to `kUTTypePDF`.
 
 The default is 1.
 */
@property (assign,nonatomic) NSInteger thumbnailPage;
/**
 Return the thumbnail time assigned to the receiver. This time is used for any method that does not contain an explicit _time_ parameter and is only used for UTIs conforming to `kUTTypeMovie`.
 
 The default is 1.0.
 */
@property (assign,nonatomic) NSTimeInterval thumbnailTime;

/**
 Returns the shared manager instance.
 
 You can also create your own instance using `[[MERThumbnailManager alloc] init]`.
 */
+ (instancetype)sharedManager;

/**
 Clears the downloaded file cache.
 */
- (void)clearDownloadedFileCache;
/**
 Clears the thumbnail file cache.
 */
- (void)clearThumbnailFileCache;
/**
 Clears the thumbnail memory cache.
 */
- (void)clearThumbnailMemoryCache;

/**
 Returns the downloaded file cache key for the provided asset _url_.
 
 @param url The url of the asset
 @return The downloaded file cache key for _url_
 @exception NSException Thrown if _url_ is nil
 */
- (NSString *)downloadedFileCacheKeyForURL:(NSURL *)url;
/**
 Returns the downloaded file cache url for the provided asset _url_.
 
 @param key The file cache key
 @return The downloaded file cache url for _url_
 @exception NSException Thrown if _url_ is nil
 */
- (NSURL *)downloadedFileCacheURLForKey:(NSString *)key;
/**
 Returns the dowloaded file cache url for the provided asset _url_.
 
 @param url The url of the asset
 @return The downloaded file cache url for _url_
 @exception NSException Thrown if _url_ is nil
 */
- (NSURL *)downloadedFileCacheURLForURL:(NSURL *)url;

/**
 Returns the thumbnail memory cache key for the provided _url_, _size_, _page_, and _time_.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @param page The page of the thumbnail
 @param time The time of the thumbnail
 @return The thumbnail memory cache key for the provided _url_, _size_, _page_, and _time_
 @exception NSException Thrown if _url_ is nil
 */
- (NSString *)thumbnailMemoryCacheKeyForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time;
/**
 Returns the thumbnail file cache url for the provided memory cache _key_.
 
 @param key The memory cache key
 @return The thumbnail file cache url for _key_
 @exception NSException Thrown if _key_ is nil
 */
- (NSURL *)thumbnailFileCacheURLForMemoryCacheKey:(NSString *)key;
/**
 Returns the thumbnail file cache url for the provided asset _url_.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @param page The page of the thumbnail
 @param time The time of the thumbnail
 @return The thumbnail file cache url for _url_
 @exception NSException Thrown if _url_ is nil
 */
- (NSURL *)thumbnailFileCacheURLForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time;

/**
 Calls `thumbnailForURL:size:page:time:`, passing _url_, `thumbnailSize`, `thumbnailPage`, and `thumbnailTime` respectively.
 
 @param url The url of the asset
 @return The signal
 @exception NSException Thrown if _url_ is nil
 @see thumbnailForURL:size:page:time:
 */
- (RACSignal *)thumbnailForURL:(NSURL *)url;
/**
 Calls `thumbnailForURL:size:page:time:`, passing _url_, _size_, `thumbnailPage`, and `thumbnailTime` respectively.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @return The signal
 @exception NSException Thrown if _url_ is nil
 @see thumbnailForURL:size:page:time:
 */
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size;
/**
 Calls `thumbnailForURL:size:page:time:`, passing _url_, _url_, _page_, and `thumbnailTime` respectively.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @param page The page of the thumbnail
 @return The signal
 @exception NSException Thrown if _url_ is nil
 @see thumbnailForURL:size:page:time:
 */
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page;
/**
 Calls `thumbnailForURL:size:page:time:`, passing _url_, _size_, `thumbnailPage`, and _time_ respectively.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @param time The time of the thumbnail
 @return The signal
 @exception NSException Thrown if _url_ is nil
 @see thumbnailForURL:size:page:time:
 */
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time;
/**
 Returns a signal that sends `next` with a `RACTuple` containing _url_, the thumbnail image, and the `MERThumbnailManagerCacheType` of the generated thumbnail, then `completes`. If the request cannot be completed, which is possible for remote urls, sends `error`.
 
 @param url The url of the asset
 @param size The size of the thumbnail
 @param page The page of the thumbnail
 @param time The time of the thumbnail
 @return The signal
 @exception NSException Thrown if _url_ is nil
 */
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time;

/**
 Returns a signal that sends `next` with a `RACTuple` containing _url_, an `NSURL` instance representing the asset at _url_, and the `MERThumbnailManagerCacheType` describing the location of the asset. If the request cannot be completed, sends `error`.
 
 @param url The url of the asset
 @param progress A progress block that is called while downloading the asset
 @return The signal
 @exception NSException Thrown if the _url_ is nil
 */
- (RACSignal *)downloadFileWithURL:(NSURL *)url progress:(MERThumbnailManagerDownloadProgressBlock)progress;

@end
