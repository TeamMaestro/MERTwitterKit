//
//  MERTwitterClient+Users.h
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
 Methods to interact with the _users_ resource family of the Twitter API.
 */
@interface MERTwitterClient (Users)

/**
 Returns a signal that sends `next` with an array of `MERTwitterUserViewModel` instances, then `completes`. If the request cannot be completed, sends `error`.
 
 You must provide _identities_ or _screenNames_.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/users/lookup
 
 @param identities The identities of the users to request
 @param screenNames The screen names of the users to request
 @return The signal
 @exception NSException Thrown if _identities_ and _screenNames_ are nil
 */
- (RACSignal *)requestUsersWithIdentities:(NSArray *)identities screenNames:(NSArray *)screenNames;

/**
 Returns a signal that sends `next` with an `RACTuple` containing an array of `MERTwitterUserViewModel` instances and the _page_ that originally passed to the method, then `completes`. If the request cannot be completed, sends `error`.
 
 More information can be found at https://dev.twitter.com/docs/api/1.1/get/users/search
 
 @param search The search term to return results for
 @param page The page of results to return
 @param count The maximum number of results to return. The default and maximum are 20
 @return The signal
 @exception NSException Thrown if _search_ is nil
 */
- (RACSignal *)requestUsersMatchingSearch:(NSString *)search page:(NSUInteger)page count:(NSUInteger)count;

@end
