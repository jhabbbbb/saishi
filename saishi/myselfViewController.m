//
//  myselfViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/9.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "myselfViewController.h"
#import "changePasswordViewController.h"

@interface myselfViewController ()

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"changePassword"]){
        if ([segue.destinationViewController isKindOfClass:[changePasswordViewController class]]){
            changePasswordViewController *changePasswordVC = (changePasswordViewController *)segue.destinationViewController;
            changePasswordVC.me = self.me;
        }
    }
}


@end
