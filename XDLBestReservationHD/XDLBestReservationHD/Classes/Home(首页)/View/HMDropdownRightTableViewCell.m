//
//  HMDropdownRightTableViewCell.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMDropdownRightTableViewCell.h"

@implementation HMDropdownRightTableViewCell


/** 提供类方法, 快速创建右边cell*/
+ (instancetype)dropdownRightTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"rightCell";
    
    HMDropdownRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HMDropdownRightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        //在创建cell的时候, 设置默认背景
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        
        //设置选中背景
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
    }

    return cell;
}

@end
