//
//  notificationList.m
//  saishi
//
//  Created by JinHongxu on 16/2/13.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import "dataList.h"

@implementation dataList

//惰性实例化
- (NSArray *)notificationList
{
    if (!_notificationList) _notificationList = [[NSArray alloc] init];
    return _notificationList;
}

- (NSArray *)affairsList
{
    if (!_affairsList) _affairsList = [[NSArray alloc] init];
    return _affairsList;
}

- (NSArray *)feedList
{
    if (!_feedList) _feedList = [[NSArray alloc] init];
    return _feedList;
}

- (NSArray *)fileList
{
    if (!_fileList) _fileList = [[NSArray alloc] init];
    return _fileList;
}


//根据type("Tongzhi", "Dongtai", "Huiwu")获取列表，在completion中更新UI
- (void)getDataWithType:(NSString *)type complete:(void (^)())completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameter = @{@"type": type};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/data" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        //NSLog(@"%@",dict);
        if ([type isEqualToString:@"Tongzhi"]){
            self.notificationList = dict;
        }
        else if ([type isEqualToString:@"Dongtai"]){
            self.feedList = dict;
        }
        else if ([type isEqualToString:@"Huiwu"]){
            self.affairsList = dict;
        }
        
        completion();
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//获取文件列表
- (void)getFileList:(void (^)())completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/wenjian" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        self.fileList = dict;
        
        completion();
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end