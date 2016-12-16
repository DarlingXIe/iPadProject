//
//  XDLDealModel.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/14.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLDealModel.h"

#import "NSString+XDLCategory.h"

@implementation XDLDealModel

//定义模型的desc 对应 description
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

-(void)setList_price:(NSString *)list_price{
    _list_price = list_price.dealPriceString;
}

-(void)setCurrent_price:(NSString *)current_price{
    _current_price = current_price.dealPriceString;
}

@end
