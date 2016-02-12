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

- (IBAction)login:(UIButton *)sender {
    
    self.me.username = self.username.text;
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]){
        return [self.me checkPassword:self.password.text];
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"login"]){
        if ([segue.destinationViewController isKindOfClass:[mainTabBarController class]]){
            mainTabBarController *TabBarVC = (mainTabBarController *)segue.destinationViewController;
            TabBarVC.me = self.me;
        }
    }
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

@end
