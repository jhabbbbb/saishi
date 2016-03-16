//
//  loginViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/4.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "loginViewController.h"
#import "mainTabBarController.h"
#import "user.h"
@interface loginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) user *me;


@end

@implementation loginViewController

- (user *)me
{
    if (!_me) _me = [[user alloc] init];
    return _me;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //点击空白键盘消失
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    //监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//登录
- (IBAction)login:(UIButton *)sender {
    
    self.me.username = self.username.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameter = @{@"phone": self.username.text, @"pwd": self.password.text};
    
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

//点击空白键盘消失
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}

//界面上升
- (void)keyboardWillShow:(NSNotification *)notif {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -80.0;
        self.view.frame = frame;
    }];
}

//界面下降
- (void)keyboardWillHide:(NSNotification *)notif {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}


/*- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]){
        return [self.me checkPassword:self.password.text];
    }
    return NO;
}*/

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login"]){
        if ([segue.destinationViewController isKindOfClass:[mainTabBarController class]]){
            mainTabBarController *TabBarVC = (mainTabBarController *)segue.destinationViewController;
            TabBarVC.me = self.me;
        }
    }
}*/

@end
