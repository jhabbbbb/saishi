//
//  meViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/16.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "imageGetter.h"
@interface meViewController : UITableViewController

@property (strong, nonatomic) user *me;

@end
