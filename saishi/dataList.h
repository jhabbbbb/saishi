//
//  notificationList.h
//  saishi
//
//  Created by JinHongxu on 16/2/13.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface dataList : NSObject

@property (strong, nonatomic) NSArray *notificationList;
@property (strong, nonatomic) NSArray *affairsList;
@property (strong, nonatomic) NSArray *feedList;
@property (strong, nonatomic) NSArray *fileList;

- (void)getDataWithType:(NSString *)type complete:(void(^)())completion;

- (void)getFileList:(void(^)())completion;

@end
