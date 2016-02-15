//
//  imageGetter.h
//  saishi
//
//  Created by JinHongxu on 16/2/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface imageGetter : NSObject

@property (strong, nonatomic) NSString *imageURL;

- (void)getImageWithID:(NSString *)ID complete:(void(^)())completion;

@end
