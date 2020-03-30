YYText
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/halleygen/YYText/master/LICENSE)&nbsp;
![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-brightgreen)&nbsp;
[![Support](https://img.shields.io/badge/Supports-iOS%2013-blue?style=flat)](https://www.apple.com/ios/)&nbsp;

Powerful text framework for iOS to display and edit rich text.<br/>
(It's a component of [YYKit](https://github.com/ibireme/YYKit))


Features
==============

- UILabel and UITextView API compatible
- High performance asynchronous text layout and rendering
- Extended CoreText attributes with more text effects
- Text attachments with UIImage, UIView and CALayer
- Custom highlight text range to allow user interact with
- Text parser support (built in markdown/emoticon parser)
- Text container path and exclusion paths support
- Vertical form layout support (for CJK text)
- Image and attributed text copy/paste support
- Attributed text placeholder support
- Custom keyboard view support
- Undo and redo control
- Attributed text archiver and unarchiver support
- Multi-language and VoiceOver support
- Interface Builder support
- Fully documented


Architecture
==============
YYText vs TextKit

<img src="https://raw.github.com/ibireme/YYText/master/Attributes/architecture.png" width="400">


Text Attributes
==============

### YYText supported attributes
<table>
  <thead>
    <tr>
      <th>Demo</th>
      <th>Attribute Name</th>
      <th>Class</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextAttachment.gif" width="200"></td>
      <td>TextAttachment</td>
      <td>YYTextAttachment</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextHighlight.gif" width="200"></td>
      <td>TextHighlight</td>
      <td>YYTextHighlight</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextBinding.gif" width="200"></td>
      <td>TextBinding</td>
      <td>YYTextBinding</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextShadow.png" width="200"></td>
      <td>TextShadow<br/>TextInnerShadow</td>
      <td>YYTextShadow</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextBorder.png" width="200"></td>
      <td>TextBorder</td>
      <td>YYTextBorder</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextBackgroundBorder.png" width="200"></td>
      <td>TextBackgroundBorder</td>
      <td>YYTextBorder</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextBlockBorder.png" width="200"></td>
      <td>TextBlockBorder</td>
      <td>YYTextBorder</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Obliqueness.png" width="200"></td>
      <td>TextGlyphTransform</td>
      <td> NSValue(CGAffineTransform)</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Underline.png" width="200"></td>
      <td>TextUnderline</td>
      <td>YYTextDecoration</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Strikethrough.png" width="200"></td>
      <td>TextStrickthrough</td>
      <td>YYTextDecoration</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/YYText Extended/YYTextBackedString.png" width="200"></td>
      <td>TextBackedString</td>
      <td>YYTextBackedString</td>
    </tr>
  </tbody>
</table>

### CoreText attributes which are supported by YYText
<table>
  <thead>
    <tr>
      <th>Demo</th>
      <th>Attribute Name</th>
      <th>Class</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Font.png" width="200"></td>
      <td> Font </td>
      <td>UIFont(CTFontRef)</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Kern.png" width="200"></td>
      <td> Kern </td>
      <td>NSNumber</td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Stroke.png" width="200"></td>
      <td> StrokeWidth </td>
      <td> NSNumber </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/StrokeColor.png" width="200"></td>
      <td> StrokeColor </td>
      <td> CGColorRef </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Shadow.png" width="200"></td>
      <td> Shadow </td>
      <td> NSShadow </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Ligature.png" width="200"></td>
      <td> Ligature </td>
      <td> NSNumber </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/VerticalForms.png" width="200"></td>
      <td> VerticalGlyphForm </td>
      <td> NSNumber(BOOL) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/WriteDirection.png" width="200"></td>
      <td> WritingDirection </td>
      <td> NSArray(NSNumber) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/RunDelegate.png" width="200"></td>
      <td> RunDelegate </td>
      <td> CTRunDelegateRef </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/Alignment.png" width="200"></td>
      <td> TextAlignment </td>
      <td> NSParagraphStyle <br/>(NSTextAlignment) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/LineBreakMode.png" width="200"></td>
      <td> LineBreakMode </td>
      <td> NSParagraphStyle <br/>(NSLineBreakMode) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/LineSpacing.png" width="200"></td>
      <td> LineSpacing </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/ParagraphSpacing.png" width="200"></td>
      <td> ParagraphSpacing <br/> ParagraphSpacingBefore </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/FirstLineHeadIndent.png" width="200"></td>
      <td> FirstLineHeadIndent </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/HeadIndent.png" width="200"></td>
      <td> HeadIndent </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/TailIndent.png" width="200"></td>
      <td> TailIndent </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/MinimumLineHeight.png" width="200"></td>
      <td> MinimumLineHeight </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/MaximumLineHeight.png" width="200"></td>
      <td> MaximumLineHeight </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/LineHeightMultiple.png" width="200"></td>
      <td> LineHeightMultiple </td>
      <td> NSParagraphStyle <br/>(CGFloat) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/BaseWritingDirection.png" width="200"></td>
      <td> BaseWritingDirection </td>
      <td> NSParagraphStyle <br/>(NSWritingDirection) </td>
    </tr>
    <tr>
      <td><img src="https://raw.github.com/ibireme/YYText/master/Attributes/CoreText and TextKit/Paragraph/Tab.png" width="200"></td>
      <td> DefaultTabInterval <br/> TabStops </td>
      <td> NSParagraphStyle <br/>CGFloat/NSArray(NSTextTab)</td>
    </tr>
  </tbody>
</table>


Usage
==============

### Basic
```objc
// YYLabel (similar to UILabel)
YYLabel *label = [YYLabel new];
label.frame = ...
label.font = ...
label.textColor = ...
label.textAlignment = ...
label.lineBreakMode = ...
label.numberOfLines = ...
label.text = ...
    
// YYTextView (similar to UITextView)
YYTextView *textView = [YYTextView new];
textView.frame = ...
textView.font = ...
textView.textColor = ...
textView.dataDetectorTypes = ...
textView.placeHolderText = ...
textView.placeHolderTextColor = ...
textView.delegate = ...
```    

### Attributed text
```objc
// 1. Create an attributed string.
NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Some Text, blabla..."];
    
// 2. Set attributes to text, you can use almost all CoreText attributes.
text.yy_font = [UIFont boldSystemFontOfSize:30];
text.yy_color = [UIColor blueColor];
[text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
text.yy_lineSpacing = 10;
    
// 3. Set to YYLabel or YYTextView.
YYLabel *label = [YYLabel new];
label.frame = ...
label.attributedString = text;
    
YYTextView *textView = [YYTextView new];
textView.frame = ...
textView.attributedString = text;
```

### Text highlight
    
You can use some convenience methods to set text highlight:
```objc
[text yy_setTextHighlightRange:range
                       color:[UIColor blueColor]
             backgroundColor:[UIColor grayColor]
                   tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){ 
                       NSLog(@"tap text range:..."); 
                   }];
```
Or set the text highlight with your custom config:
```objc
// 1. Create a 'highlight' attribute for text.
YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
   
YYTextHighlight *highlight = [YYTextHighlight new];
[highlight setColor:[UIColor whiteColor]];
[highlight setBackgroundBorder:highlightBorder];
highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
 NSLog(@"tap text range:..."); 
 // you can also set the action handler to YYLabel or YYTextView.
};
    
// 2. Add 'highlight' attribute to a range of text.
[attributedText yy_setTextHighlight:highlight range:highlightRange];
    
// 3. Set text to label or text view.
YYLabel *label = ...
label.attributedText = attributedText
    
YYTextView *textView = ...
textView.attributedText = ...
    
// 4. Receive user interactive action.
label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
   NSLog(@"tap text range:...");
};
label.highlightLongPressAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
   NSLog(@"long press text range:...");
};
    
@UITextViewDelegate
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
   NSLog(@"tap text range:...");
}
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
   NSLog(@"long press text range:...");
}
```

### Text attachments
```objc
NSMutableAttributedString *text = [NSMutableAttributedString new];
UIFont *font = [UIFont systemFontOfSize:16];
NSMutableAttributedString *attachment = nil;
	
// UIImage attachment
UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];
	
// UIView attachment
UISwitch *switcher = [UISwitch new];
[switcher sizeToFit];
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:switcher contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];
	
// CALayer attachment
CASharpLayer *layer = [CASharpLayer layer];
layer.path = ...
attachment = [NSMutableAttributedString yy_attachmentStringWithContent:layer contentMode:UIViewContentModeBottom attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
[text appendAttributedString: attachment];
```

### Text layout calculation
```objc
NSAttributedString *text = ...
CGSize size = CGSizeMake(100, CGFLOAT_MAX);
YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
	
// get text bounding
layout.textBoundingRect; // get bounding rect
layout.textBoundingSize; // get bounding size
	
 // query text layout
[layout lineIndexForPoint:CGPointMake(10,10)];
[layout closestLineIndexForPoint:CGPointMake(10,10)];
[layout closestPositionToPoint:CGPointMake(10,10)];
[layout textRangeAtPoint:CGPointMake(10,10)];
[layout rectForRange:[YYTextRange rangeWithRange:NSMakeRange(10,2)]];
[layout selectionRectsForRange:[YYTextRange rangeWithRange:NSMakeRange(10,2)]];
	
// text layout display
YYLabel *label = [YYLabel new];
label.size = layout.textBoundingSize;
label.textLayout = layout;
```

### Adjust text line position
```objc
// Convenience methods:
// 1. Create a text line position modifier, implements `YYTextLinePositionModifier` protocol.
// 2. Set it to label or text view.
	
YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
modifier.fixedLineHeight = 24;
	
YYLabel *label = [YYLabel new];
label.linePositionModifier = modifier;
	
// Fully control
YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
modifier.fixedLineHeight = 24;
	
YYTextContainer *container = [YYTextContainer new];
container.size = CGSizeMake(100, CGFLOAT_MAX);
container.linePositionModifier = modifier;
	
YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
YYLabel *label = [YYLabel new];
label.size = layout.textBoundingSize;
label.textLayout = layout;
```	
	
### Asynchronous layout and rendering
```objc
// If you have performance issues,
// you may enable the asynchronous display mode.
YYLabel *label = ...
label.displaysAsynchronously = YES;
    
// If you want to get the highest performance, you should do 
// text layout with `YYTextLayout` class in background thread.
YYLabel *label = [YYLabel new];
label.displaysAsynchronously = YES;
label.ignoreCommonProperties = YES;
    
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
   YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
   
   dispatch_async(dispatch_get_main_queue(), ^{
       label.size = layout.textBoundingSize;
       label.textLayout = layout;
   });
});
```

### Text container control
```objc
YYLabel *label = ...
label.textContainerPath = [UIBezierPath bezierPathWith...];
label.exclusionPaths = 	@[[UIBezierPath bezierPathWith...];,...];
label.textContainerInset = UIEdgeInsetsMake(...);
label.verticalForm = YES/NO;
    
YYTextView *textView = ...
textView.exclusionPaths = 	@[[UIBezierPath bezierPathWith...];,...];
textView.textContainerInset = UIEdgeInsetsMake(...);
textView.verticalForm = YES/NO;
```
   
### Text parser
```objc
// 1. Create a text parser
	
YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
NSMutableDictionary *mapper = [NSMutableDictionary new];
mapper[@":smile:"] = [UIImage imageNamed:@"smile.png"];
mapper[@":cool:"] = [UIImage imageNamed:@"cool.png"];
mapper[@":cry:"] = [UIImage imageNamed:@"cry.png"];
mapper[@":wink:"] = [UIImage imageNamed:@"wink.png"];
parser.emoticonMapper = mapper;
	
YYTextSimpleMarkdownParser *parser = [YYTextSimpleMarkdownParser new];
[parser setColorWithDarkTheme];
    
MyCustomParser *parser = ... // custom parser
    
// 2. Attach parser to label or text view
YYLabel *label = ...
label.textParser = parser;
    
YYTextView *textView = ...
textView.textParser = parser;
```
  
### Debug
```objc
// Set a shared debug option to show text layout result.
YYTextDebugOption *debugOptions = [YYTextDebugOption new];
debugOptions.baselineColor = [UIColor redColor];
debugOptions.CTFrameBorderColor = [UIColor redColor];
debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
[YYTextDebugOption setSharedDebugOption:debugOptions];
```

Installation
==============

### Swift Package Manager

To use the YYText library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/halleygen/YYText", from: "1.1.0"),
```

Finally, include "ArgumentParser" as a dependency for your executable target:

```swift
.product(name: "YYText", package: "YYText"),
```

### Manually

1. Download all the files in the `Sources` subdirectory.
2. Add the source files to your Xcode project.
3. Link with required frameworks:
    * UIKit
    * CoreFoundation
    * CoreText
    * QuartzCore
    * Accelerate
    * CoreServices
4. Import `YYText.h`.


Documentation
==============
Full API documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/YYText/).<br/>
You can also install documentation locally using [appledoc](https://github.com/tomaz/appledoc).


Requirements
==============
This library requires `iOS 13.0+` and `Xcode 11.0+`.


License
==============
YYText is released under the MIT license. See LICENSE file for details.
