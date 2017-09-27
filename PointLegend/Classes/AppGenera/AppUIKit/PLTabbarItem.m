//
//  PLTabbarItem.m
//  TestDemo
//
//  Created by ydcq on 15/9/7.
//  Copyright (c) 2015年 黄国桥. All rights reserved.
//

#import "PLTabbarItem.h"
#import "UIImageView+WebCache.h"

@interface PLTabbarItem ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation PLTabbarItem

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithInfo:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.title = dic[@"title"];
        self.image = [UIImage imageNamed:dic[@"imageName"]];
        self.selectedImage = [UIImage imageNamed:dic[@"selectedImageName"]];
        
        WS(weakSelf);
        
        if ([dic[@"itemUrl"] length]>0) {
            _imageView = [UIImageView new];
            [_imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"itemUrl"]] placeholderImage:self.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    weakSelf.image = image;
                    weakSelf.imageView = nil;
                }
            }];
        }
        
        if ([dic[@"selectedItemUrl"] length]>0) {
            _selectedImageView = [UIImageView new];
            [_selectedImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"selectedItemUrl"]] placeholderImage:self.selectedImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    weakSelf.selectedImage = image;
                    weakSelf.selectedImageView = nil;
                }
            }];
        }
    }
    return self;
}

@end
