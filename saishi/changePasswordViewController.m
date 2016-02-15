//
//  changePasswordViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/9.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "changePasswordViewController.h"

@interface changePasswordViewController ()

@end

@implementation changePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改密码网络请求
- (IBAction)changePassword:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameter = @{@"old_pwd": self.oldPassword.text, @"new_pwd" : self.password.text};
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/change_pwd" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"success");
         NSDictionary *dict = (NSDictionary *)responseObject;
         NSLog(@"%@", [dict objectForKey:@"msg"]);
         if ([[dict objectForKey:@"msg"] isEqualToString:@"密码修改成功"]){
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else {
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
             [alert show];
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}


@end
