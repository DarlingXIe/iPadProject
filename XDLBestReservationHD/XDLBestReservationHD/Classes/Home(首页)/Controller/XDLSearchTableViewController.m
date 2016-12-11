//
//  XDLSearchTableViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLSearchTableViewController.h"
#import "XDLCityModel.h"
#import "XDLConst.h"
@interface XDLSearchTableViewController ()

@property (nonatomic,strong) NSArray * citiesArray;

@property (nonatomic, strong) NSMutableArray *searchResutArray;

@end

@implementation XDLSearchTableViewController

-(void)setSearchText:(NSString *)searchText{
    
    _searchText = [searchText copy];
    
    _searchText = _searchText.lowercaseString;
    
    [self.searchResutArray removeAllObjects];
    
    for (XDLCityModel * cityName in self.citiesArray){
        if([cityName.name containsString:_searchText] || [cityName.pinYin containsString:_searchText] || [cityName.pinYinHead containsString:_searchText]){
            [self.searchResutArray addObject:cityName.name];
        }
    }
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *cityArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil]];
    
    self.citiesArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"HMCityModel") json:cityArray];
    
    self.searchResutArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.searchResutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * ID = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.searchResutArray[indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [NSString stringWithFormat:@"共有%zd个搜索结果", self.searchResutArray.count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [XDLNotificationCenter postNotificationName:XDLCityDidChangeNotifacation object:nil userInfo:@{XDLCityNameKey:self.searchResutArray[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
