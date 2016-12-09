//
//  XDLConst.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/9.
//  Copyright © 2016年 itcast. All rights reserved.
//
#ifdef DEBUG
#define MTLog(...) NSLog(__VA_ARGS__)
#else
#define MTLog(...)
#endif

#define MTColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0];

#define MTColorBg MTColor(230, 230, 230)
