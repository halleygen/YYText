//
//  YYTextInput.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/4/17.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYTextInput.h"
#import "YYTextUtilities.h"


@implementation YYTextPosition

- (instancetype)initWithOffset:(NSInteger)offset {
    return [self initWithOffset:offset affinity:YYTextAffinityForward];
}

- (instancetype)initWithOffset:(NSInteger)offset affinity:(YYTextAffinity)affinity {
    self = [super init];
    self->_offset = offset;
    self->_affinity = affinity;
    return self;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class alloc] initWithOffset:_offset affinity:_affinity];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@%@)", self.class, self, @(_offset), _affinity == YYTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return _offset * 2 + (_affinity == YYTextAffinityForward ? 1 : 0);
}

- (BOOL)isEqual:(YYTextPosition *)object {
    if (!object) return NO;
    return _offset == object.offset && _affinity == object.affinity;
}

- (NSComparisonResult)compare:(YYTextPosition *)otherPosition {
    if (!otherPosition) return NSOrderedAscending;
    if (_offset < otherPosition.offset) return NSOrderedAscending;
    if (_offset > otherPosition.offset) return NSOrderedDescending;
    if (_affinity == YYTextAffinityBackward && otherPosition.affinity == YYTextAffinityForward) return NSOrderedAscending;
    if (_affinity == YYTextAffinityForward && otherPosition.affinity == YYTextAffinityBackward) return NSOrderedDescending;
    return NSOrderedSame;
}

@end



@implementation YYTextRange {
    YYTextPosition *_start;
    YYTextPosition *_end;
}

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithRange:(NSRange)range {
    return [self initWithRange:range affinity:YYTextAffinityForward];
}

- (instancetype)initWithRange:(NSRange)range affinity:(YYTextAffinity)affinity {
    YYTextPosition *start = [[YYTextPosition alloc] initWithOffset:range.location affinity:affinity];
    YYTextPosition *end = [[YYTextPosition alloc] initWithOffset:range.location + range.length affinity:affinity];
    return [self initWithStart:start end:end];
}

- (instancetype)initWithStart:(YYTextPosition *)start end:(YYTextPosition *)end {
    if (!start || !end) return nil;
    if ([start compare:end] == NSOrderedDescending) {
        YYTEXT_SWAP(start, end);
    }
    self = [super init];
    _start = start;
    _end = end;
    return self;
}

+ (instancetype)defaultRange {
    return [[YYTextRange alloc] initWithStart:[[YYTextPosition alloc] initWithOffset:0] end:[[YYTextPosition alloc] initWithOffset:0]];
}

- (YYTextPosition *)start {
    return _start;
}

- (YYTextPosition *)end {
    return _end;
}

- (BOOL)isEmpty {
    return _start.offset == _end.offset;
}

- (NSRange)asRange {
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class alloc] initWithStart:_start end:_end];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> (%@, %@)%@", self.class, self, @(_start.offset), @(_end.offset - _start.offset), _end.affinity == YYTextAffinityForward ? @"F":@"B"];
}

- (NSUInteger)hash {
    return (sizeof(NSUInteger) == 8 ? OSSwapInt64(_start.hash) : OSSwapInt32(_start.hash)) + _end.hash;
}

- (BOOL)isEqual:(YYTextRange *)object {
    if (!object) return NO;
    return [_start isEqual:object.start] && [_end isEqual:object.end];
}

@end



@implementation YYTextSelectionRect

@synthesize rect = _rect;
@synthesize writingDirection = _writingDirection;
@synthesize containsStart = _containsStart;
@synthesize containsEnd = _containsEnd;
@synthesize isVertical = _isVertical;

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    YYTextSelectionRect *one = [self.class new];
    one.rect = _rect;
    one.writingDirection = _writingDirection;
    one.containsStart = _containsStart;
    one.containsEnd = _containsEnd;
    one.isVertical = _isVertical;
    return one;
}

@end
