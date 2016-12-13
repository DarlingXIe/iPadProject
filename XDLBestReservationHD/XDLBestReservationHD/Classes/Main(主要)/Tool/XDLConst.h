//
//  XDLConst.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

//EXTERN : 代表外面的类可以访问
//UIKIT_EXTERN : 用于适配C++语言的 , 建议使用这种写法
//定义字符串, 先写类型, 后面跟 *const. 如果是基本类型, 先写const, 后跟类型
//UIKIT_EXTERN const CGSize

//UIKIT_EXTERN: 自动区分C语言和C++
UIKIT_EXTERN NSString *const XDLCityDidChangeNotifacation;
UIKIT_EXTERN NSString *const XDLCityNameKey;

// 分类通知
UIKIT_EXTERN NSString *const XDLCategoryDidChangeNotifacation;
UIKIT_EXTERN NSString *const XDLCategoryModelKey;
UIKIT_EXTERN NSString *const XDLCategorySubtitleKey;

// 区域通知
UIKIT_EXTERN NSString *const XDLDistrictDidChangeNotifacation;
UIKIT_EXTERN NSString *const XDLDistrictModelKey;
UIKIT_EXTERN NSString *const XDLDistrictSubtitleKey;

// 排序通知
UIKIT_EXTERN NSString *const XDLSortDidChangeNotifacation;
UIKIT_EXTERN NSString *const XDLSortModelKey;

// Size的宽度
UIKIT_EXTERN const CGFloat XDLCellWidth;

