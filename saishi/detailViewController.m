//
//  detailViewController.m
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.content loadHTMLString:[self renderHTMLWithTitle:self.title content:self.text time:self.time] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (NSString *)renderHTMLWithTitle:(NSString *)title content:(NSString *)content time:(NSString *)time {
    NSString *load = [NSString stringWithFormat:@"<!DOCTYPE html> \n"
                      "<html> \n"
                      "<head> \n"
                      "<meta charset=\"utf-8\"> \n"
                      "<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n"
                      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n"
                      "<link href=\"bootstrap.css\" rel=\"stylesheet\"> \n"
                      "</head> \n"
                      "<body> \n"
                      "<div class=\"container\"> \n"
                      "<div class=\"row\"> \n"
                      "<div class=\"col-sm-12\" style=\"font-size: 16px;\"> \n"
                      "<h3>%@</h3> \n"
                      "<br> \n"
                      "%@ \n"
                      "<br><br> \n"
                      "</div> \n"
                      "<div class=\"col-sm-12\" style=\"color: #666666; font-size: 16px;\">%@</div> \n"
                      "</div></div> \n"
                      "<script src=\"bootstrap.min.js\"></script> \n"
                      "<script src=\"jquery.min.js\"></script> \n"
                      "<script src=\"bridge.js\"></script> \n"
                      "</body> \n"
                      "</html>" ,title, content, time];
    return load;
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
