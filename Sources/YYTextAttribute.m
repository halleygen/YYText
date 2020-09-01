//
//  YYTextAttribute.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 14/10/26.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYTextAttribute.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+YYText.h"
#import "YYTextArchiver.h"

NSAttributedStringKey const YYTextBackedStringAttributeName = @"YYTextBackedString";
NSAttributedStringKey const YYTextBindingAttributeName = @"YYTextBinding";
NSAttributedStringKey const YYTextShadowAttributeName = @"YYTextShadow";
NSAttributedStringKey const YYTextInnerShadowAttributeName = @"YYTextInnerShadow";
NSAttributedStringKey const YYTextUnderlineAttributeName = @"YYTextUnderline";
NSAttributedStringKey const YYTextStrikethroughAttributeName = @"YYTextStrikethrough";
NSAttributedStringKey const YYTextBorderAttributeName = @"YYTextBorder";
NSAttributedStringKey const YYTextBackgroundBorderAttributeName = @"YYTextBackgroundBorder";
NSAttributedStringKey const YYTextBlockBorderAttributeName = @"YYTextBlockBorder";
NSAttributedStringKey const YYTextAttachmentAttributeName = @"YYTextAttachment";
NSAttributedStringKey const YYTextHighlightAttributeName = @"YYTextHighlight";
NSAttributedStringKey const YYTextGlyphTransformAttributeName = @"YYTextGlyphTransform";

YYTextToken const YYTextTokenAttachment = @"\uFFFC";
YYTextToken const YYTextTokenTruncationTruncation = @"\u2026";


YYTextAttributeType YYTextAttributeGetType(NSAttributedStringKey attribute){
    if (attribute.length == 0) return YYTextAttributeTypeNone;
    
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary new];
        NSNumber *All = @(YYTextAttributeTypeUIKit | YYTextAttributeTypeCoreText | YYTextAttributeTypeYYText);
        NSNumber *CoreText_YYText = @(YYTextAttributeTypeCoreText | YYTextAttributeTypeYYText);
        NSNumber *UIKit_YYText = @(YYTextAttributeTypeUIKit | YYTextAttributeTypeYYText);
        NSNumber *UIKit_CoreText = @(YYTextAttributeTypeUIKit | YYTextAttributeTypeCoreText);
        NSNumber *UIKit = @(YYTextAttributeTypeUIKit);
        NSNumber *CoreText = @(YYTextAttributeTypeCoreText);
        NSNumber *YYText = @(YYTextAttributeTypeYYText);
        
        dic[NSFontAttributeName] = All;
        dic[NSKernAttributeName] = All;
        dic[NSForegroundColorAttributeName] = UIKit;
        dic[(id)kCTForegroundColorAttributeName] = CoreText;
        dic[(id)kCTForegroundColorFromContextAttributeName] = CoreText;
        dic[NSBackgroundColorAttributeName] = UIKit;
        dic[NSStrokeWidthAttributeName] = All;
        dic[NSStrokeColorAttributeName] = UIKit;
        dic[(id)kCTStrokeColorAttributeName] = CoreText_YYText;
        dic[NSShadowAttributeName] = UIKit_YYText;
        dic[NSStrikethroughStyleAttributeName] = UIKit;
        dic[NSUnderlineStyleAttributeName] = UIKit_CoreText;
        dic[(id)kCTUnderlineColorAttributeName] = CoreText;
        dic[NSLigatureAttributeName] = All;
        dic[(id)kCTSuperscriptAttributeName] = UIKit; //it's a CoreText attribute, but only supported by UIKit...
        dic[NSVerticalGlyphFormAttributeName] = All;
        dic[(id)kCTGlyphInfoAttributeName] = CoreText_YYText;
        dic[(id)kCTRunDelegateAttributeName] = CoreText_YYText;
        dic[(id)kCTBaselineClassAttributeName] = CoreText_YYText;
        dic[(id)kCTBaselineInfoAttributeName] = CoreText_YYText;
        dic[(id)kCTBaselineReferenceInfoAttributeName] = CoreText_YYText;
        dic[(id)kCTWritingDirectionAttributeName] = CoreText_YYText;
        dic[NSParagraphStyleAttributeName] = All;
        
            dic[NSStrikethroughColorAttributeName] = UIKit;
            dic[NSUnderlineColorAttributeName] = UIKit;
            dic[NSTextEffectAttributeName] = UIKit;
            dic[NSObliquenessAttributeName] = UIKit;
            dic[NSExpansionAttributeName] = UIKit;
            dic[(id)kCTLanguageAttributeName] = CoreText_YYText;
            dic[NSBaselineOffsetAttributeName] = UIKit;
            dic[NSWritingDirectionAttributeName] = All;
            dic[NSAttachmentAttributeName] = UIKit;
            dic[NSLinkAttributeName] = UIKit;
        
            dic[(id)kCTRubyAnnotationAttributeName] = CoreText;
        
        dic[YYTextBackedStringAttributeName] = YYText;
        dic[YYTextBindingAttributeName] = YYText;
        dic[YYTextShadowAttributeName] = YYText;
        dic[YYTextInnerShadowAttributeName] = YYText;
        dic[YYTextUnderlineAttributeName] = YYText;
        dic[YYTextStrikethroughAttributeName] = YYText;
        dic[YYTextBorderAttributeName] = YYText;
        dic[YYTextBackgroundBorderAttributeName] = YYText;
        dic[YYTextBlockBorderAttributeName] = YYText;
        dic[YYTextAttachmentAttributeName] = YYText;
        dic[YYTextHighlightAttributeName] = YYText;
        dic[YYTextGlyphTransformAttributeName] = YYText;
    });
    NSNumber *num = dic[attribute];
    if (num != nil) return num.integerValue;
    return YYTextAttributeTypeNone;
}


@implementation YYTextBackedString

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = string;
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.string forKey:@"string"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *string = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"string"];
    return [self initWithString:string];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.string = self.string;
    return one;
}

@end


@implementation YYTextBinding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithDeleteConfirm:(BOOL)deleteConfirm {
    self = [super init];
    if (self) {
        _deleteConfirm = deleteConfirm;
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.deleteConfirm) forKey:@"deleteConfirm"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    BOOL deleteConfirm = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"deleteConfirm"]).boolValue;
    return [self initWithDeleteConfirm:deleteConfirm];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.deleteConfirm = self.deleteConfirm;
    return one;
}

@end


@implementation YYTextShadow

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self = [super init];
    if (self) {
        _color = color;
        _offset = offset;
        _radius = radius;
    }
    return self;
}

- (instancetype)initWithNSShadow:(NSShadow *)nsShadow {
    id color = nsShadow.shadowColor;
    if (color) {
        if (CGColorGetTypeID() == CFGetTypeID((__bridge CFTypeRef)(color))) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        }
    }
    
    return [self initWithColor:color offset:nsShadow.shadowOffset radius:nsShadow.shadowBlurRadius];
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSShadow *)nsShadow {
    NSShadow *shadow = [NSShadow new];
    shadow.shadowOffset = self.offset;
    shadow.shadowBlurRadius = self.radius;
    shadow.shadowColor = self.color;
    return shadow;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:@(self.radius) forKey:@"radius"];
    [aCoder encodeObject:[NSValue valueWithCGSize:self.offset] forKey:@"offset"];
    [aCoder encodeObject:self.subShadow forKey:@"subShadow"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    UIColor *color = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"color"];
    CGFloat radius = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"radius"]).floatValue;
    CGSize offset = ((NSValue *)[aDecoder decodeObjectOfClass:[NSValue class] forKey:@"offset"]).CGSizeValue;
    self = [self initWithColor:color offset:offset radius:radius];
    self.subShadow = [aDecoder decodeObjectOfClass:[YYTextShadow class] forKey:@"subShadow"];
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.color = self.color;
    one.radius = self.radius;
    one.offset = self.offset;
    one.subShadow = self.subShadow.copy;
    return one;
}

@end


@implementation YYTextDecoration

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithStyle:(YYTextLineStyle)style {
    return [self initWithStyle:style width:nil color:nil];
}

- (instancetype)initWithStyle:(YYTextLineStyle)style width:(NSNumber *)width color:(UIColor *)color {
    self = [super init];
    if (self) {
        _style = style;
        _width = width;
        _color = color;
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.style) forKey:@"style"];
    [aCoder encodeObject:self.width forKey:@"width"];
    [aCoder encodeObject:self.color forKey:@"color"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSUInteger style = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"style"]).unsignedIntegerValue;
    NSNumber *width = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"width"];
    UIColor *color = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"color"];
    return [self initWithStyle:style width:width color:color];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.style = self.style;
    one.width = self.width;
    one.color = self.color;
    return one;
}

@end


@implementation YYTextBorder

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithLineStyle:(YYTextLineStyle)lineStyle lineWidth:(CGFloat)width strokeColor:(UIColor *)color {
    self = [super init];
    if (self) {
        _lineStyle = lineStyle;
        _strokeWidth = width;
        _strokeColor = color;
    }
    return self;
}

- (instancetype)initWithFillColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self = [super init];
    if (self) {
        _lineStyle = YYTextLineStyleSingle;
        _fillColor = color;
        _cornerRadius = cornerRadius;
        _insets = UIEdgeInsetsMake(-2, 0, 0, -2);
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.lineStyle) forKey:@"lineStyle"];
    [aCoder encodeObject:@(self.strokeWidth) forKey:@"strokeWidth"];
    [aCoder encodeObject:self.strokeColor forKey:@"strokeColor"];
    [aCoder encodeObject:@(self.lineJoin) forKey:@"lineJoin"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.insets] forKey:@"insets"];
    [aCoder encodeObject:@(self.cornerRadius) forKey:@"cornerRadius"];
    [aCoder encodeObject:self.shadow forKey:@"shadow"];
    [aCoder encodeObject:self.fillColor forKey:@"fillColor"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    _lineStyle = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"lineStyle"]).unsignedIntegerValue;
    _strokeWidth = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"strokeWidth"]).doubleValue;
    _strokeColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"strokeColor"];
    _lineJoin = (CGLineJoin)((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"join"]).unsignedIntegerValue;
    _insets = ((NSValue *)[aDecoder decodeObjectOfClass:[NSValue class] forKey:@"insets"]).UIEdgeInsetsValue;
    _cornerRadius = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"cornerRadius"]).doubleValue;
    _shadow = [aDecoder decodeObjectOfClass: [YYTextShadow class] forKey:@"shadow"];
    _fillColor = [aDecoder decodeObjectOfClass:[UIColor class] forKey:@"fillColor"];
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.lineStyle = self.lineStyle;
    one.strokeWidth = self.strokeWidth;
    one.strokeColor = self.strokeColor;
    one.lineJoin = self.lineJoin;
    one.insets = self.insets;
    one.cornerRadius = self.cornerRadius;
    one.shadow = self.shadow.copy;
    one.fillColor = self.fillColor;
    return one;
}

@end


@implementation YYTextAttachment

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithContent:(id)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:[NSValue valueWithUIEdgeInsets:self.contentInsets] forKey:@"contentInsets"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSSet *contentClasses = [[NSSet alloc] initWithObjects:[UIImage class], [UIView class], [CALayer class], nil];
    id content = [aDecoder decodeObjectOfClasses:contentClasses forKey:@"content"];
    self = [self initWithContent:content];
    if (self) {
        _contentInsets = ((NSValue *)[aDecoder decodeObjectOfClass:[NSValue class] forKey:@"contentInsets"]).UIEdgeInsetsValue;
        _userInfo = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:@"userInfo"];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    if ([self.content respondsToSelector:@selector(copy)]) {
        one.content = [self.content copy];
    } else {
        one.content = self.content;
    }
    one.contentInsets = self.contentInsets;
    one.userInfo = self.userInfo.copy;
    return one;
}

@end


@implementation YYTextHighlight

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes {
    self = [super init];
    if (self) {
        _attributes = attributes.mutableCopy;
    }
    return self;
}

- (instancetype)initWithBackgroundColor:(UIColor *)color {
    YYTextBorder *highlightBorder = [[YYTextBorder alloc] initWithFillColor:color cornerRadius:3];
    highlightBorder.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
    return [self initWithAttributes:@{ YYTextBackgroundBorderAttributeName: highlightBorder }];
}

- (instancetype)init {
    self = [self initWithAttributes:nil];
    return self;
}

- (void)setAttributes:(NSDictionary<NSAttributedStringKey, id> *)attributes {
    _attributes = attributes.mutableCopy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSData *data = [YYTextArchiver archivedDataWithRootObject:self.attributes requiringSecureCoding:YES error:nil];
    [aCoder encodeObject:data forKey:@"attributes"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSData *data = [aDecoder decodeObjectOfClass:[NSData class] forKey:@"attributes"];
    NSDictionary *attributes = [YYTextUnarchiver unarchivedObjectOfClass:[NSDictionary class] fromData:data error:nil];
    if (attributes) {
        return [self initWithAttributes:attributes];
    } else {
        return nil;
    }
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) one = [self.class new];
    one.attributes = self.attributes.mutableCopy;
    return one;
}

- (void)_makeMutableAttributes {
    if (!_attributes) {
        _attributes = [NSMutableDictionary new];
    } else if (![_attributes isKindOfClass:[NSMutableDictionary class]]) {
        _attributes = _attributes.mutableCopy;
    }
}

- (void)setFont:(UIFont *)font {
    [self _makeMutableAttributes];
    if (font == (id)[NSNull null] || font == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = [NSNull null];
    } else {
        CTFontRef ctFont = (__bridge CTFontRef)font;
        if (ctFont) {
            ((NSMutableDictionary *)_attributes)[(id)kCTFontAttributeName] = (__bridge id)(ctFont);
            CFRelease(ctFont);
        }
    }
}

- (void)setColor:(UIColor *)color {
    [self _makeMutableAttributes];
    if (color == (id)[NSNull null] || color == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = [NSNull null];
        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTForegroundColorAttributeName] = (__bridge id)(color.CGColor);
        ((NSMutableDictionary *)_attributes)[NSForegroundColorAttributeName] = color;
    }
}

- (void)setStrokeWidth:(NSNumber *)width {
    [self _makeMutableAttributes];
    if (width == (id)[NSNull null] || width == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeWidthAttributeName] = width;
    }
}

- (void)setStrokeColor:(UIColor *)color {
    [self _makeMutableAttributes];
    if (color == (id)[NSNull null] || color == nil) {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = [NSNull null];
        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = [NSNull null];
    } else {
        ((NSMutableDictionary *)_attributes)[(id)kCTStrokeColorAttributeName] = (__bridge id)(color.CGColor);
        ((NSMutableDictionary *)_attributes)[NSStrokeColorAttributeName] = color;
    }
}

- (void)setTextAttribute:(NSString *)attribute value:(id)value {
    [self _makeMutableAttributes];
    if (value == nil) value = [NSNull null];
    ((NSMutableDictionary *)_attributes)[attribute] = value;
}

- (void)setShadow:(YYTextShadow *)shadow {
    [self setTextAttribute:YYTextShadowAttributeName value:shadow];
}

- (void)setInnerShadow:(YYTextShadow *)shadow {
    [self setTextAttribute:YYTextInnerShadowAttributeName value:shadow];
}

- (void)setUnderline:(YYTextDecoration *)underline {
    [self setTextAttribute:YYTextUnderlineAttributeName value:underline];
}

- (void)setStrikethrough:(YYTextDecoration *)strikethrough {
    [self setTextAttribute:YYTextStrikethroughAttributeName value:strikethrough];
}

- (void)setBackgroundBorder:(YYTextBorder *)border {
    [self setTextAttribute:YYTextBackgroundBorderAttributeName value:border];
}

- (void)setBorder:(YYTextBorder *)border {
    [self setTextAttribute:YYTextBorderAttributeName value:border];
}

- (void)setAttachment:(YYTextAttachment *)attachment {
    [self setTextAttribute:YYTextAttachmentAttributeName value:attachment];
}

@end

