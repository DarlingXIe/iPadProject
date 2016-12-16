//
//  XDLReturnDealModel.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/14.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDLReturnDealModel : NSObject

/** 是否支持随时退款，0：不是，1：是*/
@property (nonatomic, assign) NSInteger is_refundable;

@property (nonatomic, copy) NSString * special_tips;

@end
