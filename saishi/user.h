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
@property (strong, nonatomic) NSString *portrait;
@property (strong, nonatomic) NSString *realName;

- (void)changePassword:(NSString *)password;

- (void)changePortrait:(NSString *)newPortrait;

@end
