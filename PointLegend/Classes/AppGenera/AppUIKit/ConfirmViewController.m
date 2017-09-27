//
//  ConfirmViewController.m
//  FastttCamera
//
//  Created by Laura Skelton on 2/9/15.
//  Copyright (c) 2015 IFTTT. All rights reserved.
//

#import "ConfirmViewController.h"
#import <Masonry/Masonry.h>
#import <FastttCamera/FastttCamera.h>
#import "UIBarButtonItem+Action.h"
@import AssetsLibrary;
@import MessageUI;

@interface ConfirmViewController ()

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIImageView *previewImageView;

@end

@implementation ConfirmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT-0.3)];
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithWhite:0 alpha:0]) forBarMetrics:UIBarMetricsDefault];
    self.baseNavBar.tintColor = [UIColor whiteColor];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:self.baseNavBar];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:nil action:nil];
    WS(weakSelf);
    [item.leftBarButtonItem setActionBlock:^{
        [weakSelf dismissConfirmController];
    }];
    
    self.baseNavBar.items = @[item];
    
    _previewImageView = [[UIImageView alloc] initWithImage:self.capturedImage.rotatedPreviewImage];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.previewImageView];
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _confirmButton = [UIButton new];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.confirmButton setTitle:@"使用"
                        forState:UIControlStateNormal];
    
//    if (!self.capturedImage.isNormalized) {
//        self.confirmButton.enabled = NO;
//    }
    
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20.f);
    }];
    
    [self.view bringSubviewToFront:self.baseNavBar];
}

- (void)setImagesReady:(BOOL)imagesReady
{
    _imagesReady = imagesReady;
    if (imagesReady) {
        self.confirmButton.enabled = YES;
    }
}

#pragma mark - Actions

- (void)dismissConfirmController
{
    [self.delegate dismissConfirmController:self];
}

- (void)confirmButtonPressed
{
    [self savePhotoToCameraRoll];
}

- (void)savePhotoToCameraRoll
{
    
}

@end
