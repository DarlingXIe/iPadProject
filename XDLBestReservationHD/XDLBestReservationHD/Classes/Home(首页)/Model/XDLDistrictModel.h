//
//  XDLDistrictModel.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDLDistrictModel : NSObject

@property (nonatomic, copy) NSString *name;
/** 子区域数据*/
@property (nonatomic, strong) NSArray * subdistricts;

@end
