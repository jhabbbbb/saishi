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
- (NSMutableArray *)notificationList
{
    if (!_notificationList) _notificationList = [[NSMutableArray alloc] init];
    return _notificationList;
}

- (NSMutableArray *)affairsList
{
    if (!_affairsList) _affairsList = [[NSMutableArray alloc] init];
    return _affairsList;
}

- (NSMutableArray *)feedList
{
    if (!_feedList) _feedList = [[NSMutableArray alloc] init];
    return _feedList;
}

- (NSMutableArray *)fileList
{
    if (!_fileList) _fileList = [[NSMutableArray alloc] init];
    return _fileList;
}


//根据type("Tongzhi", "Dongtai", "Huiwu")和yeshu获取列表，在completion中更新UI
- (void)getDataWithType:(NSString *)type yeshu:(int)yeshu complete:(void (^)())completion
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameter = @{@"type": type, @"yeshu": [NSString stringWithFormat:@"%d", yeshu]};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/data" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        //NSLog(@"%@",dict);
        if ([type isEqualToString:@"Tongzhi"]){
            for (NSDictionary *dic in dict){
                [self.notificationList addObject:dic];
            }
        }
        else if ([type isEqualToString:@"Dongtai"]){
            for (NSDictionary *dic in dict){
                [self.feedList addObject:dic];
            }
        }
        else if ([type isEqualToString:@"Huiwu"]){
            for (NSDictionary *dic in dict){
                [self.affairsList addObject:dic];
            }
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
