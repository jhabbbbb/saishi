//
//  mainTabBarController.h
//  saishi
//
//  Created by JinHongxu on 16/2/9.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
#import "myselfViewController.h"
@interface mainTabBarController : UITabBarController

@property (strong, nonatomic) user *me;

@end
