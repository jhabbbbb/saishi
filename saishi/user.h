//
//  user.h
//  saishi
//
//  Created by JinHongxu on 16/2/8.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface user : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *portraitID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *danwei;
@property (strong, nonatomic) NSString *zhiwu;

- (void)getUserInfo:(void(^)(NSString *name, NSString *danwei, NSString *zhiwu, NSString *portraitID))completion;//获得用户的姓名，单位职务，头像ID

@end
