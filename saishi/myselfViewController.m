//
//  myselfViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/9.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "myselfViewController.h"
#import "changePasswordViewController.h"
#import "loginViewController.h"
#import "mainTabBarController.h"
@interface myselfViewController ()

@property (nonatomic) BOOL logoutPermit;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portrait;

@end

@implementation myselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //从mainTabBarController获取用户名
    self.me = [(mainTabBarController *)self.navigationController.tabBarController me];
    
    //获取用户信息
    [self.me getUserInfo:^(NSString *name, NSString *danwei, NSString *zhiwu, NSString *portraitID) {
        self.namelabel.text = name;
        self.usernameLabel.text =[[NSString alloc]initWithFormat:@"账号：%@", self.me.username];
        self.danweiLabel.text = [[NSString alloc]initWithFormat:@"单位职务：%@%@", danwei, zhiwu];
        self.phoneLabel.text = self.me.username;
        
        //获取用户头像
        imageGetter *imgGetter = [[imageGetter alloc] init];
        [imgGetter getImageWithID:self.me.portraitID complete:^(){
            [self.portrait setImageWithURL:[NSURL URLWithString:imgGetter.imageURL]];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//segue to changePasswordViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changePassword"]){
        if ([segue.destinationViewController isKindOfClass:[changePasswordViewController class]]){
            changePasswordViewController *changePasswordVC = (changePasswordViewController *)segue.destinationViewController;
            changePasswordVC.me = self.me;
        }
    }
}

//登出
- (IBAction)logout:(UIButton *)sender {
    self.logoutPermit = NO;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


//登出网络请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_out" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"success");
             NSDictionary *dict = (NSDictionary *)responseObject;
             NSLog(@"%@", [dict objectForKey:@"msg"]);
             if ([[dict objectForKey:@"msg"] isEqualToString:@"登出成功"]){
                 loginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
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
}

@end
