//
//  filesViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/12.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "dataList.h"
#import "fileCell.h"
@interface filesViewController : UITableViewController

@property (strong, nonatomic) dataList *list;

@end
