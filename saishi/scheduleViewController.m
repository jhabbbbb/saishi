//
//  scheduleViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/17.
//  Copyright © 2016年 cn.twt.edu. All rights reserved.
//

#import "scheduleViewController.h"

@interface scheduleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


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
    /*UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123"]];
    NSLog(@"%f", imageView.bounds.size.height);
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = imageView.bounds.size;
    
    [self.scrollView setBounces:NO];*/
    
    /*AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    

    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_img_url" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"get image success.");
         NSDictionary *dict = (NSDictionary *)responseObject;
         //NSLog(@"%@", dict);
         if (dict){
             //内容html解析
             NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
             [html appendString:[dict objectForKey:@"msg"]];
             [html appendString:@"</body></html>"];
             [self.webView loadHTMLString:[html description] baseURL:nil];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];*/
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ame.moe/tju/schedule.html"]];
    [self.webView loadRequest:request];
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
