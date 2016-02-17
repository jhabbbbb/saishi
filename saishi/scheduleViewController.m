//
//  scheduleViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/17.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "scheduleViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
@interface scheduleViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation scheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123"]];
    NSLog(@"%f", imageView.bounds.size.height);
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = imageView.bounds.size;
    
    [self.scrollView setBounces:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
