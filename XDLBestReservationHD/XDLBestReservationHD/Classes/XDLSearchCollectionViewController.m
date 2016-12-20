//
//  XDLSearchCollectionViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLSearchCollectionViewController.h"

@interface XDLSearchCollectionViewController ()<UISearchBarDelegate>

@end

@implementation XDLSearchCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}
#pragma mark- setupUI
-(void)setupUI{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(back) icon:@"icon_back"highlighticon:@"icon_back_highlighted"];

    UISearchBar * searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键子";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}
#pragma mark- searchdelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.collectionView.mj_header beginRefreshing];

    [searchBar resignFirstResponder];
}
-(void)back{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)setupParams:(NSMutableDictionary *)params{
    params[@"city"] = self.cityName;
    UISearchBar * bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
