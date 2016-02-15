//
//  fileCell.h
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface fileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSString *fileID;
@property (strong, nonatomic) NSString *fileURL;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *time;

- (void)getFileURL;

@end
