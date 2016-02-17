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
#import "QuickLook/QuickLook.h"
@interface filesViewController : UITableViewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) dataList *list;

@end
