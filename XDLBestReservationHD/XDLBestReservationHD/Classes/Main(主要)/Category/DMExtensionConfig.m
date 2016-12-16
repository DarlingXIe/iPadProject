//
//  DMExtensionConfig.m
//  DarlinMedia
//
//  Created by DalinXie on 16/11/26.
//  Copyright © 2016年 itdarlin. All rights reserved.
//

#import "DMExtensionConfig.h"
@implementation DMExtensionConfig
+ (void)load
{
    //第一种方法
//    [DMMediaModel mj_setupObjectClassInArray:^NSDictionary *{
//        return @{@"top_cmt" : [DMTopComments class]};
//    }];
     //第二种方法
    [XDLDealModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"desc" : @"description"
                 };
    }];
}
@end
