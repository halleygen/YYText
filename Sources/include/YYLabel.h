//
//  YYLabel.h
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYText/YYText.h>)
#import <YYText/YYTextParser.h>
#import <YYText/YYTextLayout.h>
#import <YYText/YYTextAttribute.h>
#else
#import "YYTextParser.h"
#import "YYTextLayout.h"
#import "YYTextAttribute.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 The YYLabel class implements a read-only text view.
 
 @discussion The API and behavior is similar to UILabel, but provides more features:
 
 * It supports asynchronous layout and rendering (to avoid blocking UI thread).
 * It extends the CoreText attributes to support more text effects.
 * It allows to add UIImage, UIView and CALayer as text attachments.
 * It allows to add 'highlight' link to some range of text to allow user interact with.
 * It allows to add container path and exclusion paths to control text container's shape.
 * It supports vertical form layout to display CJK text.
 
 See NSAttributedString+YYText.h for more convenience methods to set the attributes.
 See YYTextAttribute.h and YYTextLayout.h for more information.
 */
@interface YYLabel : UIView <NSCoding, UIContentSizeCategoryAdjusting>

#pragma mark - Accessing the Text Attributes
///=============================================================================
/// @name Accessing the Text Attributes
///=============================================================================

/**
 The text displayed by the label. Default is nil.
 Set a new value to this property also replaces the text in `attributedText`.
 Get the value returns the plain text in `attributedText`.
 */
@property (nullable, nonatomic, copy) NSString *text;

/**
 The font of the text. Default is 17-point system font.
 Set a new value to this property also causes the new font to be applied to the entire `attributedText`.
 Get the value returns the font at the head of `attributedText`.
 */
@property (null_resettable, nonatomic, strong) UIFont *font;

/**
 The color of the text. Default is black.
 Set a new value to this property also causes the new color to be applied to the entire `attributedText`.
 Get the value returns the color at the head of `attributedText`.
 */
@property (null_resettable, nonatomic, strong) UIColor *textColor;

/**
 The shadow color of the text. Default is nil.
 Set a new value to this property also causes the shadow color to be applied to the entire `attributedText`.
 Get the value returns the shadow color at the head of `attributedText`.
 */
@property (nullable, nonatomic, strong) UIColor *shadowColor;

/**
 The shadow offset of the text. Default is CGSizeZero.
 Set a new value to this property also causes the shadow offset to be applied to the entire `attributedText`.
 Get the value returns the shadow offset at the head of `attributedText`.
 */
@property (nonatomic) CGSize shadowOffset;

/**
 The shadow blur of the text. Default is 0.
 Set a new value to this property also causes the shadow blur to be applied to the entire `attributedText`.
 Get the value returns the shadow blur at the head of `attributedText`.
 */
@property (nonatomic) CGFloat shadowBlurRadius;

/**
 The technique to use for aligning the text. Default is NSTextAlignmentNatural.
 Set a new value to this property also causes the new alignment to be applied to the entire `attributedText`.
 Get the value returns the alignment at the head of `attributedText`.
 */
@property (nonatomic) NSTextAlignment textAlignment;

/**
 The text vertical aligmnent in container. Default is YYTextVerticalAlignmentCenter.
 */
@property (nonatomic) YYTextVerticalAlignment textVerticalAlignment;

/**
 The styled text displayed by the label.
 Set a new value to this property also replaces the value of the `text`, `font`, `textColor`,
 `textAlignment` and other properties in label.
 
 @discussion It only support the attributes declared in CoreText and YYTextAttribute.
 See `NSAttributedString+YYText` for more convenience methods to set the attributes.
 */
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;

/**
 The technique to use for wrapping and truncating the label's text.
 Default is NSLineBreakByTruncatingTail.
 */
@property (nonatomic) NSLineBreakMode lineBreakMode;

/**
 The truncation token string used when text is truncated. Default is nil.
 When the value is nil, the label use "…" as default truncation token.
 */
@property (nullable, nonatomic, copy) NSAttributedString *truncationToken;

/**
 The maximum number of lines to use for rendering text. Default value is 1.
 0 means no limit.
 */
@property (nonatomic) NSInteger numberOfLines;

/**
 When `text` or `attributedText` is changed, the parser will be called to modify the text.
 It can be used to add code highlighting or emoticon replacement to text view. 
 The default value is nil.
 
 See `YYTextParser` protocol for more information.
 */
@property (nullable, nonatomic, strong) id<YYTextParser> textParser;

/**
 The current text layout in text view. It can be used to query the text layout information.
 Set a new value to this property also replaces most properties in this label, such as `text`,
 `color`, `attributedText`, `lineBreakMode`, `textContainerPath`, `exclusionPaths` and so on.
 */
@property (nullable, nonatomic, strong) YYTextLayout *textLayout;


#pragma mark - Configuring the Text Container
///=============================================================================
/// @name Configuring the Text Container
///=============================================================================

/**
 A UIBezierPath object that specifies the shape of the text frame. Default value is nil.
 */
@property (nullable, nonatomic, copy) UIBezierPath *textContainerPath;

/**
 An array of UIBezierPath objects representing the exclusion paths inside the
 receiver's bounding rectangle. Default value is nil.
 */
@property (nullable, nonatomic, copy) NSArray<UIBezierPath *> *exclusionPaths;

/**
 The inset of the text container's layout area within the text view's content area.
 Default value is UIEdgeInsetsZero.
 */
@property (nonatomic) UIEdgeInsets textContainerInset;

/**
 Whether the receiver's layout orientation is vertical form. Default is NO.
 It may used to display CJK text.
 */
@property (nonatomic, getter=isVerticalForm) BOOL verticalForm;

/**
 The text line position modifier used to modify the lines' position in layout.
 Default value is nil.
 See `YYTextLinePositionModifier` protocol for more information.
 */
@property (nullable, nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;

/**
 The debug option to display CoreText layout result.
 The default value is [YYTextDebugOption sharedDebugOption].
 */
@property (nullable, nonatomic, copy) YYTextDebugOption *debugOption;


#pragma mark - Getting the Layout Constraints
///=============================================================================
/// @name Getting the Layout Constraints
///=============================================================================

/**
 The preferred maximum width (in points) for a multiline label.
 
 @discussion This property affects the size of the label when layout constraints 
     are applied to it. During layout, if the text extends beyond the width 
     specified by this property, the additional text is flowed to one or more new 
     lines, thereby increasing the height of the label. If the text is vertical 
     form, this value will match to text height.
 */
@property (nonatomic) CGFloat preferredMaxLayoutWidth;

# pragma mark - UIContentSizeCategoryAdjusting

/*!
Indicates whether the corresponding element should automatically update its font when the device’s UIContentSizeCategory is changed.

 @discussion For this property to take effect, the element’s font must be one of the following:
 
 - a font vended using +preferredFontForTextStyle: or +preferredFontForTextStyle:compatibleWithTraitCollection: with a valid UIFontTextStyle
 
 - a font vended using -[UIFontMetrics scaledFontForFont:] or one of its variants
*/
@property (nonatomic) BOOL adjustsFontForContentSizeCategory;

#pragma mark - Context Menu Additions

/// The background color to use for targeted previews of the label.
/// @discussion The default value is nil, which results in the label's background color being used.
@property (nullable, nonatomic, strong) UIColor *targetedPreviewBackgroundColor;

/// Returns a targeted preview that focuses on the text in a given range.
/// @param range The range from which to create a targeted preview. It must lie within the bounds of the receiver.
- (nullable UITargetedPreview *)targetedPreviewForTextIn:(NSRange)range;

#pragma mark - Getting the highlight at a point

/// Returns the highlight, if any, in the label at a given point.
/// @param point A point in the label's coordinate system.
/// @param range Upon return, the range over which the highlight lies. This value is only valid when a non-nil highlight object is returned. If you don't need this value, pass NULL.
- (nullable YYTextHighlight *)getHighlightAtPoint:(CGPoint)point range:(nullable NSRangePointer)range NS_SWIFT_NAME(highlight(at:range:));

#pragma mark - Interacting with Text Data
///=============================================================================
/// @name Interacting with Text Data
///=============================================================================

/**
 When user tap the label, this action will be called (similar to tap gesture).
 The default value is nil.
 */
@property (nullable, nonatomic, copy) YYTextAction textTapAction;

/**
 When user long press the label, this action will be called (similar to long press gesture).
 The default value is nil.
 */
@property (nullable, nonatomic, copy) YYTextAction textLongPressAction;

/**
 When user tap the highlight range of text, this action will be called.
 The default value is nil.
 */
@property (nullable, nonatomic, copy) YYTextAction highlightTapAction;

/**
 When user long press the highlight range of text, this action will be called.
 The default value is nil. 
 */
@property (nullable, nonatomic, copy) YYTextAction highlightLongPressAction;

#pragma mark - Configuring the Display Mode
///=============================================================================
/// @name Configuring the Display Mode
///=============================================================================

/**
 A Boolean value indicating whether the layout and rendering codes are running
 asynchronously on background threads. 
 
 The default value is `NO`.
 */
@property (nonatomic) BOOL displaysAsynchronously;

/**
 If the value is YES, and the layer is rendered asynchronously, then it will
 set label.layer.contents to nil before display. 
 
 The default value is `YES`.
 
 @discussion When the asynchronously display is enabled, the layer's content will
 be updated after the background render process finished. If the render process
 can not finished in a vsync time (1/60 second), the old content will be still kept
 for display. You may manually clear the content by set the layer.contents to nil 
 after you update the label's properties, or you can just set this property to YES.
 */
@property (nonatomic) BOOL clearsContentsBeforeAsynchronouslyDisplay;

/**
 If the value is YES, and the layer is rendered asynchronously, then it will add 
 a fade animation on layer when the contents of layer changed. 
 
 The default value is `YES`.
 */
@property (nonatomic) BOOL fadesOnAsynchronouslyDisplay;

/**
 If the value is YES, then it will add a fade animation on layer when some range
 of text become highlighted. 
 
 The default value is `YES`.
 */
@property (nonatomic) BOOL fadesOnHighlight;

/**
 Ignore common properties (such as text, font, textColor, attributedText...) and
 only use "textLayout" to display content. 
 
 The default value is `NO`.
 
 @discussion If you control the label content only through "textLayout", then
 you may set this value to YES for higher performance.
 */
@property (nonatomic) BOOL ignoresCommonProperties;

/*
 Tips:
 
 1. If you only need a UILabel alternative to display rich text and receive link touch event, 
    you do not need to adjust the display mode properties.
 
 2. If you have performance issues, you may enable the asynchronous display mode
    by setting the `displaysAsynchronously` to YES.
 
 3. If you want to get the highest performance, you should do text layout with
    `YYTextLayout` class in background thread. Here's an example:
    
    YYLabel *label = [YYLabel new];
    label.displaysAsynchronously = YES;
    label.ignoresCommonProperties = YES;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
 
        // Create attributed string.
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Some Text"];
        text.yy_font = [UIFont systemFontOfSize:16];
        text.yy_color = [UIColor grayColor];
        [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
 
        // Create text container
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(100, CGFLOAT_MAX);
        container.maximumNumberOfRows = 0;
        
        // Generate a text layout.
        YYTextLayout *layout = [YYTextLayout initWithContainer:container text:text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            label.size = layout.textBoundingSize;
            label.textLayout = layout;
        });
    });
 
 */

@end

NS_ASSUME_NONNULL_END
