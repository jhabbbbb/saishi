//
//  imageGetter.m
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "imageGetter.h"

@implementation imageGetter

//获取图片，这里只获取url, 在completion中为imageView加载图片
- (void)getImageWithID:(NSString *)ID complete:(void(^)())completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //要删！
    /*if (ID == [NSNull null]){
        ID = @"1";
    }*/
    
    NSDictionary *parameter = @{@"imgid": ID};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/get_img_url" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         //NSLog(@"get image success.");
         NSDictionary *dict = (NSDictionary *)responseObject;
         //NSLog(@"%@", dict);
         self.imageURL = [[NSString alloc] initWithFormat:@"http://121.42.157.180/qgfdyjnds/%@", [dict objectForKey:@"url"]];
         
         completion();
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         //NSLog(@"qingqiutupianError");
     }];

}

@end
