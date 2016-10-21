//
//  UIBarButtonItem+XDLCategory.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIBarButtonItem+XDLCategory.h"

@implementation UIBarButtonItem (XDLCategory)
+(instancetype)barButtonItemWithTarget:(id)Target action:(SEL)Action Icon:(NSString*)Icon highlightedIcon:(NSString *)highlightedIcon
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:Icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedIcon] forState:UIControlStateHighlighted];
    
    //setting button size with customSize
    button.size = button.currentImage.size;
    
    [button addTarget:Target action:Action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
    
}
@end
