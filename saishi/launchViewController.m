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
    int i = arc4random()%2;//随机选取
    NSArray *imageArray = @[@"mainBuilding.png", @"9thBuilding.png"];
    [self.image setImage:[UIImage imageNamed:imageArray[i]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addAnimation];
}

//禁止 Launchscreen 自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)addAnimation{

    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                        CGRect frame = self.schoolIcon.frame;
                         frame.origin.x = self.schoolName.frame.origin.x/2 - 36;
                         frame.origin.y = 91.0;
                         frame.size.width = 72.0;
                         frame.size.height = 90;
                         self.schoolIcon.frame = frame;
                     } completion:nil];
    
    [UIView animateWithDuration:1.5
                          delay:1.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.schoolName.alpha = 1.0;
                         self.image.alpha = 1.0;
                         
                     } completion:^(BOOL finished){
                         if (finished){
                             [self autoLogin];
                         }
                     }];
    
}

//有缓存时自动登录
- (void)autoLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameter = [userDefaults objectForKey:@"loginInfo"];
    if (parameter) {
        
        //自动登录
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_in" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             //NSLog(@"success");
             NSDictionary *dict = (NSDictionary *)responseObject;
             //NSLog(@"%@", [dict objectForKey:@"msg"]);
             if ([[dict objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
                 
                 //保存登录状态
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
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"登录失败,检查一下网络吧～" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
             [alert show];
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
