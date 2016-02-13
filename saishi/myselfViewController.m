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

@interface myselfViewController ()

@property (nonatomic) BOOL logoutPermit;

@end

@implementation myselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"changePassword"]){
        return YES;
    }
    if ([identifier isEqualToString:@"logout"]){
        NSLog(@"che");
        return self.logoutPermit;
    }
    return NO;
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changePassword"]){
        if ([segue.destinationViewController isKindOfClass:[changePasswordViewController class]]){
            changePasswordViewController *changePasswordVC = (changePasswordViewController *)segue.destinationViewController;
            changePasswordVC.me = self.me;
        }
    }
}

- (IBAction)logout:(UIButton *)sender {
    self.logoutPermit = NO;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        
        loginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:vc animated:YES completion:^{
        }];
    }
}

@end
