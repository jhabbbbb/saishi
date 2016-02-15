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
    
    self.username.delegate = self;
    self.password.delegate = self;
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
    NSDictionary *parameters = @{@"phone": self.username.text, @"pwd": self.password.text};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_in" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        //NSLog(@"success");
        NSDictionary *dict = (NSDictionary *)responseObject;
        //NSLog(@"%@", [dict objectForKey:@"msg"]);
        if ([[dict objectForKey:@"msg"] isEqualToString:@"登陆成功"]){
            mainTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            vc.me = self.me;
            [self presentViewController:vc animated:YES completion:^{
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[dict objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定"otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -80.0;
        self.view.frame = frame;
    }];
    return YES;
}//键盘出现界面上升

- (BOOL)textFieldShouldEndEditing:(UITextField *)thetextField {
    
    if (thetextField == self.password){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 0.0;
            self.view.frame = frame;
        }];
    }
    return YES;
}//键盘消失界面下降


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
