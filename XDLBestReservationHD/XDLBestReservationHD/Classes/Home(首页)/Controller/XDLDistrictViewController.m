//
//  XDLDistrictViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/10.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLDistrictViewController.h"
#import "HMDropdownView.h"
#import "XDLCityViewController.h"
#import "HMNavigateController.h"
@interface XDLDistrictViewController ()

@end

@implementation XDLDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
}
-(void)setupUI{
    //1. 加载下拉菜单
    HMDropdownView *dropdownView = [HMDropdownView dropdownView];
    //2. 添加到视图上
    [self.view addSubview:dropdownView];
    UIView * navView = self.view.subviews[0];
    dropdownView.y = navView.bounds.size.height;
    //3. 设置内容控制器(popover)大小
    CGFloat height = CGRectGetMaxY(dropdownView.frame);
    self.preferredContentSize = CGSizeMake(dropdownView.size.width,height);
    dropdownView.districtArray = self.districtModel;
    NSLog(@"%@", NSStringFromCGSize(dropdownView.frame.size));
    
}
- (IBAction)clickChangeCity:(id)sender {
    //dismiss before controller
    [self dismissViewControllerAnimated:true completion:nil];
    //create new controller
    XDLCityViewController * cityViewController = [XDLCityViewController new];
    //change to new controller
    HMNavigateController * nav = [[HMNavigateController alloc] initWithRootViewController:cityViewController];
    //
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    //
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:true completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
