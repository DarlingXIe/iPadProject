//
//  HMNavigateController.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMNavigateController.h"

@interface HMNavigateController ()

@end

@implementation HMNavigateController
//只要头文件参与了编译就会调用
//+ (void)load
//{
//    NSLog(@"load");
//}
//当类第一次被创建时会调用

+ (void)initialize
{
    //1. 获取NavBar
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //2. 直接修改背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];

    UIBarButtonItem * item = [UIBarButtonItem appearance];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : MTColor(21, 188, 173)} forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateDisabled];
}

@end
