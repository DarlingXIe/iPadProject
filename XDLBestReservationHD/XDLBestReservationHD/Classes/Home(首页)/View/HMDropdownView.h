//
//  HMDropdownView.h
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDropdownView : UIView

//增加分类属性
@property (nonatomic, strong) NSArray *categoryArray;

/** 提供类方法, 快速创建View*/
+ (instancetype)dropdownView;

@end
