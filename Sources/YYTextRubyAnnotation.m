//
//  YYTextRubyAnnotation.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/4/24.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYTextRubyAnnotation.h"

@implementation YYTextRubyAnnotation

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithCTRubyRef:(CTRubyAnnotationRef)ctRuby {
    if (!ctRuby) return nil;
    self = [super init];
    if (self) {
        _alignment = CTRubyAnnotationGetAlignment(ctRuby);
        _overhang = CTRubyAnnotationGetOverhang(ctRuby);
        _sizeFactor = CTRubyAnnotationGetSizeFactor(ctRuby);
        _textBefore = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionBefore));
        _textAfter = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionAfter));
        _textInterCharacter = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInterCharacter));
        _textInline = (__bridge NSString *)(CTRubyAnnotationGetTextForPosition(ctRuby, kCTRubyPositionInline));
    }
    return self;
}

- (CTRubyAnnotationRef)CTRubyAnnotation CF_RETURNS_RETAINED {
    if (((long)CTRubyAnnotationCreate + 1) == 1) return NULL; // system not support
    
    CFStringRef text[kCTRubyPositionCount];
    text[kCTRubyPositionBefore] = (__bridge CFStringRef)(_textBefore);
    text[kCTRubyPositionAfter] = (__bridge CFStringRef)(_textAfter);
    text[kCTRubyPositionInterCharacter] = (__bridge CFStringRef)(_textInterCharacter);
    text[kCTRubyPositionInline] = (__bridge CFStringRef)(_textInline);
    CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(_alignment, _overhang, _sizeFactor, text);
    return ruby;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YYTextRubyAnnotation *one = [self.class new];
    one.alignment = _alignment;
    one.overhang = _overhang;
    one.sizeFactor = _sizeFactor;
    one.textBefore = _textBefore;
    one.textAfter = _textAfter;
    one.textInterCharacter = _textInterCharacter;
    one.textInline = _textInline;
    return one;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_alignment) forKey:@"alignment"];
    [aCoder encodeObject:@(_overhang) forKey:@"overhang"];
    [aCoder encodeObject:@(_sizeFactor) forKey:@"sizeFactor"];
    [aCoder encodeObject:_textBefore forKey:@"textBefore"];
    [aCoder encodeObject:_textAfter forKey:@"textAfter"];
    [aCoder encodeObject:_textInterCharacter forKey:@"textInterCharacter"];
    [aCoder encodeObject:_textInline forKey:@"textInline"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    _alignment = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"alignment"]).intValue;
    _overhang = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"overhang"]).intValue;
    _sizeFactor = ((NSNumber *)[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"sizeFactor"]).intValue;
    _textBefore = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"textBefore"];
    _textAfter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"textAfter"];
    _textInterCharacter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"textInterCharacter"];
    _textInline = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"textInline"];
    return self;
}

@end
