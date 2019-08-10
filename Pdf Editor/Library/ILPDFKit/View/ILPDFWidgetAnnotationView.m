// ILPDFWidgetAnnotationView.m//
// Copyright (c) 2016 Derek Blair
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ILPDFKit.h"
#import "ILPDFWidgetAnnotationView.h"

#define ILPDFTextFieldFontScaleFactor 0.75
#define ILPDFChoiceFieldBaseFontSizeToFrameHeightScaleFactor 0.8

@implementation ILPDFWidgetAnnotationView

#pragma mark - NSObject

- (void)dealloc {
    if (_parentView.activeWidgetAnnotationView == self) {
        [self resign];
        _parentView.activeWidgetAnnotationView = nil;
    }
}

- (NSString *)description {
      NSString *descriptionString = [NSString stringWithFormat:@"type=%@, name=%@, display name=%@\rframe: x=%f, y=%f, width=%f, height=%f", NSStringFromClass([self class]), _name, _displayName, _baseFrame.origin.x, _baseFrame.origin.y, _baseFrame.size.width, _baseFrame.size.height ];
          return descriptionString;
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _baseFrame = frame;
        _zoomScale = 1.0;
    }
    return self;
}


#pragma mark - ILPDFWidgetAnnotationView

- (void)updateWithZoom:(CGFloat)zoom {
    _zoomScale = zoom;
    self.frame = CGRectMake(_baseFrame.origin.x*zoom,_baseFrame.origin.y*zoom,_baseFrame.size.width*zoom,_baseFrame.size.height*zoom);
}

+ (CGFloat)fontSizeForRect:(CGRect)rect value:(NSString *)value multiline:(BOOL)multiline choice:(BOOL)choice {
    if (multiline) return ILPDFFormMinFontSize;
    CGFloat baseSize;
    if (choice) baseSize = roundf(MIN(MAX(floorf(rect.size.height*ILPDFChoiceFieldBaseFontSizeToFrameHeightScaleFactor),ILPDFFormMinFontSize),ILPDFFormMaxFontSize));
    else baseSize = roundf(MAX(MIN(ILPDFFormMaxFontSize,MIN(rect.size.height, ILPDFFormMaxFontSize)*ILPDFTextFieldFontScaleFactor),ILPDFFormMinFontSize));
    if (value) {
        while (baseSize >= ILPDFFormMinFontSize && [value sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:baseSize]}].width > rect.size.width-ILPDFFormMinFontSize) {
            baseSize -= 1.0;
        }
        return baseSize;
    } else return baseSize;
}

- (void)setValue:(NSString *)value {
}

- (NSString *)value {
    return nil;
}

- (CGFloat)zoomScale {
    return _zoomScale;
}
- (void)setOptions:(NSArray *)options {
}

- (NSArray *)options {
    return nil;
}

- (void)refresh {
    [self setNeedsDisplay];
}

- (void)resign {
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated completion:(nullable void(^)(BOOL finished))completion {
    [self setHighlighted:highlighted animated:animated duration:0.3 completion:completion];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated duration:(NSTimeInterval)duration completion:(nullable void(^)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:^{
        if (highlighted) {
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = [UIColor blackColor].CGColor;
            self.layer.shadowOpacity = 2.0;
            self.layer.shadowColor = [UIColor yellowColor].CGColor;
            self.layer.shadowOffset =  CGSizeMake(0, 0);
            self.layer.shadowRadius = 5.0;
        }
        else {
            self.layer.borderWidth = 0.0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.layer.shadowOpacity = 0.0;
        }

    } completion:completion];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"value"]) {
        self.value = change[NSKeyValueChangeNewKey];
    } else if ([keyPath isEqualToString:@"options"]) {
        self.options = change[NSKeyValueChangeNewKey];
    }
}

@end
