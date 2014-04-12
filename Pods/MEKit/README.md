##MEKit

A collection of classes that extend the UIKit framework. Compatible with iOS, 7.0+.

###Documentation

The headers are documented. Read them.

###Tests

Nope.

###Headers

* [MEKitMacros.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/MEKitMacros.h), two simple macros that wrap `UI_USER_INTERFACE_IDIOM()` to test for iPhone/iPad

###Categories

* [CAGradientLayer+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/CAGradientLayer%2BMEExtensions.h), convenience method to create a `CAGradientLayer` by providing `UIColor` and `NSNumber` instances of the usual CF types
* [CATransaction+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/CATransaction%2BMEExtensions.h), convenience methods to begin and commit a transaction with animations disabled and an optional completion block
* [UIColor+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/UIColor%2BMEExtensions.h), macros that wrap the various `UIColor` factory methods (e.g. `MEColorRGB(r,g,b)` => `[UIColor colorWithRed:r green:g blue:b alpha:1]`), as well as a method to create `UIColor` instances from hexadecimal strings
* [UIFont+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/UIFont%2BMEExtensions.h), methods to aid in the usage of custom fonts without having to declare them in the app info plist
* [UIImage+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/UIImage%2BMEExtensions.h), methods to retrieve and cache images from a specific bundle, as well as render images with a specific color (like a template) and tint images with a specific color (i.e. `UIButton` darken image on highlight)
* [UITableViewCell+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/UITableViewCell%2BMEExtensions.h), convenience method to give a reuse identifier based on the receiver's class, as well as a wrapper around `systemLayoutSizeFittingSize` that can be used to dynamically size table view cells using autolayout
* [UIView+MEExtensions.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/UIView%2BMEExtensions.h), convenience methods so you adjust one part of a view's frame (x, y, width, height) instead of typing `CGRectMake()` repeatedly, method to recursively enumerate a view's subviews

###Views

* [MEGradientView.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/MEGradientView.h), a light wrapper around `CAGradientLayer`

###View Controllers

* [MESelectedLocalizationViewController.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/MESelectedLocalizationViewController.h), a view controller that wraps the on-the-fly localization support provided by [MEFoundation](https://github.com/MaestroElearning/MEFoundation)

###Other

* [MEAnythingGestureRecognizer.h](https://github.com/MaestroElearning/MEKit/blob/master/MEKit/MEAnythingGestureRecognizer.h), a gesture recognizer subclass that recognizes any sequence of touches as its gesture