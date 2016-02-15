//
//  user.m
//  saishi
//
//  Created by JinHongxu on 16/2/8.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "user.h"

@interface user()

@end

@implementation user

- (BOOL)checkPassword:(NSString *)password
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"phone": self.username, @"pwd": password};
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/log_in" parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"SUCCESS");
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSString *msg = [dic objectForKey:@"msg"];
        if ([msg isEqualToString:@"登录成功"]){
            
        }
        else {
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return NO;
}

- (void)changePassword:(NSString *)password
{
    
}

- (void)changeportrait:(NSString *)newPortrait
{
    
}

@end
