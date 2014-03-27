//
//  NSObject+MELocalizationExtensions.h
//  MEFoundation
//
//  Created by William Towe on 8/13/13.
//  Copyright (c) 2013 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 The equivalent of `NSLocalizedString()`.
 
 This calls through to `ME_localizedStringForKey:value:table:`.
 */
#define MELocalizedString(key,comment) \
    [[NSBundle mainBundle] ME_localizedStringForKey:(key) value:@"" table:nil]

/**
 The equivalent of `NSLocalizedStringFromTable()`.
 
 This calls through to `ME_localizedStringForKey:value:table:`.
 */
#define MELocalizedStringFromTable(key,tableName,comment) \
    [[NSBundle mainBundle] ME_localizedStringForKey:(key) value:@"" table:(tableName)]

/**
 The equivalent of `NSLocalizedStringFromTableInBundle()`.
 
 This calls through to `ME_localizedStringForKey:value:table:`.
 */
#define MELocalizedStringFromTableInBundle(key,tableName,bundle,comment) \
    [bundle ME_localizedStringForKey:(key) value:@"" table:(tableName)]

/**
 Calls through to `ME_localizedURLForResource:withExtension:subdirectory:localization:`.
 */
#define MELocalizedURLForResourceWithExtension(resource,extension) \
    [[NSBundle mainBundle] ME_localizedURLForResource:(resource) withExtension:(extension) subdirectory:@"" localization:[NSObject ME_selectedLocalization]]

/**
 Calls through to `ME_localizedURLForResource:withExtension:subdirectory:localization:`.
 */
#define MELocalizedURLForResourceWithExtensionInBundle(resource,extension,bundle) \
    [bundle ME_localizedURLForResource:(resource) withExtension:(extension) subdirectory:@"" localization:[NSObject ME_selectedLocalization]]

/**
 The user defaults key which is used to store the selected localization.
 */
extern NSString *const MELocalizationUserDefaultsKeySelectedLocalization;

/**
 The notification that gets posted whenever `ME_setSelectedLocalization:` is called.
 
 The notification contains a userInfo dictionary with the following key/value pairs:
 
 - `MELocalizationUserInfoKeySelectedLocalization` => The currently selected localization (e.g. `@"en"`)
 - `MELocalizationUserInfoKeySelectedLocalizationDisplayName` => The display name for the currently selected localization (e.g. `@"English"`)
 */
extern NSString *const MELocalizationNotificationSelectedLocalizationDidChange;
extern NSString *const MELocalizationUserInfoKeySelectedLocalization;
extern NSString *const MELocalizationUserInfoKeySelectedLocalizationDisplayName;

@interface NSObject (MELocalizationExtensions)

/**
 Returns the default localization (e.g. `@"en"`).
 
 Calls `[NSLocale preferredLanguages].firstObject`.
 
 @return The default localization
 */
+ (NSString *)ME_defaultLocalization;

/**
 Returns the selected localization if there is one, otherwise returns `ME_defaultLocalization`.
 
 @return The selected localization
 */
+ (NSString *)ME_selectedLocalization;
/**
 Sets the selected localization using the `MELocalizationUserDefaultsKeySelectedLocalization` user defaults key.
 
 Passing nil will clear the selected localization.
 
 @param selectedLocalization the localization to set (e.g. `@"en"`)
 */
+ (void)ME_setSelectedLocalization:(NSString *)selectedLocalization;

/**
 Returns the display name for selected localization (e.g. `@"English"`).
 
 @return The display name for the selected localization
 */
+ (NSString *)ME_displayNameForSelectedLocalization;

@end

@interface NSBundle (MELocalizationExtensions)

/**
 Returns the localized string for _key_ just as `localizedStringForKey:value:table:` would, except that preference is given to the localization returned from `ME_selectedLocalization`.
 
 @param key The key
 @param value The default value
 @param tableName The strings table name
 @return The localized string
 @see localizedStringForKey:value:table:
 */
- (NSString *)ME_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

/**
 Returns the localized url for the resource _name_ with _extension_ in _subdirectory_ with _localization_.
 
 Similar to `URLForResource:withExtension:subdirectory:`, except that preference is given to localization _localizationName_.
 
 @param name The name of the resource without the file extension
 @param extension The file extension of the resource
 @param subpath The subdirectory containing the resource
 @param localizationName The localization name to search for first
 @return The localized url
 */
- (NSURL *)ME_localizedURLForResource:(NSString *)name withExtension:(NSString *)extension subdirectory:(NSString *)subpath localization:(NSString *)localizationName;

@end
