//
//  launchViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/16.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "user.h"
@interface launchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *schoolName;
@property (weak, nonatomic) IBOutlet UIImageView *schoolIcon;
@property (weak, nonatomic) IBOutlet UIImageView *image;



@property (strong, nonatomic) user *me;

@end
