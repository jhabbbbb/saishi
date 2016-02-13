//
//  mainTabBarController.m
//  saishi
//
//  Created by JinHongxu on 16/2/9.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "mainTabBarController.h"

@interface mainTabBarController ()

@end

@implementation mainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    //NSDictionary *parameter = @{@"type": @"Tongzhi"};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/data?type=Tongzhi" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success");
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@", dict);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
