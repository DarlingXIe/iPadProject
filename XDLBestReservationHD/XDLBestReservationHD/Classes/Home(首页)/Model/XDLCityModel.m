//
//  XDLCityModel.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLCityModel.h"
#import "XDLDistrictModel.h"
@implementation XDLCityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"districts" : NSClassFromString(@"XDLDistrictModel")};
}
@end
