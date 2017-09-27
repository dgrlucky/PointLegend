//
//  PLInvitViewController.m
//  Legend
//
//  Created by ydcq on 15/12/2.
//  Copyright © 2015年 frocky. All rights reserved.
//

#import "PLInvitViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <MessageUI/MessageUI.h>
#import "WXApi.h"

#define shareUrl(t) ([NSString stringWithFormat:@"%@Home/PcRegister/reg?userId=%@&type=%d",BaseHtmlUrl,[PLUserInfoModel sharedInstance].userId,t])
#define shareText [@"一大波福利正向你靠近！吃喝玩乐用「一点传奇」，折扣返利双重优惠，享VIP超低价，省钱又土豪的生活邀你来体验。不用谢，请叫我雷锋！拿福利点这里" stringByAppendingString:shareUrl(10)]

#define BackGroupHeight 0

#define percent (SCREEN_WIDTH/320)

@interface PLInvitViewController ()<UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,WXApiDelegate>
{
    NSString *shareUrlString;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageBG;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIView *sView;
@property (weak, nonatomic) IBOutlet UIImageView *inviteView;

@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareV;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, copy) NSString *userId;
@end

@implementation PLInvitViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        NSString *userId = @"";
        userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        self.userId = userId;
//        shareUrlString = shareUrl(6);
    }
    return self;
}

- (void)viewDidLoad
{
    self.baseNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63.7)];
    [self.baseNavBar setTintColor:[UIColor whiteColor]];
    self.baseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    [self.baseNavBar setBackgroundImage:imageWithColor([UIColor clearColor]) forBarMetrics:UIBarMetricsDefault];
    self.baseNavBar.shadowImage = [UIImage new];
    [self.view addSubview:self.baseNavBar];
    
    [super viewDidLoad];
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104640160" andDelegate:nil];
    
    //新浪微博长链接转短链接
    /*
    NSString *str = [NSString stringWithFormat:@"https://api.weibo.com/2/short_url/shorten.json?source=2058287396&url_long=%@",shareUrl];
    WS(weakSelf);
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            
        }
        else
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [weakSelf setShareUrlString:dic];
        }
    }];
    */
    [self addSubViews];
    
    _imageBG.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banner-1@2x" ofType:@"png"]];
    _inviteView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg_1@2x" ofType:@"png"]];
    _shareV.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg-3@2x" ofType:@"png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_backScrollView setContentOffset:CGPointMake(0, _backScrollView.contentSize.height-SCREEN_HEIGHT) animated:YES];
}

- (void)addSubViews
{
    UINavigationItem *item = [[UINavigationItem alloc] init];
    self.baseNavBar.items = @[item];
    item.title = @"邀请有礼";
    
    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStyleDone target:self action:@selector(popToPreviousVC)];
    
    [self.view bringSubviewToFront:self.baseNavBar];
    
    _backScrollView.frame = self.view.bounds;
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 619*percent);
    
    CGRect imgRect = _imageBG.frame;
    imgRect.size.height = 202*percent;
    _imageBG.frame = imgRect;
    
    CGRect sRect = _sView.frame;
    sRect.origin.y = 202*percent;
    sRect.size.height = 416*percent;
    _sView.frame = sRect;
    
    CGRect invRect = _inviteView.frame;
    invRect.size.height = 219*percent;
    _inviteView.frame = invRect;
    
    CGRect shaRect = _shareV.frame;
    shaRect.origin.y = _inviteView.frame.origin.y + _inviteView.frame.size.height + 8;
    shaRect.size.height = 180*percent;
    _shareV.frame = shaRect;
    
    CGRect qrRect = _qrImageView.frame;
    qrRect.origin.y = 44*percent;
    qrRect.origin.x = (SCREEN_WIDTH-150*percent)/2.f;
    qrRect.size.width = qrRect.size.height = 150*percent;
    _qrImageView.frame = qrRect;
    
    CGRect labelFrame = _flagLabel.frame;
    labelFrame.origin.y = _inviteView.frame.origin.y+_inviteView.frame.size.height-30;
    _flagLabel.frame = labelFrame;
    
    //分享按钮
    NSArray *arr = @[@{@"img":@"icon-WeChat",@"title":@"微信好友"},@{@"img":@"icon-Friends_ring",@"title":@"朋友圈"},@{@"img":@"icon-QQ",@"title":@"QQ好友"},@{@"img":@"icon-qq_room",@"title":@"QQ空间"},@{@"img":@"icon-message",@"title":@"短信"}];
    CGFloat width = (SCREEN_WIDTH-60*2-50*2)/3;
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(60+(width+50)*(i%3), _shareV.frame.origin.y+41+(width+30)*(i/3), width, width);
        button.tag = 5000+i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:arr[i][@"img"]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageByApplyingAlpha:0.4 image:image] forState:UIControlStateHighlighted];
        [_sView addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 6000+i;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(button.frame.origin.x-12.5, button.frame.origin.y+width+3, width+25, 20);
        label.text = arr[i][@"title"];
        [_sView addSubview:label];
    }
    
    if (![WXApi isWXAppInstalled]) {
        [[_sView viewWithTag:5000] setHidden:YES];
        [[_sView viewWithTag:5001] setHidden:YES];
        [[_sView viewWithTag:6000] setHidden:YES];
        [[_sView viewWithTag:6001] setHidden:YES];
    }
    if (![QQApiInterface isQQInstalled]) {
        [[_sView viewWithTag:5002] setHidden:YES];
        [[_sView viewWithTag:5003] setHidden:YES];
        [[_sView viewWithTag:6002] setHidden:YES];
        [[_sView viewWithTag:6003] setHidden:YES];
    }
    
    NSString *recommendStr = ([NSString stringWithFormat:@"%@Home/PcRegister/reg?userId=%@&type=%d",BaseHtmlUrl,self.userId,1]);
    _qrImageView.image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:recommendStr] withWidth:150*percent];
}

#pragma mark Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = yOffset/2;
    
    if (yOffset < 0) {
        CGRect rect = _imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height = 202*percent-yOffset;
        rect.origin.x = xOffset;
        rect.size.width = SCREEN_WIDTH + fabs(xOffset)*2;
        
        _imageBG.frame = rect;
    }
    
    return;
}

//QQ分享
- (void)handleQQResponse:(NSString *)str
{
    NSLog(@"%@",str);
    if ([str rangeOfString:@"error=-4"].location != NSNotFound) {
        [SVProgressHUD showInfoWithStatus:@"分享取消！"];
        return;
    }
    else if ([str rangeOfString:@"error=0"].location != NSNotFound) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"分享失败！"];
    }
}

//MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showInfoWithStatus:@"取消发送！"];
            break;
        case MessageComposeResultFailed:// send failed
            [SVProgressHUD showSuccessWithStatus:@"发送失败！"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showErrorWithStatus:@"发送成功！"];
            break;
        default:
            break;
    }
}

- (void)onResp:(BaseResp *)resp
{
    /*
    enum  WXErrCode {
        
        WXSuccess           = 0,
        WXErrCodeCommon     = -1,
        WXErrCodeUserCancel = -2,
        WXErrCodeSentFail   = -3,
        WXErrCodeAuthDeny   = -4,
        WXErrCodeUnsupport  = -5,
        
    };
     */
    if (resp.errCode == 0) {
        [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
    }
    else if (resp.errCode == -2) {
        [SVProgressHUD showInfoWithStatus:@"分享取消！"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"分享失败！"];
    }
}

- (void)onReq:(BaseReq *)req
{
    
}

#pragma mark UserActions

- (void)buttonClicked:(UIButton *)btn
{
    switch (btn.tag-5000) {
        case 0:
            [self WXShareClick:1];
            break;
        case 1:
            [self WXShareClick:2];
            break;
        case 2:
            [self qqShareClick:1];
            break;
        case 3:
            [self qqShareClick:2];
            break;
        case 4:
        {
            [SVProgressHUD showWithStatus:@"请稍后..."];
            if( [MFMessageComposeViewController canSendText] ){
                
                MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
                
                controller.recipients = nil;
                controller.body = shareText;
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:^{
                    [SVProgressHUD dismiss];
                }];
                
                [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"短信"];//修改短信界面标题
            }else{
                [SVProgressHUD showErrorWithStatus:@"设备没有短信功能！"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark Others

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)qqShareClick:(int)type
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"applogo.png"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSString *title = @"一点传奇";
    NSString *description = @"成为一点传奇会员，吃喝玩乐享全城超低折，消费还返现";
    NSString *urlStr = shareUrl(11);
    NSURL* url = [NSURL URLWithString:urlStr];
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:description previewImageData:data];
    if (type==2) {
        img.cflag = kQQAPICtrlFlagQZoneShareOnStart;
    }
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)WXShareClick:(int)type
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一点传奇";
    message.description = @"成为一点传奇会员，吃喝玩乐享全城超低折，消费还返现";
    [message setThumbImage:[UIImage imageNamed:@"applogo.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl(7);
    if (type==2) {
        ext.webpageUrl = shareUrl(6);
    }
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    if (type==2) {
        message.title = @"成为一点传奇会员，吃喝玩乐享全城超低折，消费还返现";
        message.description = nil;
        req.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDSUCESS:
        {
            
        }
            break;
        default:
        {
            break;
        }
    }
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

- (void)setShareUrlString:(NSDictionary *)dic
{
    if (dic) {
        NSArray *arr = dic[@"urls"];
        if ((NSNull *)arr == [NSNull null]) {
            return;
        }
        if (arr.count>0) {
            NSDictionary *d = arr[0];
            if ([d[@"result"] boolValue]) {
                shareUrlString = d[@"url_short"];
            }
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
