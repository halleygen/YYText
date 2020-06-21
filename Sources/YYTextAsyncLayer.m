//
//  YYTextAsyncLayer.m
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/4/11.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYTextAsyncLayer.h"
#import <stdatomic.h>

static dispatch_queue_t YYTextAsyncLayerGetReleaseQueue() {
    return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
}

@interface YYTextAsyncLayer ()

/// Global display queue, used for content rendering.
@property (nonnull, class, nonatomic, readonly) dispatch_queue_t displayQueue;
@property (nullable, nonatomic, readwrite) UIGraphicsImageRenderer *renderer;

@end


/// a thread safe incrementing counter.
@interface _YYTextSentinel : NSObject
/// Returns the current value of the counter.
@property (atomic, readonly) _Atomic(int) value;
/// Increase the value atomically. @return The new value.
- (_Atomic(int))increase;
@end

@implementation _YYTextSentinel {
    _Atomic(int) _value;
}
- (int)value {
    return _value;
}
- (_Atomic(int))increase {
    return atomic_fetch_add_explicit(&_value, 1, memory_order_relaxed);
}
@end


@implementation YYTextAsyncLayerDisplayTask
@end


@implementation YYTextAsyncLayer {
    _YYTextSentinel *_sentinel;
}

#pragma mark - Queue

+ (nonnull dispatch_queue_t)displayQueue {
    #define MAX_QUEUE_COUNT 16
        static int queueCount;
        static dispatch_queue_t queues[MAX_QUEUE_COUNT];
        static dispatch_once_t onceToken;
        static _Atomic(int) counter = 0;
    
        dispatch_once(&onceToken, ^{
            queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
            queueCount = MIN(MAX(queueCount, 1), MAX_QUEUE_COUNT);
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.ibireme.text.render", attr);
            }
            
        });

        _Atomic(int) cur = atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
        return queues[(cur) % queueCount];
    #undef MAX_QUEUE_COUNT
}

#pragma mark - Override

+ (id)defaultValueForKey:(NSString *)key {
    if ([key isEqualToString:@"displaysAsynchronously"]) {
        return @(YES);
    } else {
        return [super defaultValueForKey:key];
    }
}

- (instancetype)init {
    self = [super init];
    static CGFloat scale; //global
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    _sentinel = [_YYTextSentinel new];
    _displaysAsynchronously = YES;
    return self;
}

- (void)dealloc {
    [_sentinel increase];
}

- (void)setNeedsDisplay {
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display {
    super.contents = super.contents;
    [self _displayAsync:_displaysAsynchronously];
}

#pragma mark - Renderer

- (nonnull UIGraphicsImageRenderer *)_getRendererForSize:(CGSize)size isOpaque:(BOOL)isOpaque {
    UIGraphicsImageRendererFormat *format = self.renderer.format;
    if (self.renderer && format) {
        if (format.opaque == isOpaque && CGSizeEqualToSize(format.bounds.size, size)) {
            return self.renderer;
        }
    }
    
    format = [UIGraphicsImageRendererFormat preferredFormat];
    format.opaque = isOpaque;
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    self.renderer = renderer;
    return renderer;
}

#pragma mark - Private

- (void)_displayAsync:(BOOL)async {
    __strong id<YYTextAsyncLayerDelegate> delegate = (id)self.delegate;
    YYTextAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    if (!task.display) {
        if (task.willDisplay) task.willDisplay(self);
        self.contents = nil;
        if (task.didDisplay) task.didDisplay(self, YES);
        return;
    }
    
    if (async) {
        if (task.willDisplay) task.willDisplay(self);
        _YYTextSentinel *sentinel = _sentinel;
        int32_t value = sentinel.value;
        BOOL (^isCancelled)(void) = ^BOOL() {
            return value != sentinel.value;
        };
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(YYTextAsyncLayerGetReleaseQueue(), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay) task.didDisplay(self, YES);
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(YYTextAsyncLayer.displayQueue, ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            UIImage *image = [self renderTask:task inSize:size opaque:opaque backgroundColor:backgroundColor isCancelled:isCancelled];
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) task.didDisplay(self, NO);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplay) task.didDisplay(self, NO);
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplay) task.didDisplay(self, YES);
                }
            });
        });
    } else {
        [_sentinel increase];
        if (task.willDisplay) task.willDisplay(self);
        UIImage *image = [self renderTask:task inSize:self.bounds.size opaque:self.opaque backgroundColor:self.backgroundColor isCancelled:^{return NO;}];
        self.contents = (__bridge id)(image.CGImage);
        if (task.didDisplay) task.didDisplay(self, YES);
    }
}

- (nonnull UIImage *)renderTask:(YYTextAsyncLayerDisplayTask *)task inSize:(CGSize)size opaque:(BOOL)isOpaque backgroundColor:(CGColorRef)backgroundColor isCancelled:(BOOL(^)(void))isCancelled {
    UIGraphicsImageRenderer *renderer = [self _getRendererForSize:size isOpaque:isOpaque];
    return [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        if (isOpaque) {
            CGRect backgroundRect = CGRectMake(0, 0, size.width, size.height);
            if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                [UIColor.whiteColor setFill];
                [rendererContext fillRect:backgroundRect];
            }
            
            if (backgroundColor) {
                [[[UIColor alloc] initWithCGColor:backgroundColor] setFill];
                [rendererContext fillRect:backgroundRect];
            }
            CGColorRelease(backgroundColor);
        }
        task.display(rendererContext.CGContext, size, isCancelled);
    }];
}

- (void)_cancelAsyncDisplay {
    [_sentinel increase];
}

@end
