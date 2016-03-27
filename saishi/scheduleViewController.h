//
//  scheduleViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/17.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "user.h"
#import "mainTabBarController.h"
#import "meViewController.h"
@interface scheduleViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) user *me;
@end
