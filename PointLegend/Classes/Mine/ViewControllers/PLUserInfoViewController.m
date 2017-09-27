//
//  PLUserInfoViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/27.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLUserInfoViewController.h"
#import "PLBaseCell.h"
#import "UIButton+Block.h"
#import "PLTakePictureViewController.h"
#import "LCActionSheet.h"
#import <ImageIO/ImageIO.h>
#include <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

NSString *PLUserHeadImgChanedNotification = @"PLUserHeadImgChanedNotification";

@interface PLUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,FastttCameraDelegate,LCActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *cellInfoArray;
    UIButton *_takePhotoButton;
}
@end

@implementation PLUserInfoViewController

#pragma mark LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        cellInfoArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"基本信息";
    
    [self setBaseTableViewWithStyle:UITableViewStyleGrouped frame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    
//    WS(weakSelf);
//    [self.dataTaskArray addObject:[PLHttpTools get:PLInterface_GetBaseInfo params:@{@"userId":@"2910057629"} result:^(NSDictionary *dic, NSError *error) {
//        if (error) {
//            [weakSelf handleNetworkError:error];
//        }
//        else
//        {
//            [weakSelf updateUIWithResponse:dic interface:PLInterface_GetBaseInfo];
//            
//            //保存至PLUserInfoModel单例
//            PLUserInfoModel *obj = [PLUserInfoModel sharedInstance];
//            NSDictionary *d = dic[@"data"];
//            obj.userId = d[@"userId"];
//            obj.nickName = d[@"nickName"];
//            obj.imgBig = d[@"imgBig"];
//            obj.imgSmall = d[@"imgSmall"];
//            
//            [cellInfoArray removeAllObjects];
//            
//            [cellInfoArray addObject:@{@"img":d[@"imgSmall"],@"title":@"一点传奇"}];
//            [weakSelf.baseTableView reloadData];
//        }
//    }]];
    
    NSNumber *userId = [PLUserInfoModel sharedInstance].userId;
    if (!userId) {
        return;
    }
    [self sendRequestWithMethod:GET interface:PLInterface_GetBaseInfo parameters:@{@"userId":userId}];
}

#pragma mark Network

- (void)updateUIWithResponse:(NSDictionary *)jsonDic
{
    [super updateUIWithResponse:jsonDic];
    NSError *error = jsonDic[@"error"];
    NSDictionary *response = jsonDic[@"response"];
    PLInterface interface = (PLInterface)[jsonDic[@"interface"] intValue];
    NSURLSessionDataTask *task = jsonDic[@"task"];
    
    if (interface == PLInterface_GetBaseInfo) {
        if (response) {
            //保存至PLUserInfoModel单例
            PLUserInfoModel *obj = [PLUserInfoModel sharedInstance];
            id o = response[@"data"];
            if ((NSNull *)o == [NSNull null]) {
                return;
            }
            [obj dicToObject:response[@"data"]];

            [cellInfoArray removeAllObjects];

            [cellInfoArray addObject:@{@"img":obj.imgSmall?:@"",@"title":@"一点传奇"}];
            [self.baseTableView reloadData];
        }
        if (error) {
            
        }
    }
}

#pragma mark Delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        PLBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLBaseCell cellReuseIdentifier:cellTypeMine]];
        if (cell == nil) {
            cell = [[PLBaseCell alloc] initWithType:cellTypeMine];
        }
        cell.headImageView.frame = CGRectMake(15, 12.5, 45, 45);
        cell.titleLabel.x = 70;
        if (cellInfoArray.count) {
            [cell setInfoDic:cellInfoArray.firstObject];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil
                                            buttonTitles:@[@"拍照", @"相册"]
                                          redButtonIndex:-1
                                                delegate:self];
    
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        PLTakePictureViewController *vc = [[PLTakePictureViewController alloc] init];
        WS(weakSelf);
        [vc setFinishCameraBlock:^(NSData *data) {
            if (!data) {
                return;
            }
            NSLog(@"照片压缩前大小：%.2fMB",(CGFloat)data.length/(1024*1024));
            UIImage *image= [UIImage imageWithData:data];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            UIImage *img = [weakSelf thumbnailForAsset:imageData maxPixelSize:640];
            NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
            NSLog(@"照片压缩后大小：%.2fMB",(CGFloat)imgData.length/(1024*1024));
            [weakSelf uploadUserImg:imgData];
        }];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    if (buttonIndex==1) {
        UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
        imgPickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPickerVC.allowsEditing = YES;
        imgPickerVC.delegate = self;
        [self.navigationController presentViewController:imgPickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"照片压缩前大小：%.2fMB",(CGFloat)imageData.length/(1024*1024));
    UIImage *img = [self thumbnailForAsset:imageData maxPixelSize:2*SCREEN_WIDTH];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    NSLog(@"照片压缩后大小：%.2fMB",(CGFloat)imgData.length/(1024*1024));
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadUserImg:imgData];
}

#pragma mark Actions

- (void)uploadUserImg:(NSData *)data
{
    WS(weakSelf);
    [SVProgressHUD showWithStatus:@"头像上传中..."];
//    [self.dataTaskArray addObject:[PLHttpTools post:PLInterface_uploadFile params:@{@"userId":[PLUserInfoModel sharedInstance].userId,@"usageType":@"11",@"mimeType":@"png"} imageData:data result:^(NSDictionary *dic, NSError *error) {
//        if (error) {
//            [weakSelf handleNetworkError:error];
//        }
//        else
//        {
//            [weakSelf updateUIWithResponse:dic interface:PLInterface_uploadFile];
//            [SVProgressHUD showSuccessWithStatus:@"上传成功！"];
//            [PLUserInfoModel sharedInstance].imgSmall = dic[@"data"][@"urls"];
//            [cellInfoArray removeAllObjects];
//            [cellInfoArray addObject:@{@"img":[PLUserInfoModel sharedInstance].imgSmall,@"title":@"一点传奇"}];
//            [weakSelf.baseTableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:PLUserHeadImgChanedNotification object:nil];
//        }
//    }]];
}

#pragma mark Others

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
//压缩图片
- (UIImage *)thumbnailForAsset:(NSData *)asset maxPixelSize:(NSUInteger)size
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)asset, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef)
                                                              @{   (NSString *)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
                                                                   (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
                                                                   (NSString *)kCGImageSourceCreateThumbnailWithTransform :@YES,
                                                                   });
    
    CFRelease(source);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}

@end
