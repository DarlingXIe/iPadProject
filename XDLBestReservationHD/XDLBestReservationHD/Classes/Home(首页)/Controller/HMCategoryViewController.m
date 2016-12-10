//
//  HMCategoryViewController.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMCategoryViewController.h"
#import "HMDropdownView.h"
#import "YYModel.h"
@interface HMCategoryViewController ()

@end

@implementation HMCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 加载下拉菜单
    HMDropdownView *dropdownView = [HMDropdownView dropdownView];
    
    //2. 添加到视图上
    [self.view addSubview:dropdownView];
    
    //3. 设置内容控制器(popover)大小
    self.preferredContentSize = dropdownView.size;
    
    //4. 获取数据模型
    NSArray *categoryPlist = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"categories.plist" ofType:nil]];
    
    dropdownView.categoryArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"HMCategoryModel") json:categoryPlist];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
