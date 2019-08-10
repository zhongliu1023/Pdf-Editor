// ILPDFFormSignatureField.m
//
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

#import "ILPDFFormSignatureField.h"
#import "ILPDFKit.h"

@implementation ILPDFFormSignatureField {
      NSString *_val;
      UIImageView *imageView;
}

#pragma mark - NSObject

- (void)dealloc {
      [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UIView

// This class is incomplete. Signature fields are not implemented currently. We mark them red.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ILPDFWidgetColor colorWithAlphaComponent:1];
        
        [self initializeControls];
    }
    return self;
}

-(void)initializeControls {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSignatureView:)];
    [self addGestureRecognizer:tap];
    
    imageView = [[UIImageView alloc] init]; //WithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:imageView];
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]
                           ]];
    [self layoutIfNeeded];
}

-(void)showSignatureView:(UITapGestureRecognizer *)tap {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"SIGNATURE_REQUESTED" object:self];
}

-(void)setSignatureImage:(UIImage *)image {
    if (image == nil) {
        _val = nil;
        
        if (imageView.image != nil) {
            [self.delegate widgetAnnotationValueChanged:self];
        }
        
        return;
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *string = [data base64EncodedStringWithOptions: 0];
    _val = string;
    
    imageView.image = image;
    
    [self.delegate widgetAnnotationValueChanged:self];
}

-(void)setValue:(NSString *)value {
    if (value == nil) {        
        [self setSignatureImage:nil];
    }
    
    if (!value) {
        self.backgroundColor = [ILPDFWidgetColor colorWithAlphaComponent:1];
        return;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:value options: 0];
    UIImage *image = [UIImage imageWithData:data];
    [self setSignatureImage:image];
}

-(NSString *)value {
    return _val;
}

+(void)drawWithRect:(CGRect)frame context:(CGContextRef)ctx value:(NSString *)value {
    if (value == nil) return;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:value options: 0];
    UIImage *image = [UIImage imageWithData:data];
    
    CGFloat aspect = image.size.width / image.size.height;
    CGSize size = [ILPDFFormSignatureField scaledSizeWithAspect:aspect boundingSize:frame.size];
    
    UIGraphicsPushContext(ctx);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsPopContext();
}

+(CGSize)scaledSizeWithAspect:(CGFloat)aspect boundingSize:(CGSize)size {
    if (size.width / aspect <= size.height) {
        return CGSizeMake(size.width, size.width / aspect);
    }
    
    return CGSizeMake(size.height * aspect, size.height);
}

@end
