//
//  UIScrollView+MERPaginatedScrollingExtensions.h
//  MEReactiveKit
//
//  Created by William Towe on 3/11/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "MERPaginatedScrolling.h"

/**
 Enum that describes the paginated scrolling state of the receiver.
 
 - `MERPaginatedScrollingStateNone`, no paginated scrolling is taking place
 - `MERPaginatedScrollingStateWillPaginate`, when the user stops dragging, paginated scrolling will begin
 - `MERPaginatedScrollingStatePaginating`, paginated scrolling is taking place
 */
typedef NS_ENUM(NSInteger, MERPaginatedScrollingState) {
    MERPaginatedScrollingStateNone,
    MERPaginatedScrollingStateWillPaginate,
    MERPaginatedScrollingStatePaginating
};

/**
 The completion block that is passed into the block that is part of `MER_addPaginatedScrollingView:block:` and `MER_addPaginatedScrollingViewWithBlock:`.
 */
typedef void(^MERPaginatedScrollingCompletionBlock)(void);

/**
 A set of methods to add and remove paginated scrolling from a `UIScrollView` instance.
 */
@interface UIScrollView (MERPaginatedScrollingExtensions)

/**
 Returns the `UIView<MERPaginatedScrolling>` instance assigned to the receiver.
 */
@property (readonly,strong,nonatomic) UIView<MERPaginatedScrolling> *MER_paginatedScrollingView;
/**
 Returns whether paginated scrolling is enabled for the receiver.
 
 You can add paginated scrolling to a `UIScrollView` instance using `MER_addPaginatedScrollingView:block:` or `MER_addPaginatedScrollingViewWithBlock:`, and then enable/disable it using this property.
 */
@property (assign,nonatomic) BOOL MER_paginatedScrollingEnabled;
/**
 Returns the current paginated scrolling state of the receiver.
 
 @see MERPaginatedScrollingState
 */
@property (readonly,assign,nonatomic) MERPaginatedScrollingState MER_paginatedScrollingState;

/**
 Calls `MER_addPaginatedScrollingView:block:`, passing an instance of `MERPaginatedScrollingView` and _block_.
 
 @param block The block that is invoked whenever paginated scrolling is triggered. The block is passed a `MERPaginatedScrollingCompletionBlock` that should be invoked whenever the paginated scrolling operation has completed
 @exception NSException Thrown if _block_ is nil
 @see MER_addPaginatedScrollingView:block:
 */
- (void)MER_addPaginatedScrollingViewWithBlock:(void (^)(MERPaginatedScrollingCompletionBlock completion))block;
/**
 Enables paginated scrolling on the receiver, assigning _view_ as the `MER_paginatedScrollingView` and invoking _block_ whenever paginated scrolling triggers.
 
 @param view The paginated scrolling view that will be assigned to the receiver
 @param block The block that is invoked whenever paginated scrolling is triggered. The block is passed a `MERPaginatedScrollingCompletionBlock` that should be invoked whenever the paginated scrolling operation has completed
 @exception NSException Thrown if _view_ or _block_ are nil
 */
- (void)MER_addPaginatedScrollingView:(UIView<MERPaginatedScrolling> *)view block:(void (^)(MERPaginatedScrollingCompletionBlock completion))block;

/**
 Removes any paginated scrolling view assigned to the receiver.
 */
- (void)MER_removePaginatedScrollingView;

@end
