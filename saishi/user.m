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

- (NSString *)danwei
{
    if (!_danwei) _danwei = @"";
    return _danwei;
}

- (NSString *)zhiwu
{
    if (!_zhiwu) _zhiwu = @"";
    return _zhiwu;
}

- (NSString *)name
{
    if (!_name) _name = @"";
    return _name;
}


//获取用户全部信息，在completion中更新UI
- (void)getUserInfo:(void(^)(NSString *name, NSString *danwei, NSString *zhiwu, NSString *portraitID))completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_userinfo" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"success");
         NSDictionary *dict = (NSDictionary *)responseObject;
         //NSLog(@"%@", dict);
         self.name = [dict objectForKey:@"username"];
         self.danwei = [dict objectForKey:@"danwei"];
         self.zhiwu = [dict objectForKey:@"zhifu"];
         self.portraitID = [dict objectForKey:@"icon"];
         
         completion(self.name, self.danwei, self.zhiwu, self.portraitID);
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"Error: %@", error);
     }];

}



@end
