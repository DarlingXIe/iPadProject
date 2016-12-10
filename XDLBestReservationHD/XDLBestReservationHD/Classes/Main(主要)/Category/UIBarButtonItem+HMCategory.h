//
//  UIBarButtonItem+HMCategory.h
//  MeiTuanHD
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HMCategory)

/** 提供类方法, 返回带有高亮图像的 BarButtonItem*/
+ (instancetype)barBuutonItemWithTarget:(id)target action:(SEL)action icon:(NSString *)icon highlighticon:(NSString *)highlighticon;

@end
