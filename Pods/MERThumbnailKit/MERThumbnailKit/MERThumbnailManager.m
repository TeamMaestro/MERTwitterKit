//
//  MERThumbnailManager.m
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

#import "MERThumbnailManager.h"
#import "MERThumbnailKitCommon.h"
#import "MERThumbnailKitFunctions.h"
#import "NSURLRequest+MERThumbnailKitExtensions.h"
#import <MEFoundation/MEFoundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACDelegateProxy.h>
#import <libextobjc/EXTScope.h>
#import <AVFoundation/AVFoundation.h>

#if (TARGET_OS_IPHONE)
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIApplication.h>

#import "UIImage+MERThumbnailKitExtensions.h"
#import "UIWebView+MERThumbnailKitExtensions.h"

#define MERThumbnailKitImageClass UIImage
#else
#import <QuickLook/QuickLook.h>

#import "NSImage+MERThumbnailKitExtensions.h"

#define MERThumbnailKitImageClass NSImage
#endif

#if !__has_feature(objc_arc)
#error MERThumbnailKit requires ARC
#endif

NSString *const MERThumbnailManagerErrorDomain = @"MERThumbnailManagerErrorDomain";
NSString *const MERThumbnailManagerErrorUserInfoKeyURLResponse = @"MERThumbnailManagerErrorUserInfoKeyURLResponse";

static CGSize const kMERThumbnailManagerDefaultThumbnailSize = {.width=175, .height=175};
static NSInteger const kMERThumbnailManagerDefaultThumbnailPage = 1;
static NSTimeInterval const kMERThumbnailManagerDefaultThumbnailTime = 1.0;

static NSString *const kMERThumbnailManagerDownloadFileCacheDirectoryName = @"downloads";
static NSString *const kMERThumbnailManagerThumbnailFileCacheDirectoryName = @"thumbnails";

#if (TARGET_OS_IPHONE)
@interface MERThumbnailManager () <UIWebViewDelegate,NSCacheDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
#else
@interface MERThumbnailManager () <NSCacheDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>
#endif

@property (readwrite,strong,nonatomic) NSURL *thumbnailFileCacheDirectoryURL;

@property (strong,nonatomic) NSCache *memoryCache;
@property (strong,nonatomic) dispatch_queue_t fileCacheQueue;

#if (TARGET_OS_IPHONE)
@property (strong,nonatomic) dispatch_queue_t webViewThumbnailQueue;
@property (strong,nonatomic) dispatch_semaphore_t webViewThumbnailSemaphore;
#endif

@property (strong,nonatomic) NSURLSession *urlSession;

@property (strong,nonatomic) NSOperationQueue *remoteThumbnailUrlConnectionDelegateOperationQueue;

- (void)_cacheImageToFile:(MERThumbnailKitImageClass *)image url:(NSURL *)url;
- (void)_cacheImageToMemory:(MERThumbnailKitImageClass *)image key:(NSString *)key;

- (MERThumbnailKitImageClass *)_imageFromCGPDFDocument:(CGPDFDocumentRef)documentRef size:(CGSize)size page:(NSInteger)page;

#if (TARGET_OS_IPHONE)
- (void)_generateThumbnailFromWebView:(UIWebView *)webView;
#endif

- (RACSignal *)_imageThumbnailForURL:(NSURL *)url size:(CGSize)size;
- (RACSignal *)_movieThumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time;
- (RACSignal *)_pdfThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page;
- (RACSignal *)_rtfThumbnailForURL:(NSURL *)url size:(CGSize)size;
- (RACSignal *)_textThumbnailForURL:(NSURL *)url size:(CGSize)size;

#if (TARGET_OS_IPHONE)
- (RACSignal *)_webViewThumbnailForURL:(NSURL *)url size:(CGSize)size;
#else
- (RACSignal *)_quickLookThumbnailForURL:(NSURL *)url size:(CGSize)size;
#endif

- (RACSignal *)_remoteImageThumbnailForURL:(NSURL *)url size:(CGSize)size;
- (RACSignal *)_remoteMovieThumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time;
- (RACSignal *)_remotePdfThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page;

#if (TARGET_OS_IPHONE)
- (RACSignal *)_remoteThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time;
#endif
@end

@implementation MERThumbnailManager
#pragma mark *** Subclass Overrides ***
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    if (!(self = [super init]))
        return nil;
    
    [self setCacheOptions:MERThumbnailManagerCacheOptionsDefault];
    
    NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *fileCacheDirectoryURL = [cachesDirectoryURL URLByAppendingPathComponent:MERThumbnailKitBundleIdentifier isDirectory:YES];
    
#if (!TARGET_OS_IPHONE)
    fileCacheDirectoryURL = [fileCacheDirectoryURL URLByAppendingPathComponent:[NSBundle mainBundle].ME_identifier isDirectory:YES];
#endif
    
    NSURL *downloadedFileCacheDirectoryURL = [fileCacheDirectoryURL URLByAppendingPathComponent:kMERThumbnailManagerDownloadFileCacheDirectoryName isDirectory:YES];
    
    [self setDownloadedFileCacheDirectoryURL:downloadedFileCacheDirectoryURL];
    
    NSURL *thumbnailFileCacheDirectoryURL = [fileCacheDirectoryURL URLByAppendingPathComponent:kMERThumbnailManagerThumbnailFileCacheDirectoryName isDirectory:YES];
    
    if (![thumbnailFileCacheDirectoryURL checkResourceIsReachableAndReturnError:NULL]) {
        NSError *outError;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:thumbnailFileCacheDirectoryURL withIntermediateDirectories:YES attributes:nil error:&outError])
            MELogObject(outError);
    }
    
    [self setThumbnailFileCacheDirectoryURL:thumbnailFileCacheDirectoryURL];
    
    [self setThumbnailSize:kMERThumbnailManagerDefaultThumbnailSize];
    [self setThumbnailPage:kMERThumbnailManagerDefaultThumbnailPage];
    [self setThumbnailTime:kMERThumbnailManagerDefaultThumbnailTime];
    
    [self setMemoryCache:[[NSCache alloc] init]];
    [self.memoryCache setName:[NSString stringWithFormat:@"%@.%p",MERThumbnailKitBundleIdentifier,self]];
    [self.memoryCache setDelegate:self];
    
    [self setFileCacheQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.filecache.%p",MERThumbnailKitBundleIdentifier,self].UTF8String, DISPATCH_QUEUE_SERIAL)];
    
#if (TARGET_OS_IPHONE)
    [self setWebViewThumbnailSemaphore:dispatch_semaphore_create([NSProcessInfo processInfo].activeProcessorCount)];
    [self setWebViewThumbnailQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.webview.%p",MERThumbnailKitBundleIdentifier,self].UTF8String, DISPATCH_QUEUE_CONCURRENT)];
#endif
    
    [self setUrlSession:[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:nil]];
    
    [self setRemoteThumbnailUrlConnectionDelegateOperationQueue:[[NSOperationQueue alloc] init]];
    [self.remoteThumbnailUrlConnectionDelegateOperationQueue setName:[NSString stringWithFormat:@"%@.%p",MERThumbnailKitBundleIdentifier,self]];
    [self.remoteThumbnailUrlConnectionDelegateOperationQueue setMaxConcurrentOperationCount:[NSProcessInfo processInfo].activeProcessorCount];
    
    @weakify(self);
    
    [[[RACObserve(self, downloadedFileCacheDirectoryURL)
      distinctUntilChanged]
      map:^id(id value) {
          return (value) ?: downloadedFileCacheDirectoryURL;
    }]
     subscribeNext:^(NSURL *value) {
         if (![value checkResourceIsReachableAndReturnError:NULL]) {
             NSError *outError;
             if (![[NSFileManager defaultManager] createDirectoryAtURL:value withIntermediateDirectories:YES attributes:nil error:&outError])
                 MELogObject(outError);
         }
    }];
    
#if (TARGET_OS_IPHONE)
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil]
      takeUntil:[self rac_willDeallocSignal]]
     subscribeNext:^(id _) {
         @strongify(self);
         
         [self clearThumbnailMemoryCache];
    }];
#endif
    
    return self;
}
#pragma mark NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    MELog(@"%@ %@",cache,obj);
}
#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    MELog(@"%@ %@",session,error);
}
#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        MELogObject(error);
        id<RACSubscriber> subscriber = task.originalRequest.MER_subscriber;
        
        [subscriber sendError:error];
    }
}
#pragma mark NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    MERThumbnailManagerDownloadProgressBlock progressBlock = downloadTask.originalRequest.MER_downloadProgressBlock;

    if (progressBlock) {
        MEDispatchMainAsync(^{
            progressBlock(downloadTask.originalRequest.URL,totalBytesWritten,totalBytesExpectedToWrite);
        });
    }
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    id<RACSubscriber> subscriber = downloadTask.originalRequest.MER_subscriber;
    NSInteger statusCode = [(NSHTTPURLResponse *)downloadTask.response statusCode];
    
    if (statusCode <= 299 && statusCode >= 200) {
        NSURL *url = [self downloadedFileCacheURLForURL:downloadTask.originalRequest.URL];
        
        [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:url error:NULL];
        
        [subscriber sendNext:RACTuplePack(downloadTask.originalRequest.URL,url,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
    }
    else {
        [subscriber sendError:[NSError errorWithDomain:MERThumbnailManagerErrorDomain code:statusCode userInfo:@{MERThumbnailManagerErrorUserInfoKeyURLResponse: downloadTask.response}]];
    }
}
#pragma mark UIWebViewDelegate

#if (TARGET_OS_IPHONE)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString rangeOfString:@"orgmaestromerthumbnailkit:ready"].length > 0) {
        [self performSelector:@selector(_generateThumbnailFromWebView:) withObject:webView afterDelay:0.0];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSInteger count = webView.MER_concurrentRequestCount;
    
    [webView setMER_concurrentRequestCount:++count];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSInteger count = webView.MER_concurrentRequestCount;
    
    [webView setMER_concurrentRequestCount:--count];
    
    if (count > 0)
        return;

    id<RACSubscriber> subscriber = webView.MER_subscriber;
    NSURL *url = webView.MER_originalURL;
    
    [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
    [subscriber sendCompleted];
    
    [webView setMER_subscriber:nil];
    [webView setMER_originalURL:nil];
    [webView setDelegate:nil];
    [webView stopLoading];
    [webView removeFromSuperview];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSURL *url = webView.MER_originalURL;
    
    if (url.isFileURL) {
        [self _generateThumbnailFromWebView:webView];
    }
    else {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[MERThumbnailKitResourcesBundle() URLForResource:@"webview_script" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL]];
    }
}
#endif

#pragma mark *** Public Methods ***
+ (instancetype)sharedManager; {
    static id retval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retval = [[MERThumbnailManager alloc] init];
    });
    return retval;
}

- (void)clearDownloadedFileCache; {
    NSError *outError;
    if (![[NSFileManager defaultManager] removeItemAtURL:self.downloadedFileCacheDirectoryURL error:&outError])
        MELogObject(outError);
}
- (void)clearThumbnailFileCache; {
    NSError *outError;
    if (![[NSFileManager defaultManager] removeItemAtURL:self.thumbnailFileCacheDirectoryURL error:&outError])
        MELogObject(outError);
}
- (void)clearThumbnailMemoryCache; {
    [self.memoryCache removeAllObjects];
}

- (NSString *)downloadedFileCacheKeyForURL:(NSURL *)url; {
    NSParameterAssert(url);
    
    return [url.absoluteString.ME_MD5String stringByAppendingPathExtension:url.lastPathComponent.pathExtension];
}
- (NSURL *)downloadedFileCacheURLForKey:(NSString *)key; {
    NSParameterAssert(key);
    
    return [self.downloadedFileCacheDirectoryURL URLByAppendingPathComponent:key isDirectory:NO];
}
- (NSURL *)downloadedFileCacheURLForURL:(NSURL *)url; {
    NSParameterAssert(url);
    
    return [self downloadedFileCacheURLForKey:[self downloadedFileCacheKeyForURL:url]];
}

- (NSString *)thumbnailMemoryCacheKeyForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
#if (TARGET_OS_IPHONE)
    return [NSString stringWithFormat:@"%@%@%@",url.absoluteString.ME_MD5String,NSStringFromCGSize(size),@(page)];
#else
    return [NSString stringWithFormat:@"%@%@%@",url.absoluteString.ME_MD5String,NSStringFromSize(NSSizeFromCGSize(size)),@(page)];
#endif
}
- (NSURL *)thumbnailFileCacheURLForMemoryCacheKey:(NSString *)key; {
    NSParameterAssert(key);
    
    return [self.thumbnailFileCacheDirectoryURL URLByAppendingPathComponent:key isDirectory:NO];
}
- (NSURL *)thumbnailFileCacheURLForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
    return [self thumbnailFileCacheURLForMemoryCacheKey:[self thumbnailMemoryCacheKeyForURL:url size:size page:page time:time]];
}
#pragma mark Signals
- (RACSignal *)thumbnailForURL:(NSURL *)url; {
    return [self thumbnailForURL:url size:self.thumbnailSize page:self.thumbnailPage time:self.thumbnailTime];
}
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size; {
    return [self thumbnailForURL:url size:size page:self.thumbnailPage time:self.thumbnailTime];
}
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page; {
    return [self thumbnailForURL:url size:size page:page time:self.thumbnailTime];
}
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time; {
    return [self thumbnailForURL:url size:size page:self.thumbnailPage time:time];
}
- (RACSignal *)thumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
    @weakify(self);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        MERThumbnailKitImageClass *retval = nil;
        NSString *key = [self thumbnailMemoryCacheKeyForURL:url size:size page:page time:time];

        if (self.isMemoryCachingEnabled) {
            retval = [self.memoryCache objectForKey:key];
            
            if (retval) {
                [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeMemory))];
                [subscriber sendCompleted];
            }
        }
        
        if (!retval) {
            if (self.isFileCachingEnabled) {
                NSURL *thumbnailFileCacheURL = [self thumbnailFileCacheURLForMemoryCacheKey:key];
                
                if ([thumbnailFileCacheURL checkResourceIsReachableAndReturnError:NULL]) {
                    retval = [[MERThumbnailKitImageClass alloc] initWithContentsOfFile:thumbnailFileCacheURL.path];

                    if (retval) {
                        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeFile))];
                        [subscriber sendCompleted];
                    }
                }
            }
        }
        
        if (!retval) {
            if (url.isFileURL) {
                NSString *uti = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.lastPathComponent.pathExtension, NULL);
                
                if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeImage)) {
                    [[self _imageThumbnailForURL:url size:size] subscribe:subscriber];
                }
                else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeMovie)) {
                    [[self _movieThumbnailForURL:url size:size time:time] subscribe:subscriber];
                }
                else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypePDF)) {
                    [[self _pdfThumbnailForURL:url size:size page:page] subscribe:subscriber];
                }
                else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeRTF) ||
                         UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeRTFD)) {
                    
                    [[self _rtfThumbnailForURL:url size:size] subscribe:subscriber];
                }
                else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypePlainText)) {
                    [[self _textThumbnailForURL:url size:size] subscribe:subscriber];
                }
#if (TARGET_OS_IPHONE)
                else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeHTML) ||
                         [@[@"doc",
                            @"docx",
                            @"ppt",
                            @"pptx",
                            @"xls",
                            @"xlsx",
                            @"csv"] containsObject:url.lastPathComponent.pathExtension.lowercaseString]) {
                             
                             [[self _webViewThumbnailForURL:url size:size] subscribe:subscriber];
                         }
#endif
                else {
#if (TARGET_OS_IPHONE)
                    [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
                    [subscriber sendCompleted];
#else
                    [[self _quickLookThumbnailForURL:url size:size] subscribe:subscriber];
#endif
                }
            }
            else {
                NSURL *downloadedFileCacheURL = [self downloadedFileCacheURLForURL:url];
                
                if ([downloadedFileCacheURL checkResourceIsReachableAndReturnError:NULL]) {
                    [[self thumbnailForURL:downloadedFileCacheURL size:size page:page time:time] subscribe:subscriber];
                }
                else {
                    NSString *uti = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.lastPathComponent.pathExtension, NULL);

                    if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeImage)) {
                        [[self _remoteImageThumbnailForURL:url size:size] subscribe:subscriber];
                    }
                    else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeMovie)) {
                        [[self _remoteMovieThumbnailForURL:url size:size time:time] subscribe:subscriber];
                    }
                    else if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypePDF)) {
                        [[self _remotePdfThumbnailForURL:url size:size page:page] subscribe:subscriber];
                    }
//                    else if ([url.scheme hasPrefix:@"http"] || [url.scheme hasPrefix:@"https"]) {
//                        [[self _webViewThumbnailForURL:url size:size] subscribe:subscriber];
//                    }
                    else {
#if (TARGET_OS_IPHONE)
                        [[self _remoteThumbnailForURL:url size:size page:page time:time] subscribe:subscriber];
#else
                        [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
                        [subscriber sendCompleted];
#endif
                    }
                }
            }
        }
        
        return nil;
    }] doNext:^(RACTuple *value) {
        @strongify(self);
        
        RACTupleUnpack(NSURL *url, MERThumbnailKitImageClass *image, NSNumber *cacheType) = value;
        
        if (image) {
            NSString *key = [self thumbnailMemoryCacheKeyForURL:url size:size page:page time:time];
            NSURL *thumbnailFileCacheURL = [self thumbnailFileCacheURLForMemoryCacheKey:key];
            MERThumbnailManagerCacheType cacheTypeValue = cacheType.integerValue;

            switch (cacheTypeValue) {
                case MERThumbnailManagerCacheTypeNone:
                    if (self.isFileCachingEnabled)
                        [self _cacheImageToFile:image url:thumbnailFileCacheURL];
                case MERThumbnailManagerCacheTypeFile:
                    if (self.isMemoryCachingEnabled)
                        [self _cacheImageToMemory:image key:key];
                    break;
                default:
                    break;
            }
        }
    }];
}

- (RACSignal *)downloadFileWithURL:(NSURL *)url progress:(MERThumbnailManagerDownloadProgressBlock)progress; {
    NSParameterAssert(url);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSURL *downloadedFileCacheURL = [self downloadedFileCacheURLForURL:url];
        
        if ([downloadedFileCacheURL checkResourceIsReachableAndReturnError:NULL]) {
            [subscriber sendNext:RACTuplePack(url,downloadedFileCacheURL,@(MERThumbnailManagerCacheTypeFile))];
            [subscriber sendCompleted];
        }
        else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            [request setMER_subscriber:subscriber];
            [request setMER_downloadProgressBlock:progress];
            
            NSURLSessionDownloadTask *task = [self.urlSession downloadTaskWithRequest:request];
            
            [task resume];
            
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }
        return nil;
    }];
}
#pragma mark Properties
- (BOOL)isFileCachingEnabled {
    return ((self.cacheOptions & MERThumbnailManagerCacheOptionsFile) != 0);
}
- (BOOL)isMemoryCachingEnabled {
    return ((self.cacheOptions & MERThumbnailManagerCacheOptionsMemory) != 0);
}

- (void)setThumbnailSize:(CGSize)thumbnailSize {
    _thumbnailSize = (CGSizeEqualToSize(CGSizeZero, thumbnailSize)) ? kMERThumbnailManagerDefaultThumbnailSize : thumbnailSize;
}
- (void)setThumbnailPage:(NSInteger)thumbnailPage {
    _thumbnailPage = MAX(thumbnailPage, kMERThumbnailManagerDefaultThumbnailPage);
}
#pragma mark *** Private Methods ***
- (void)_cacheImageToFile:(MERThumbnailKitImageClass *)image url:(NSURL *)url; {
    NSParameterAssert(image);
    NSParameterAssert(url);
    
    dispatch_async(self.fileCacheQueue, ^{
#if (TARGET_OS_IPHONE)
        NSData *data = (image.MER_hasAlpha) ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 1.0);
#else
        CGImageRef imageRef = [image CGImageForProposedRect:NULL context:NULL hints:nil];
        CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
        NSData *data = (__bridge_transfer NSData *)CGDataProviderCopyData(dataProviderRef);
#endif

        NSError *outError;
        if (![data writeToURL:url options:0 error:&outError])
            MELogObject(outError);
    });
}
- (void)_cacheImageToMemory:(MERThumbnailKitImageClass *)image key:(NSString *)key; {
    NSParameterAssert(image);
    NSParameterAssert(key);
    
    [self.memoryCache setObject:image forKey:key cost:(image.size.width * image.size.height)];
}

- (MERThumbnailKitImageClass *)_imageFromCGPDFDocument:(CGPDFDocumentRef)documentRef size:(CGSize)size page:(NSInteger)page; {
    NSParameterAssert(documentRef);
    
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(documentRef);
    size_t pageNumber = MEBoundedValue(page, kMERThumbnailManagerDefaultThumbnailPage, numberOfPages);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, pageNumber);
    CGSize pageSize = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox).size;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(pageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextTranslateCTM(context, 0, pageSize.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawPDFPage(context, pageRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *retval = [image MER_thumbnailOfSize:size];
#else
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pageSize.width, pageSize.height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextDrawPDFPage(context, pageRef);
    
    CGImageRef sourceImageRef = CGBitmapContextCreateImage(context);
    CGImageRef imageRef = MERThumbnailKitCreateCGImageThumbnailWithSize(sourceImageRef, size);
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(sourceImageRef);
    CGImageRelease(imageRef);
#endif
    
    return retval;
}
#if (TARGET_OS_IPHONE)
- (void)_generateThumbnailFromWebView:(UIWebView *)webView; {
    NSParameterAssert(webView);
    
    [webView setDelegate:nil];
    [webView stopLoading];
    
    id<RACSubscriber> subscriber = webView.MER_subscriber;
    NSURL *url = webView.MER_originalURL;
    CGSize size = CGSizeMake(CGRectGetWidth(webView.frame), CGRectGetHeight(webView.frame));
    
    UIGraphicsBeginImageContext(size);
    
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [webView setMER_subscriber:nil];
    [webView removeFromSuperview];
    
    dispatch_semaphore_signal(self.webViewThumbnailSemaphore);
    
    @weakify(self);
    
    MEDispatchDefaultAsync(^{
        @strongify(self);
        
        UIImage *retval = [image MER_thumbnailOfSize:self.thumbnailSize];
        
        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
    });
}
#endif

#pragma mark Signals
- (RACSignal *)_imageThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        MERThumbnailKitImageClass *image = [[MERThumbnailKitImageClass alloc] initWithContentsOfFile:url.path];
        MERThumbnailKitImageClass *retval = [image MER_thumbnailOfSize:size];
        
        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
        
        return nil;
    }];
}
- (RACSignal *)_movieThumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVAssetImageGenerator *assetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        
        [assetImageGenerator setAppliesPreferredTrackTransform:YES];
        
        int32_t const kPreferredTimeScale = 1;
        
        CGImageRef imageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(time, kPreferredTimeScale) actualTime:NULL error:NULL];
        CGImageRef sourceImageRef = MERThumbnailKitCreateCGImageThumbnailWithSize(imageRef, size);
#if (TARGET_OS_IPHONE)
        MERThumbnailKitImageClass *retval = [[MERThumbnailKitImageClass alloc] initWithCGImage:sourceImageRef];
#else
        MERThumbnailKitImageClass *retval = [[MERThumbnailKitImageClass alloc] initWithCGImage:sourceImageRef size:NSZeroSize];
#endif
        
        CGImageRelease(imageRef);
        CGImageRelease(sourceImageRef);
        
        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
        
        return nil;
    }];
}
- (RACSignal *)_pdfThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)url);
        MERThumbnailKitImageClass *retval = [self _imageFromCGPDFDocument:documentRef size:size page:page];
        
        CGPDFDocumentRelease(documentRef);
        
        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
        
        return nil;
    }];
}
- (RACSignal *)_rtfThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *attributes;
        NSError *outError;
#if (TARGET_OS_IPHONE)
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithFileURL:url options:@{NSDocumentTypeDocumentAttribute: ([url.lastPathComponent.pathExtension isEqualToString:@"rtf"]) ? NSRTFTextDocumentType : NSRTFDTextDocumentType} documentAttributes:&attributes error:&outError];
#else
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:url options:@{NSDocumentTypeDocumentAttribute: ([url.lastPathComponent.pathExtension isEqualToString:@"rtf"]) ? NSRTFTextDocumentType : NSRTFDTextDocumentType} documentAttributes:&attributes error:&outError];
#endif
        
        if (attributedString) {
#if (TARGET_OS_IPHONE)
            CGSize const kSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
            
            UIGraphicsBeginImageContextWithOptions(kSize, YES, 0);
            
            UIColor *backgroundColor = ([attributedString attribute:NSBackgroundColorAttributeName atIndex:0 effectiveRange:NULL]) ?: [UIColor whiteColor];
            
            [backgroundColor setFill];
            UIRectFill(CGRectMake(0, 0, kSize.width, kSize.height));
            
            [attributedString drawWithRect:CGRectMake(0, 0, kSize.width, kSize.height) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            UIImage *retval = [image MER_thumbnailOfSize:size];
#else
            NSImage *retval = [[NSImage alloc] initWithSize:size];
            
            [retval lockFocus];
            
            [attributedString drawAtPoint:NSZeroPoint];
            
            [retval unlockFocus];
#endif
            
            [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        }
        else {
            MELogObject(outError);
            
            [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
        }
        
        [subscriber sendCompleted];
        
        return nil;
    }];
}
- (RACSignal *)_textThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSDictionary *attributes;
        NSError *outError;
#if (TARGET_OS_IPHONE)
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithFileURL:url options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType,NSDefaultAttributesDocumentAttribute: @{NSForegroundColorAttributeName: [UIColor blackColor],NSBackgroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize:17]}} documentAttributes:&attributes error:&outError];
#else
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:url options:@{NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType,NSDefaultAttributesDocumentOption: @{NSForegroundColorAttributeName: [NSColor blackColor],NSBackgroundColorAttributeName: [NSColor whiteColor],NSFontAttributeName: [NSFont systemFontOfSize:17]}} documentAttributes:&attributes error:&outError];
#endif
        
        if (attributedString) {
#if (TARGET_OS_IPHONE)
            CGSize const kSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
            
            UIGraphicsBeginImageContextWithOptions(kSize, YES, 0);
            
            UIColor *backgroundColor = ([attributedString attribute:NSBackgroundColorAttributeName atIndex:0 effectiveRange:NULL]) ?: [UIColor whiteColor];
            
            [backgroundColor setFill];
            UIRectFill(CGRectMake(0, 0, kSize.width, kSize.height));
            
            [attributedString drawWithRect:CGRectMake(0, 0, kSize.width, kSize.height) options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            UIImage *retval = [image MER_thumbnailOfSize:size];
#else
            NSImage *retval = [[NSImage alloc] initWithSize:size];
            
            [retval lockFocus];
            
            [attributedString drawWithRect:NSMakeRect(0, 0, size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin];
            
            [retval unlockFocus];
#endif
            
            [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        }
        else {
            MELogObject(outError);
            
            [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
        }
        
        [subscriber sendCompleted];
        
        return nil;
    }];
}

#if (TARGET_OS_IPHONE)
- (RACSignal *)_webViewThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        dispatch_async(self.webViewThumbnailQueue, ^{
            @strongify(self);

            dispatch_semaphore_wait(self.webViewThumbnailSemaphore, DISPATCH_TIME_FOREVER);
            
            MEDispatchMainAsync(^{
                @strongify(self);
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                UIWebView *webView = [[UIWebView alloc] initWithFrame:window.bounds];
                
                [webView setUserInteractionEnabled:NO];
                [webView setScalesPageToFit:YES];
                [webView setDelegate:self];
                [webView setMER_subscriber:subscriber];
                [webView setMER_originalURL:url];
                
                [window insertSubview:webView atIndex:0];
                
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
            });
        });
        
        return nil;
    }];
}
#else
- (RACSignal *)_quickLookThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        CGImageRef imageRef = QLThumbnailImageCreate(kCFAllocatorDefault, (__bridge CFURLRef)url, size, NULL);
        NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
        
        CGImageRelease(imageRef);
        
        [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
        [subscriber sendCompleted];
        
        return nil;
    }];
}
#endif

- (RACSignal *)_remoteImageThumbnailForURL:(NSURL *)url size:(CGSize)size; {
    NSParameterAssert(url);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @strongify(self);
            
            if (error) {
                [subscriber sendError:error];
            }
            else {
                dispatch_async(self.fileCacheQueue, ^{
                    NSURL *downloadedFileCacheURL = [self downloadedFileCacheURLForURL:url];
                    
                    [[NSFileManager defaultManager] removeItemAtURL:downloadedFileCacheURL error:NULL];
                    
                    NSError *outError;
                    if (![data writeToURL:downloadedFileCacheURL options:0 error:&outError])
                        MELogObject(outError);
                });
                
                MERThumbnailKitImageClass *image = [[MERThumbnailKitImageClass alloc] initWithData:data];
                MERThumbnailKitImageClass *retval = [image MER_thumbnailOfSize:size];
                
                [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
- (RACSignal *)_remoteMovieThumbnailForURL:(NSURL *)url size:(CGSize)size time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVAssetImageGenerator *assetImageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        
        [assetImageGenerator setAppliesPreferredTrackTransform:YES];
        
        int32_t const kPreferredTimeScale = 1;
        
        [assetImageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:CMTimeMakeWithSeconds(time, kPreferredTimeScale)]] completionHandler:^(CMTime requestedTime, CGImageRef imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {
            if (result == AVAssetImageGeneratorSucceeded) {
#if (TARGET_OS_IPHONE)
                MERThumbnailKitImageClass *image = [[MERThumbnailKitImageClass alloc] initWithCGImage:imageRef];
#else
                MERThumbnailKitImageClass *image = [[MERThumbnailKitImageClass alloc] initWithCGImage:imageRef size:NSZeroSize];
#endif
                MERThumbnailKitImageClass *retval = [image MER_thumbnailOfSize:size];
                
                [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [assetImageGenerator cancelAllCGImageGeneration];
        }];
    }];
}
- (RACSignal *)_remotePdfThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page; {
    NSParameterAssert(url);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }
            else {
                dispatch_async(self.fileCacheQueue, ^{
                    NSURL *downloadedFileCacheURL = [self downloadedFileCacheURLForURL:url];
                    
                    [[NSFileManager defaultManager] removeItemAtURL:downloadedFileCacheURL error:NULL];
                    
                    NSError *outError;
                    if (![data writeToURL:downloadedFileCacheURL options:0 error:&outError])
                        MELogObject(outError);
                });
                
                CGDataProviderRef dataProviderRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
                CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithProvider(dataProviderRef);
                MERThumbnailKitImageClass *image = [self _imageFromCGPDFDocument:documentRef size:size page:page];
                MERThumbnailKitImageClass *retval = [image MER_thumbnailOfSize:size];
                
                CGPDFDocumentRelease(documentRef);
                CGDataProviderRelease(dataProviderRef);
                
                [subscriber sendNext:RACTuplePack(url,retval,@(MERThumbnailManagerCacheTypeNone))];
                [subscriber sendCompleted];
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}
#if (TARGET_OS_IPHONE)
- (RACSignal *)_remoteThumbnailForURL:(NSURL *)url size:(CGSize)size page:(NSInteger)page time:(NSTimeInterval)time; {
    NSParameterAssert(url);
    
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        RACDelegateProxy *proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(NSURLConnectionDataDelegate)];
        
        [[proxy signalForSelector:@selector(connection:didReceiveResponse:)] subscribeNext:^(RACTuple *value) {
            @strongify(self);
            
            RACTupleUnpack(NSURLConnection *connection, NSURLResponse *response) = value;
            NSString *uti = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)response.MIMEType, NULL);
            
            [connection cancel];
            
            if (UTTypeConformsTo((__bridge CFStringRef)uti, kUTTypeHTML)) {
                [[self _webViewThumbnailForURL:url size:size] subscribe:subscriber];
            }
            else {
                [subscriber sendNext:RACTuplePack(url,nil,@(MERThumbnailManagerCacheTypeNone))];
                [subscriber sendCompleted];
            }
        }];
        
        [[proxy signalForSelector:@selector(connection:didFailWithError:)] subscribeNext:^(RACTuple *value) {
            NSError *error = value.second;

            [subscriber sendError:error];
        }];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:proxy startImmediately:NO];
        
        [connection setDelegateQueue:self.remoteThumbnailUrlConnectionDelegateOperationQueue];
        [connection start];
        
        return [RACDisposable disposableWithBlock:^{
            [connection cancel];
        }];
    }];
}
#endif

@end
