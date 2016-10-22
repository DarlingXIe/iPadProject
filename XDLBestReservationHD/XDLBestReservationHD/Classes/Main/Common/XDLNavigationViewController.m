//
//  XDLNavigationViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLNavigationViewController.h"

@interface XDLNavigationViewController ()

@end

@implementation XDLNavigationViewController

+(void)initialize{
    
    UINavigationBar * navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    
    //[navBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [navBar setShadowImage:[[UIImage alloc] init]];
}

@end
