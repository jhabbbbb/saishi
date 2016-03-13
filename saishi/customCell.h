//
//  customCell.h
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;

@property (strong, nonatomic) NSString *ID;//数据的ID
@property (strong, nonatomic) NSString *time;//数据的时间

@property (strong, nonatomic) NSString *contentText;


@end
