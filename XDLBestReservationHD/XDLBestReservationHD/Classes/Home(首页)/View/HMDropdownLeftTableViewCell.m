//
//  HMDropdownLeftTableViewCell.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMDropdownLeftTableViewCell.h"

@implementation HMDropdownLeftTableViewCell

/** 提供类方法, 快速创建左边cell*/
+ (instancetype)dropdownLeftTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"leftCell";
    
    HMDropdownLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HMDropdownLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        //在创建cell的时候, 设置默认背景
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        
        //设置选中背景
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return cell;
}

@end
