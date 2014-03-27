//
//  MEDebugging.h
//  MEFoundation
//
//  Created by William Towe on 4/23/12.
//  Copyright (c) 2012 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#ifndef _ME_FOUNDATION_DEBUGGING_
#define _ME_FOUNDATION_DEBUGGING_

#ifdef DEBUG

#define MELog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else

#define MELog(...)

#endif

#define MELogObject(objectToLog) MELog(@"%@",objectToLog)
#define MELogCGRect(rectToLog) MELogObject(NSStringFromCGRect(rectToLog))
#define MELogCGSize(sizeToLog) MELogObject(NSStringFromCGSize(sizeToLog))
#define MELogCGPoint(pointToLog) MELogObject(NSStringFromCGPoint(pointToLog))
#define MELogCGFloat(floatToLog) MELog(@"%f",floatToLog)

#ifdef DEBUG

#define MEAssertLog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]

#else

#define MEAssertLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#endif

#define MEAssert(condition, ...) do { if (!(condition)) { MEAssertLog(__VA_ARGS__); }} while(0)

#define MEIsEnvironmentVariableDefined(environmentVariable) [NSProcessInfo processInfo].environment[[NSString stringWithUTF8String:(#environmentVariable)]]

#if NS_BLOCKS_AVAILABLE
#import <CoreGraphics/CGBase.h>
#include <mach/mach_time.h>

/**
 Returns the amount of time a given block takes to execute in seconds.
 
 The original timing function can be found at http://weblog.bignerdranch.com/?p=316
 
 @param block The block to time
 @return The amount of time _block_ took to execute
 */
static inline NSTimeInterval METimeBlock(void (^block)(void)) {
	mach_timebase_info_data_t info;
	
	if (mach_timebase_info(&info) != KERN_SUCCESS)
		return -1.0;
	
	uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
	
    uint64_t nanos = elapsed * info.numer / info.denom;
    
    return (NSTimeInterval)nanos / NSEC_PER_SEC;
}

#endif

#endif
