##MEReactiveKit

A collection of classes that extend the UIKit framework, built on top of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa). Compatible with iOS, 7.0+.

###Documentation

The headers are documented. Read them.

###Tests

Nope.

###Categories

* [UIScrollView+MERPaginatedScrollingExtensions.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/UIScrollView%2BMERPaginatedScrollingExtensions.h), methods to add paginated scrolling to any `UIScrollView` instance

###Cells

* [MERTableViewCell.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERTableViewCell.h), `UITableViewCell` subclass that will only draw dividers when the cell is visible; also provides `RACSignal` instances that send `highlighted` and `selected` status

###Controls

* [MERTextField](/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERTextField.h), `UITextField` subclass that provides separate edge insets for `text`, `leftView`, and `rightView`
* [MERPickerViewButton.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERPickerViewButton.h), `UIButton` subclass that manages a `UIPickerView` as its `inputView`
* [MERDatePickerViewButton.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERDatePickerViewButton.h), `UIButton` subclass that manages a `UIDatePickerView` as its `inputView`

###Views

* [MERView.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERView.h), `UIView` subclass that provides separator options similar to `UITableViewCell`, but applicable to all four sides
* [MERClockView.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERClockView.h), `UIView` subclass that displays a clock face representing a `NSDate`
* [MERNextPreviousInputAccessoryView.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERNextPreviousInputAccessoryView.h), `UIView` subclass that manages a `UIToolbar` containing next, previous, and done items
* [MERScrollView.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERScrollView.h), `UIScrollView` subclass that provides a gradient fade at the top and bottom of its content
* [MERTextView.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/MERTextView.h), `UITextView` subclass that provides a gradient fade at the top and bottom of its content as well as placeholder options

###View Controllers

* [MERViewController.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/ViewControllers/MERViewController.h), `UIViewController` subclass that provides keyboard related methods as well as methods to manage the receiver's `navigationItem` and update it when appropriate
* [MERSlidingViewController.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/ViewControllers/MERSlidingViewController/MERSlidingViewController.h), `MERViewController` subclass that implements the sliding doors navigation paradigm
* [MERSplitViewController.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/ViewControllers/MERSplitViewController/MERSplitViewController.h), `MERViewController` subclass that implements a container similar to `UISplitViewController`
* [MERWebViewController.h](https://github.com/MaestroElearning/MEReactiveKit/blob/master/MEReactiveKit/ViewControllers/MERWebViewController/MERWebViewController.h), `MERViewController` subclass manages a `UIWebView` instance and provides appropriate toolbar and navigation items