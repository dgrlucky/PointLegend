//
//  PLTakePictureViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLTakePictureViewController.h"
#import "UIButton+Block.h"
#import <AVFoundation/AVFoundation.h>
#import "UIBarButtonItem+Action.h"
#import "ConfirmViewController.h"

@interface PLTakePictureViewController ()<FastttCameraDelegate,ConfirmControllerDelegate>

@property (nonatomic ,strong ) UIButton *takePhotoButton;

@property (nonatomic ,strong )UIButton *cancelButton;

@property (nonatomic, strong) UINavigationBar *baseNavBar;

@property (nonatomic, strong) ConfirmViewController *confirmController;

@end

@implementation PLTakePictureViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT-0.3)];
    self.baseNavBar.barStyle = UIBarStyleBlack;
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithWhite:0 alpha:0]) forBarMetrics:UIBarMetricsDefault];
    self.baseNavBar.tintColor = [UIColor whiteColor];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:self.baseNavBar];
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:nil action:nil];
    WS(weakSelf);
    [item.leftBarButtonItem setActionBlock:^{
        [weakSelf stopRunning];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //闪光灯＋手电筒＋前后镜头
    UIBarButtonItem *flashButton = [[UIBarButtonItem alloc] initWithTitle:@"闪光灯" style:UIBarButtonItemStyleDone target:nil action:nil];
    __weak typeof(flashButton) weakFButton = flashButton;
    [flashButton setActionBlock:^{
        FastttCameraFlashMode flashMode;
        NSString *flashTitle;
        switch (weakSelf.cameraFlashMode) {
            case FastttCameraFlashModeOn:
                flashMode = FastttCameraFlashModeOff;
                flashTitle = @"闪光灯关";
                break;
            case FastttCameraFlashModeOff:
            default:
                flashMode = FastttCameraFlashModeOn;
                flashTitle = @"闪光灯开";
                break;
        }
        if ([weakSelf isFlashAvailableForCurrentDevice]) {
            [weakSelf setCameraFlashMode:flashMode];
            [weakFButton setTitle:flashTitle];
        }
    }];
    
    UIBarButtonItem *torchButton = [[UIBarButtonItem alloc] initWithTitle:@"手电筒" style:UIBarButtonItemStyleDone target:nil action:nil];
    __weak typeof(torchButton) weakTButton = torchButton;
    [torchButton setActionBlock:^{
        FastttCameraTorchMode torchMode;
        NSString *torchTitle;
        switch (weakSelf.cameraTorchMode) {
            case FastttCameraTorchModeOn:
                torchMode = FastttCameraTorchModeOff;
                torchTitle = @"手电筒关";
                break;
            case FastttCameraTorchModeOff:
            default:
                torchMode = FastttCameraTorchModeOn;
                torchTitle = @"手电筒开";
                break;
        }
        if ([weakSelf isTorchAvailableForCurrentDevice]) {
            [weakSelf setCameraTorchMode:torchMode];
            [weakTButton setTitle:torchTitle];
        }
    }];
    
    UIBarButtonItem *camButton = [[UIBarButtonItem alloc] initWithTitle:@"前/后" style:UIBarButtonItemStyleDone target:nil action:nil];
    [camButton setActionBlock:^{
        FastttCameraDevice cameraDevice;
        switch (weakSelf.cameraDevice) {
            case FastttCameraDeviceFront:
                cameraDevice = FastttCameraDeviceRear;
                break;
            case FastttCameraDeviceRear:
            default:
                cameraDevice = FastttCameraDeviceFront;
                break;
        }
        if ([FastttCamera isCameraDeviceAvailable:cameraDevice]) {
            [weakSelf setCameraDevice:cameraDevice];
            if (![weakSelf isFlashAvailableForCurrentDevice]) {
                [flashButton setTitle:@"闪光灯关"];
            }
        }
    }];
    
    self.baseNavBar.items = @[item];
    item.rightBarButtonItems = @[flashButton,torchButton,camButton];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模拟器");
    return;
#else
    NSLog(@"真机");
#endif
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        //无权限
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在设置->通用->隐私->相机中为app开启照相机权限" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.delegate = self;
    self.maxScaledDimension = 720;
    
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takePhotoButton addActionHandler:^(NSInteger tag) {
        if (!weakSelf.isReadyToCapturePhoto) {
            [weakSelf startRunning];
        }
        [weakSelf takePicture];
//        [weakSelf.takePhotoButton setTitle:@"重拍" forState:UIControlStateNormal];
    }];
    [self.takePhotoButton setTitle:@"确定"
                          forState:UIControlStateNormal];
    [self.takePhotoButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [self.view addSubview:self.takePhotoButton];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.multipliedBy(0.5);
        make.bottom.equalTo(self.view).offset(-20.f);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton addActionHandler:^(NSInteger tag) {
        [weakSelf stopRunning];
        if (weakSelf.finishCameraBlock) {
            weakSelf.finishCameraBlock(nil);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.cancelButton setTitle:@"取消"
                          forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
    [self.view addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.multipliedBy(1.5);
        make.bottom.equalTo(self.view).offset(-20.f);
    }];
}

#pragma mark Delegates

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage
{
    _confirmController = [ConfirmViewController new];
    self.confirmController.capturedImage = capturedImage;
    self.confirmController.delegate = self;
    
    UIView *flashView = [UIView new];
    flashView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.f];
    flashView.alpha = 0.f;
    [self.view addSubview:flashView];
    WS(weakSelf);
    [flashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [UIView animateWithDuration:0.15f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         flashView.alpha = 1.f;
                     }
                     completion:^(BOOL finished) {
                         
                         [self fastttAddChildViewController:self.confirmController belowSubview:flashView];
                         
                         [self.confirmController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.edges.equalTo(self.view);
                         }];
                         
                         [UIView animateWithDuration:0.15f
                                               delay:0.05f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              flashView.alpha = 0.f;
                                          }
                                          completion:^(BOOL finished2) {
                                              [flashView removeFromSuperview];
                                          }];
                     }];
}

#pragma mark - ConfirmControllerDelegate

- (void)dismissConfirmController:(ConfirmViewController *)controller
{
    [self fastttRemoveChildViewController:controller];
    
    self.confirmController = nil;
}

#pragma mark Actions

#pragma mark Others

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
