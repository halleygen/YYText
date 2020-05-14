//
//  YYTextArchiver.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/3/16.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYTextArchiver.h"
#import "YYTextRunDelegate.h"
#import "YYTextRubyAnnotation.h"

/**
 When call CTRunDelegateGetTypeID() on some devices (runs iOS6), I got the error:
 "dyld: lazy symbol binding failed: Symbol not found: _CTRunDelegateGetTypeID"
 
 Here's a workaround for this issue.
 */
static CFTypeID CTRunDelegateTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
        if ((long)CTRunDelegateGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRunDelegateGetTypeID();
        }
         */
        YYTextRunDelegate *delegate = [YYTextRunDelegate new];
        CTRunDelegateRef ref = delegate.CTRunDelegate;
        typeID = CFGetTypeID(ref);
        CFRelease(ref);
    });
    return typeID;
}

static CFTypeID CTRubyAnnotationTypeID() {
    static CFTypeID typeID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((long)CTRubyAnnotationGetTypeID + 1 > 1) { //avoid compiler optimization
            typeID = CTRubyAnnotationGetTypeID();
        } else {
            typeID = kCFNotFound;
        }
    });
    return typeID;
}

/**
 A wrapper for CGColorRef. Used for Archive/Unarchive/Copy.
 */
@interface _YYCGColor : NSObject <NSCopying, NSSecureCoding>
@property (nonatomic, assign) CGColorRef CGColor;
+ (instancetype)colorWithCGColor:(CGColorRef)CGColor;
@end

@implementation _YYCGColor

+ (BOOL) supportsSecureCoding {
    return YES;
}

+ (instancetype)colorWithCGColor:(CGColorRef)CGColor {
    _YYCGColor *color = [self new];
    color.CGColor = CGColor;
    return color;
}

- (void)setCGColor:(CGColorRef)CGColor {
    if (_CGColor != CGColor) {
        if (CGColor) CGColor = (CGColorRef)CFRetain(CGColor);
        if (_CGColor) CFRelease(_CGColor);
        _CGColor = CGColor;
    }
}

- (void)dealloc {
    if (_CGColor) CFRelease(_CGColor);
    _CGColor = NULL;
}

- (id)copyWithZone:(NSZone *)zone {
    _YYCGColor *color = [self.class new];
    color.CGColor = self.CGColor;
    return color;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIColor *color = [UIColor colorWithCGColor:_CGColor];
    [aCoder encodeObject:color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIColor *color = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"color"];
    self.CGColor = color.CGColor;
    return self;
}

@end

/**
 A wrapper for CGImageRef. Used for Archive/Unarchive/Copy.
 */
@interface _YYCGImage : NSObject <NSSecureCoding, NSCopying>
@property (nonatomic, assign) CGImageRef CGImage;
+ (instancetype)imageWithCGImage:(CGImageRef)CGImage;
@end

@implementation _YYCGImage

+ (BOOL) supportsSecureCoding {
    return YES;
}

+ (instancetype)imageWithCGImage:(CGImageRef)CGImage {
    _YYCGImage *image = [self new];
    image.CGImage = CGImage;
    return image;
}

- (void)setCGImage:(CGImageRef)CGImage {
    if (_CGImage != CGImage) {
        if (CGImage) CGImage = (CGImageRef)CFRetain(CGImage);
        if (_CGImage) CFRelease(_CGImage);
        _CGImage = CGImage;
    }
}

- (void)dealloc {
    if (_CGImage) CFRelease(_CGImage);
}

- (id)copyWithZone:(NSZone *)zone {
    _YYCGImage *image = [self.class new];
    image.CGImage = self.CGImage;
    return image;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    UIImage *image = [UIImage imageWithCGImage:_CGImage];
    [aCoder encodeObject:image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    UIImage *image = [aDecoder decodeObjectOfClass:[UIImage class] forKey:@"image"];
    self.CGImage = image.CGImage;
    return self;
}

@end


@implementation YYTextArchiver

- (instancetype)initRequiringSecureCoding:(BOOL)requiresSecureCoding {
    self = [super initRequiringSecureCoding:requiresSecureCoding];
    self.delegate = self;
    return self;
}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object {
    CFTypeID typeID = CFGetTypeID((CFTypeRef)object);
    if (typeID == CTRunDelegateTypeID()) {
        CTRunDelegateRef runDelegate = (__bridge CFTypeRef)(object);
        id ref = CTRunDelegateGetRefCon(runDelegate);
        if (ref) return ref;
    } else if (typeID == CTRubyAnnotationTypeID()) {
        CTRubyAnnotationRef ctRuby = (__bridge CFTypeRef)(object);
        YYTextRubyAnnotation *ruby = [YYTextRubyAnnotation rubyWithCTRubyRef:ctRuby];
        if (ruby) return ruby;
    } else if (typeID == CGColorGetTypeID()) {
        return [_YYCGColor colorWithCGColor:(CGColorRef)object];
    } else if (typeID == CGImageGetTypeID()) {
        return [_YYCGImage imageWithCGImage:(CGImageRef)object];
    }
    return object;
}

@end


@implementation YYTextUnarchiver

- (BOOL)requiresSecureCoding {
    // Need to work out how to support encoding NSAttributedStrings with custom attributes. Currently only UIColors, NSParagraphStyles, UIFonts, and other objects associated with UIKit NSAttributedStringKeys can be decoded securely. An exception is raised when a YYText object is decoded.
    return NO;
}

- (instancetype)initForReadingFromData:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    self = [super initForReadingFromData:data error:error];
    self.delegate = self;
    return self;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object {
    if ([object class] == [YYTextRunDelegate class]) {
        YYTextRunDelegate *runDelegate = object;
        CTRunDelegateRef ct = runDelegate.CTRunDelegate;
        id ctObj = (__bridge id)ct;
        if (ct) CFRelease(ct);
        return ctObj;
    } else if ([object class] == [YYTextRubyAnnotation class]) {
        YYTextRubyAnnotation *ruby = object;
        CTRubyAnnotationRef ct = ruby.CTRubyAnnotation;
        id ctObj = (__bridge id)(ct);
        if (ct) CFRelease(ct);
        return ctObj;
    } else if ([object class] == [_YYCGColor class]) {
        _YYCGColor *color = object;
        return (id)color.CGColor;
    } else if ([object class] == [_YYCGImage class]) {
        _YYCGImage *image = object;
        return (id)image.CGImage;
    }
    return object;
}

@end
