//
//  launchViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/16.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "launchViewController.h"
#import "mainTabBarController.h"
#import "loginViewController.h"
@interface launchViewController ()

@end

@implementation launchViewController

- (user *)me
{
    if (!_me) _me = [[user alloc] init];
    return _me;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameter = [userDefaults objectForKey:@"loginInfo"];
    if (parameter) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_in" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             //NSLog(@"success");
             NSDictionary *dict = (NSDictionary *)responseObject;
             //NSLog(@"%@", [dict objectForKey:@"msg"]);
             if ([[dict objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
                 
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults setObject:parameter forKey:@"loginInfo"];
                 [userDefaults synchronize];
                 
                 self.me.username = [parameter objectForKey:@"phone"];
                 
                 mainTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
                 vc.me = self.me;
                 
                 [self presentViewController:vc animated:YES completion:nil];
             }
             else {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
                 [alert show];
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

    }
    else {
        loginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:vc animated:YES completion:nil];
    }
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
