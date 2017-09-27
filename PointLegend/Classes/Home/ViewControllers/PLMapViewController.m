//
//  PLMapViewController.m
//  PointLegend
//
//  Created by ydcq on 15/11/17.
//  Copyright © 2015年 CenturyGalaxyNetworkDevelopment. All rights reserved.
//

#import "PLMapViewController.h"
#import "JZLocationConverter.h"

@interface PLMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *locationService;
}

@end

@implementation PLMapViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    baseNavItem.title = @"百度地图";
    
    locationService = [[BMKLocationService alloc] init];
    locationService.desiredAccuracy = kCLLocationAccuracyBest;
    locationService.distanceFilter = 1;
    [locationService startUserLocationService];
    
    _mapView = [[BMKMapView alloc] init];
    [self.view addSubview:_mapView];
    WS(weakSelf);
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(63.7);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _mapView.userTrackingMode=BMKUserTrackingModeNone;//地图模式
    locationService.delegate = self;
    [locationService stopUserLocationService];
    [_mapView setShowsUserLocation:NO];
    [locationService startUserLocationService];
    _mapView.showsUserLocation = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    locationService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MapViewDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //百度地图经纬度转换为火星坐标
    CLLocationCoordinate2D coord = [JZLocationConverter bd09ToGcj02:coordinate];
    
    [_mapView setRegion:BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.001, 0.005))];
    
//    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
//    option.reverseGeoPoint = coord;
//    
//    BMKGeoCodeSearch *obj = [[BMKGeoCodeSearch alloc] init];
//    if ([obj reverseGeoCode:option]) {
//        NSLog(@"111");
//    }
//    obj.delegate = self;
    
    CLLocation *afterlocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    //地理信息反编码
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:afterlocation completionHandler:^(NSArray *placemark,NSError *error)
     {
         if (error) {
             
         }
         else
         {
             CLPlacemark *mark=[placemark objectAtIndex:0];
             
             NSDictionary *dic = mark.addressDictionary;
             
             NSLog(@"%@",dic);
         }
     }];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%d",toInterfaceOrientation);
    WS(weakSelf);
    if (toInterfaceOrientation==3 || toInterfaceOrientation==4) {
        [self.baseNavBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(41.7);
        }];
        
        [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.height.equalTo(weakSelf.view.mas_height).with.offset(-42);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(42);
        }];
    }
    else if (toInterfaceOrientation==1 || toInterfaceOrientation==2) {
        [self.baseNavBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(63.7);
        }];
        
        [self.mapView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view.mas_centerX);
            make.height.equalTo(weakSelf.view.mas_height).with.offset(-NAV_BAR_HEIGHT);
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(NAV_BAR_HEIGHT);
        }];
    }
}

#pragma mark BMKGeoCodeSearchDelegate

//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
//{
//    if (error) {
//        NSLog(@"%d",error);
//    }
//    else
//    {
//        NSLog(@"%@",result);
//    }
//}

@end
