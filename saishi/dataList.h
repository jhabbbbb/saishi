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

@property (strong, nonatomic) NSMutableArray *notificationList;
@property (strong, nonatomic) NSMutableArray *affairsList;
@property (strong, nonatomic) NSMutableArray *feedList;
@property (strong, nonatomic) NSArray *fileList;

- (void)getDataWithType:(NSString *)type yeshu:(int)yeshu complete:(void(^)())completion relogin:(void (^)())relogin fail:(void (^)())fail;

- (void)getFileList:(void(^)())completion;

@end
