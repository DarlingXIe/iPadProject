//
//  XDLHomeNavView.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLHomeNavView.h"

@implementation XDLHomeNavView

+(instancetype)XDLHomeNavView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"XDLHomeNavView" owner:nil options:nil].firstObject;
}



@end
