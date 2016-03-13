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

- (NSArray *)fileList
{
    if (!_fileList) _fileList = [[NSArray alloc] init];
    return _fileList;
}

//把请求到的数据排序加入到list中，解决置顶问题
- (void)addObjectstolist:(NSMutableArray *)list withArray:(NSArray *)dict
{
    for (NSDictionary *dic in dict){
        if (![dic isEqual: [NSNull null]]){//若dic非空
            if ([[dic objectForKey:@"isup"] isEqualToString:@"1"]){//若要插入一条新的置顶消息
                //查看原来有没有置顶消息，有就将它移除，根据api，它不会从列表中消失
                    if ([list count]&&[[[list firstObject] objectForKey:@"isup"] isEqualToString:@"1"]){
                        [list removeObjectAtIndex:0];
                    }
                //把新的置顶消息插入到第0位
                [list insertObject:dic atIndex:0];
            }
            else {
                [list addObject:dic];
            }
        }
    }
}

//根据type("Tongzhi", "Dongtai", "Huiwu")和yeshu获取列表，在completion中更新UI
- (void)getDataWithType:(NSString *)type yeshu:(int)yeshu complete:(void (^)())completion relogin:(void (^)())relogin fail:(void (^)())fail
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameter = @{@"type": type, @"yeshu": [NSString stringWithFormat:@"%d", yeshu]};
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/data" parameters:parameter progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        //NSLog(@"%@",dict);
        if ([type isEqualToString:@"Tongzhi"]){
            [self addObjectstolist:self.notificationList withArray:dict];
        }
        else if ([type isEqualToString:@"Dongtai"]){
            [self addObjectstolist:self.feedList withArray:dict];
        }
        else if ([type isEqualToString:@"Huiwu"]){
            [self addObjectstolist:self.affairsList withArray:dict];
        }
        
        completion();
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        fail();
    }];
}

//获取文件列表
- (void)getFileList:(void (^)())completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:@"http://121.42.157.180/qgfdyjnds/index.php/Api/wenjian" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *dict = (NSArray *)responseObject;
        //NSLog(@"%@", dict);
        self.fileList = dict;
        
        completion();
        
    }
    failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
