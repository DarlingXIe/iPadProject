//
//  HMDropdownView.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMDropdownView.h"
#import "HMCategoryModel.h"
#import "XDLDistrictModel.h"
#import "HMDropdownLeftTableViewCell.h"
#import "HMDropdownRightTableViewCell.h"

@interface HMDropdownView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

//分类的左边选中模型
@property (nonatomic, strong) HMCategoryModel *selectCategoryLeftModel;

@property (nonatomic, strong) XDLDistrictModel *selectDistrictModel;

@end

@implementation HMDropdownView

/** 提供类方法, 快速创建View*/
+ (instancetype)dropdownView
{
    UINib *nib = [UINib nibWithNibName:@"HMDropdownView" bundle:nil];
    return [nib instantiateWithOwner:nil options:nil][0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //view默认的autoresizingMask是有值得. 因此, 当发生压缩/放大时, 视图也会发生响应的效果
    //iPad分辨率很大, 768 * 1024, popover默认320 * 480 . 当大的视图放到小的视图中, 就会压缩
    //关闭这个属性, 就可以保证不变
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - 表视图的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.categoryArray.count){
        
        if (tableView == self.leftTableView) {
        return self.categoryArray.count;
    } else {
        //为了显示右边数据 --> 需要先知道左边选中了谁 --> 实现表格的选中方法, 记录左边的数据
        return  self.selectCategoryLeftModel.subcategories.count;
        }
    }else{
        if (tableView == self.leftTableView) {
            return self.districtArray.count;
        } else {
            //为了显示右边数据 --> 需要先知道左边选中了谁 --> 实现表格的选中方法, 记录左边的数据
            return  self.selectDistrictModel.subdistricts.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.categoryArray.count){
    
        if (tableView == self.leftTableView) {
        //左边表格
        HMDropdownLeftTableViewCell *cell = [HMDropdownLeftTableViewCell dropdownLeftTableViewCellWithTableView:tableView];
        
        //1. 显示Label数据
        HMCategoryModel *categoryModel = self.categoryArray[indexPath.row];
        cell.textLabel.text = categoryModel.name;
        
        //2. 显示Image数据
        cell.imageView.image = [UIImage imageNamed:categoryModel.icon];
        
        //3. 设置cell的附属视图
        if (categoryModel.subcategories.count == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    } else {
        //右边表格
        HMDropdownRightTableViewCell *cell = [HMDropdownRightTableViewCell dropdownRightTableViewCellWithTableView:tableView];
        // 为了显示右边的数据  --> 需要知道左边选中了谁 --> tableView的选中方法中记录
        NSArray *categoryArray = self.selectCategoryLeftModel.subcategories;
        cell.textLabel.text = categoryArray[indexPath.row];
        return cell;
        }
    }else{
        if (tableView == self.leftTableView) {
            //左边表格
            HMDropdownLeftTableViewCell *cell = [HMDropdownLeftTableViewCell dropdownLeftTableViewCellWithTableView:tableView];
            //1. 显示Label数据
            XDLDistrictModel *districtModel = self.districtArray[indexPath.row];
            cell.textLabel.text = districtModel.name;
            //3. 设置cell的附属视图
            if (districtModel.subdistricts.count == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        } else {
            //右边表格
            HMDropdownRightTableViewCell *cell = [HMDropdownRightTableViewCell dropdownRightTableViewCellWithTableView:tableView];
            // 为了显示右边的数据  --> 需要知道左边选中了谁 --> tableView的选中方法中记录
            NSArray *subDistrictArray = self.selectDistrictModel.subdistricts;
            cell.textLabel.text = subDistrictArray[indexPath.row];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.categoryArray){
        if (tableView == self.leftTableView) {
        //1. 记录左边选中的模型
        self.selectCategoryLeftModel = self.categoryArray[indexPath.row];
        
        //2. 刷新右边数据
        [self.rightTableView reloadData];
        }
    }else{
        if (tableView == self.leftTableView) {
            //1. 记录左边选中的模型
          self.selectDistrictModel = self.districtArray[indexPath.row];
        }
    }
    //2. 刷新右边数据
    [self.rightTableView reloadData];
}
@end
