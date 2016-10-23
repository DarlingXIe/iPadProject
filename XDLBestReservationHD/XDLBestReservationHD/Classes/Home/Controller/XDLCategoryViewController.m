//
//  XDLCategoryViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLCategoryViewController.h"
#import "XDLDropdownView.h"

@interface XDLCategoryViewController ()



@end

@implementation XDLCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)setupUI{
    
    XDLDropdownView * dropdownView = [XDLDropdownView dropdownView];
    
    [self.view addSubview:dropdownView];
    
    self.preferredContentSize = dropdownView.size;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
