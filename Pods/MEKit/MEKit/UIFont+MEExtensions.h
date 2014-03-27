//
//  UIFont+MEExtensions.h
//  MEKit
//
//  Created by William Towe on 2/6/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface UIFont (MEExtensions)

/**
 Returns the directory url for the directory containing custom fonts.
 
 By default, this returns `[[NSBundle mainBundle] URLForResource:@"Fonts" withExtension:nil]`.
 */
+ (NSURL *)ME_fontsDirectoryURL;
/**
 Sets the directory url for the directory containing custom fonts.
 
 This must be set before the first call to `ME_fontWithName:size:`.
 
 @param fontsDirectoryURL The url for the directory of fonts you want loaded
 @warning *NOTE:* passing nil will clear any custom values and use the default value from `ME_fontsDirectoryURL`
 */
+ (void)ME_setFontsDirectoryURL:(NSURL *)fontsDirectoryURL;

/**
 Calls through to `fontWithName:size:`, but first any fonts found in the directory url returned by `ME_fontsDirectoryURL` are registered using `CTFontManagerRegisterGraphicsFont()`.
 
 This eliminates the need to list all custom fonts in the app info plist. Instead place them in a directory inside the app bundle ("Fonts" is the default directory name) and they will be registered the first time this method is called.
 
 @param fontName The name of the font (e.g. `@"Helvetica-Neue"`)
 @param size The size of the font
 @return The font with _fontName_ of _size_
 */
+ (UIFont *)ME_fontWithName:(NSString *)fontName size:(CGFloat)size;

@end
