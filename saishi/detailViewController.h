//
//  detailViewController.h
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIWebView *content;


@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *text;

@end
