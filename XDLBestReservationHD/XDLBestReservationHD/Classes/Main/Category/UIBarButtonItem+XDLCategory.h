//
//  UIBarButtonItem+XDLCategory.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XDLCategory)

+(instancetype)barButtonItemWithTarget:(id)Target action:(SEL)Action Icon:(NSString*)Icon highlightedIcon:(NSString*)highlightedIcon;

@end
