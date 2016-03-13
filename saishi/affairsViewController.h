//
//  affairsViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/12.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "dataList.h"
#import "customCell.h"
#import "imageGetter.h"
#import "detailViewController.h"
#import "SVPullToRefresh.h"
#import "meViewController.h"
#import "user.h"
#import "mainTabBarController.h"
@interface affairsViewController : UITableViewController

@property (strong, nonatomic) dataList *list;
@property (strong, nonatomic) user *me;
@end
