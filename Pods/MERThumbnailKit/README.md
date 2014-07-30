##MERThumbnailKit

A library for generating thumbnails from urls, both local and remote. Built on top of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), compatible with iOS/OSX, 7.0+/10.9+.

Use the `thumbnailForURL:size:page:time:` method and its variants to generate thumbnails for a given url.

The library can also download files and cache them locally. See the `downloadFileWithURL:progress:` method for more information.

###Documentation

The headers are documented. Read them.

###Tests

Soon.

##Supported Formats

The library supports the following UTIs:

* **kUTTypeImage** (public.image)
* **kUTTypeMovie** (public.movie)
* **kUTTypePDF** (com.adobe.pdf)
* kUTTypeRTF (public.rtf)
* kUTTypeRTFD (com.apple.rtfd)
* kUTTypePlainText (public.plain-text)
* **kUTTypeHTML** (public.html)

Additionally, it supports the following file extensions:

* Word (.doc, .docx)
* Powerpoint (.ppt, .pptx)
* Excel (.xls, .xlsx)
* CSV (.csv)

*UTIs that are* **bolded** *indicate local and remote thumbnail generation is supported for that UTI.*

##Demo

The demo will load up anything it finds in a directory named "Files" within the main bundle. It creates and displays the thumbnails within a `UICollectionView` or `NSTableView`.