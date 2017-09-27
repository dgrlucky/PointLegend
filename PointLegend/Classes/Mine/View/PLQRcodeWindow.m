//
//  PLQRcodeWindow.m
//  PointLegend
//
//  Created by ydcq on 15/11/26.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLQRcodeWindow.h"

@interface PLQRcodeWindow ()

@end

@implementation PLQRcodeWindow

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        self.windowLevel = UIWindowLevelAlert;
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0;
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        WS(weakSelf);
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(50);
            make.right.equalTo(weakSelf.mas_right).with.offset(-50);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.height.equalTo(weakSelf.imageView.mas_width).with.offset(0);
        }];
    }
    return self;
}

- (void)setQRImageWithString:(NSString *)str
{
    _imageView.image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:str] withWidth:(SCREEN_WIDTH-100)];
}

#pragma mark QRCode
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withWidth:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark dismiss

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            weakSelf.imageView.image = nil;
            [weakSelf.imageView removeFromSuperview];
            weakSelf.imageView = nil;
        }
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchesBegin)]) {
        [_delegate performSelector:@selector(touchesBegin) withObject:nil afterDelay:0];
    }
}

@end
