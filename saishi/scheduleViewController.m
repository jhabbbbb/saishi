//
//  scheduleViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/17.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "scheduleViewController.h"
#import "CoreLocation.h"
#import "BNCoreServices.h"
@interface scheduleViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,CLLocationManagerDelegate>{
    double currentLongitude, currentLatitude;
    double destLongitude, destLatitude;
}


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSURLCache *urlCache;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;

@property (assign, nonatomic) BN_NaviType naviType;

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation scheduleViewController

- (CLLocationManager *)locationManager
{
    if (!_locationManager) _locationManager = [[CLLocationManager alloc] init];
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //从mainTabBarController获取用户
    self.me = [(mainTabBarController *)self.navigationController.tabBarController me];
    
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    /*UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123"]];
    NSLog(@"%f", imageView.bounds.size.height);
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = imageView.bounds.size;
    
    [self.scrollView setBounces:NO];*/
    
    /*AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    

    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_img_url" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"get image success.");
         NSDictionary *dict = (NSDictionary *)responseObject;
         //NSLog(@"%@", dict);
         if (dict){
             //内容html解析
             NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
             [html appendString:[dict objectForKey:@"msg"]];
             [html appendString:@"</body></html>"];
             [self.webView loadHTMLString:[html description] baseURL:nil];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];*/

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.42.157.180/qgfdyjnds/index.php/Index/scheduleios"]];
    [self.webView loadRequest:request];
    
    
}


//获取自身位置
- (void)startStandardUpdates
{
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 5; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLatitude = currentLocation.coordinate.latitude;
        currentLongitude = currentLocation.coordinate.longitude;
        [self.locationManager stopUpdatingLocation];
        if ([self checkServicesInited]) {
            _naviType = BN_NaviTypeReal;
            [self startNavi];
        }
    }
}


//获取目的地位置
- (void)getDestLocation:(NSString *)str
{
    int len = [str length];
    int i = len-1;
    NSMutableString *destLat = [[NSMutableString alloc] initWithCapacity:42];
    NSMutableString *destlong = [[NSMutableString alloc] initWithCapacity:42];
    NSString *nstr = [str substringWithRange:NSMakeRange(i,1)];
    while (i > 0 && ![nstr isEqualToString:@","]){
        [destLat insertString:nstr atIndex:0];
        i--;
        nstr = [str substringWithRange:NSMakeRange(i,1)];
    }
    
    //此时nstr是逗号
    i--;
    nstr = [str substringWithRange:NSMakeRange(i,1)];
    while (i > 0 && ![nstr isEqualToString:@"/"]){
        [destlong insertString:nstr atIndex:0];
        i--;
        nstr = [str substringWithRange:NSMakeRange(i,1)];
    }
    
    destLongitude = [destlong doubleValue];
    destLatitude = [destLat doubleValue];
}

//从webView获取字符串
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        //NSLog(@"%@", [url absoluteString]);
        [self getDestLocation:[url absoluteString]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"是否发起导航"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"好的",nil];
        [alertView show];
        
        /*if([[UIApplication sharedApplication]canOpenURL:url])
         {
         [[UIApplication sharedApplication]openURL:url];
         }*/
        return NO;
    }
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        
        [self startStandardUpdates];
    }
}


//导航
- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)startNavi
{
    
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    NSLog(@"%f %f", currentLongitude, currentLatitude);
    startNode.pos.x = currentLongitude;//longitude
    startNode.pos.y = currentLatitude;//latitude
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    NSLog(@"%f %f", destLongitude, destLatitude);
    endNode.pos.x = destLongitude;//longitude
    endNode.pos.y = destLatitude;//latitude
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}


#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出电子狗页面");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"me"]){
        if ([segue.destinationViewController isKindOfClass:[meViewController class]]){
            meViewController *meVC = (meViewController *)segue.destinationViewController;
            meVC.me = self.me;
        }
    }
}

@end
