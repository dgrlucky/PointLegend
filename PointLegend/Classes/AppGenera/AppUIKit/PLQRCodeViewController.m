//
//  PLQRCodeViewController.m
//  PointLegend
//
//  Created by ydcq on 15/9/23.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PLWebViewController.h"
#import "UIBarButtonItem+Action.h"

typedef NS_ENUM(NSInteger, overlayState)
{
    overlayStateReady,
    overlayStateScanning,
    overlayStateEnd
};

#define CROP_WIDTH 220

@interface PLQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIView *overlayView;
}

@property ( strong , nonatomic ) AVCaptureDevice * device;

@property ( strong , nonatomic ) AVCaptureDeviceInput * input;

@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

@property ( strong , nonatomic ) AVCaptureSession * session;

@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;

@end

@implementation PLQRCodeViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.baseNavBar.barStyle = UIBarStyleBlack;
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor colorWithWhite:0 alpha:0.3]) forBarMetrics:UIBarMetricsDefault];
    self.baseNavBar.tintColor = [UIColor whiteColor];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    baseNavItem.title = @"二维码下单";
    
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
    
    // Device
    
    _device = [ AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
    
    baseNavItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"闪光灯" style:0 target:nil action:nil];
    
    WS(weakSelf);
    [baseNavItem.rightBarButtonItem setActionBlock:^{
        if (![weakSelf.device hasTorch]) {
            NSLog(@"no torch");
        }else{
            [weakSelf.device lockForConfiguration:nil];
            if (weakSelf.device.torchMode == AVCaptureTorchModeOff) {
                [weakSelf.device setTorchMode:AVCaptureTorchModeOn];
            }
            else if (weakSelf.device.torchMode == AVCaptureTorchModeOn) {
                [weakSelf.device setTorchMode:AVCaptureTorchModeOff];
            }
            [weakSelf.device unlockForConfiguration];
        }
    }];
    
    // Input
    
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self . device error : nil ];
    
    // Output
    
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    
    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
    
    [ _output setRectOfInterest : CGRectMake (( 124 )/ SCREEN_HEIGHT ,(( SCREEN_WIDTH - 220 )/ 2 )/ SCREEN_WIDTH , 220 / SCREEN_HEIGHT , 220 / SCREEN_WIDTH )];
    
    // Session
    
    _session = [[ AVCaptureSession alloc ] init ];
    
    [ _session setSessionPreset : AVCaptureSessionPreset1920x1080 ];
    
    if ([ _session canAddInput : self . input ])
        
    {
        
        [ _session addInput : self . input ];
        
    }
    
    if ([ _session canAddOutput : self . output ])
        
    {
        
        [ _session addOutput : self . output ];
        
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    _output . metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ] ;
    
    // Preview
    
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    
    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
    
    _preview . frame = /*CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT) */self.view.bounds;
    
    [ self . view . layer insertSublayer : _preview atIndex : 0 ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        return;
    }
    
    // Start
    
    [ _session startRunning ];
    
    [overlayView removeFromSuperview];
    
    overlayView = [self overlayView:overlayStateScanning];
    
    [self.view addSubview:overlayView];
}

- (void)popToPreviousVC
{
    [ _session stopRunning ];
    
    [overlayView removeFromSuperview];
    
    overlayView = [self overlayView:overlayStateReady];
    
    [self.view addSubview:overlayView];
    
    [super popToPreviousVC];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%s",__func__);
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        return;
    }
    
    // Stop
    
    [ _session stopRunning ];
    
    [overlayView removeFromSuperview];
    
    overlayView = [self overlayView:overlayStateReady];
    
    [self.view addSubview:overlayView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.shouldRelease) {
        [_session stopRunning];
        
        [overlayView removeFromSuperview];
        overlayView = nil;
        
        [_preview removeFromSuperlayer];
        _preview = nil;
        
        _device = nil;
        _input = nil;
        _output = nil;
        _session = nil;
    }
    NSLog(@"%s",__func__);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIView *)overlayView:(overlayState)state
{
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, state==overlayStateScanning?0.3:0.9);
    CGContextFillRect(context, [UIScreen mainScreen].bounds);
    
    switch (state) {
        case overlayStateScanning:
        {
            UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchLight"]];
            imageLine.frame = CGRectMake(SCREEN_WIDTH/2.f-CROP_WIDTH/2.f, SCREEN_HEIGHT/2.f-CROP_WIDTH/2.f-64, CROP_WIDTH, 8);
            imageLine.tag = 8000;
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f-CROP_WIDTH/2.f-64)];
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f-CROP_WIDTH/2.f-64+CROP_WIDTH)];
            anim.repeatCount = HUGE_VALF;
            anim.autoreverses = YES;
            anim.duration = 1.5;
            [imageLine.layer addAnimation:anim forKey:@"anim"];
            
            CGContextClearRect(context, CGRectMake(SCREEN_WIDTH/2.f-CROP_WIDTH/2.f, SCREEN_HEIGHT/2.f-CROP_WIDTH/2.f-64, CROP_WIDTH, CROP_WIDTH));
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
            [imageView addSubview:imageLine];
            
            return imageView;
        }
            break;
        case overlayStateReady:
        {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
            indicator.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f-40-NAV_BAR_HEIGHT);
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            indicator.tag = 500;
            [indicator startAnimating];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, SCREEN_HEIGHT/2.f-20-NAV_BAR_HEIGHT, SCREEN_WIDTH-200, 40)];
            label.numberOfLines = 2;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"准备中...";
            label.tag = 501;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
            [imageView addSubview:indicator];[imageView addSubview:label];
            
            return imageView;
        }
            break;
        case overlayStateEnd:
        {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
            indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            indicator.center = CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT/2.f-40-NAV_BAR_HEIGHT);
            indicator.tag = 500;
            [indicator startAnimating];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT/2.f-20-NAV_BAR_HEIGHT, SCREEN_WIDTH-100, 80)];
            label.numberOfLines = 5;
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 501;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor whiteColor];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
            imageView.image = img;
            UIGraphicsEndImageContext();
            
            [imageView addSubview:indicator];[imageView addSubview:label];
            
            return imageView;
        }
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection

{
    
    NSString *stringValue;
    
    if ([metadataObjects count ] > 0 )
        
    {
        
        // 停止扫描
        
        [ _session stopRunning ];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        stringValue = metadataObject. stringValue ;
        
    }
    
    [overlayView removeFromSuperview];
    overlayView = [self overlayView:overlayStateEnd];
    [self.view addSubview:overlayView];
    
    ((UILabel *)[overlayView viewWithTag:501]).text = [NSString stringWithFormat:@"扫描结果：\n%@",stringValue];
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf pushToWebVC:stringValue];
    });
}

- (void)pushToWebVC:(NSString *)str
{
    PLWebViewController *web = [[PLWebViewController alloc] init];
    web.urlString = str;
    [self.navigationController pushViewController:web animated:YES];
}

@end
