//
//  XDLCityModel.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDLCityModel : NSObject

/** 名字*/
@property (nonatomic, copy) NSString *name;
/** 子区域数据*/
@property (nonatomic, strong) NSString *pinYin;

@property (nonatomic, strong) NSString *pinYinHead;

@property (nonatomic, strong) NSArray * districts;


@end
