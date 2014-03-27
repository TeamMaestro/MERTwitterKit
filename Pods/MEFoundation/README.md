##MEFoundation

A collection of classes that extend the Foundation framework. Compatible with iOS/OSX, 7.0+/10.9+.

###Documentation

The headers are documented. Read them.

###Tests

There are tests for the `NSString` related methods.

###Headers

* [MEDebugging.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/MEDebugging.h), debugging related macros and a function for timing blocks
* [MEFunctions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/MEFunctions.h), wrappers around `dispatch_async()` and `dispatch_sync()`
* [MEGeometry.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/MEGeometry.h), functions for dealing with CGRect
* [MEMacros.h](http://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/MEMacros.h), macros wrapping `__weak`, and `__unsafe_unretained` declarations

###Categories

* [NSArray+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSArray%2BMEExtensions.h), methods to create `NSSet` or `NSMutableSet` from the receiver, method to create a shuffled array
* [NSMutableArray+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSMutableArray%2BMEExtensions.h), methods to remove the first object or shuffle the receiver
* [NSBundle+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSBundle%2BMEExtensions.h), properties to access common keys in the info plist (identifier, display name, executable name, short version string, and version)
* [NSData+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSData%2BMEExtensions.h), methods to create MD5, SHA1, and SHA512 hashes of the receiver
* [NSDate+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSDate%2BMEExtensions.h), wrapers around the various `NSCalendar` date methods, methods to get start/end of day/week/month
* [NSFileManager+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSFileManager%2BMEExtensions.h), property to get the application support directory url and create if it does not already exist
* [NSObject+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSObject%2BMEExtensions.h), property to attach a represented object to an arbitrary instance (similar to the `representedObject` and `setRepresentedObject:` methods on `NSCell`)
* [NSObject+MELocalizationExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSObject%2BMELocalizationExtensions.h), macros and methods for managing localization switching while the app is running
* [NSSet+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSSet%2BMEExtensions.h), methods to create an `NSArray` or `NSMutableArray` from the receiver
* [NSString+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSString%2BMEExtensions.h), various string manipulation methods
* [NSURL+MEExtensions.h](https://github.com/MaestroElearning/MEFoundation/blob/master/MEFoundation/NSURL%2BMEExtensions.h), methods to access various `NSURL` related keys