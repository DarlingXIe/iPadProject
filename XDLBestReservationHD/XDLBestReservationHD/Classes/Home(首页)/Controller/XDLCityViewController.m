//
//  XDLCityViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/11.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLCityViewController.h"
#import "XDLCityGroupModel.h"
#import "YYModel.h"
#import "XDLConst.h"
#import "XDLSearchTableViewController.h"

static NSString * const cityGroupId = @"cityGroupId";

@interface XDLCityViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) NSArray * cityGroupArray;
@property (weak, nonatomic) IBOutlet UITableView *cityGroupTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) XDLSearchTableViewController * citySearchVc;

@end

@implementation XDLCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    self.cityGroupArray = [self loadData];
}
#pragma mark - setupUI
-(void)setupUI{
    
    self.title = @"选择城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(cancelIitemClick) icon:@"btn_navigation_close" highlighticon:@"btn_navigation_close_hl"];
    
    self.cityGroupTable.sectionIndexColor = XDLTintColor;
    
    self.searchBar.tintColor = XDLTintColor;
    
    self.cityGroupTable.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
    
}
-(void)cancelIitemClick{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
#pragma mark - loadData
-(NSArray *) loadData{
    
    NSArray *cityGroupPlist = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"cityGroups.plist" ofType:nil]];
    
    NSArray * cityGroupModel = [NSArray yy_modelArrayWithClass:NSClassFromString(@"XDLCityGroupModel") json:cityGroupPlist];
    
    return cityGroupModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBar 
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    self.navigationController.navigationBar.hidden = true;
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
    [searchBar setShowsCancelButton:true animated:true];
    
    self.coverButton.alpha = 0.5;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    self.navigationController.navigationBar.hidden = false;
    
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    [searchBar setShowsCancelButton:false animated:true];
    
    self.coverButton.alpha = 0;
    
    self.searchBar.text = @"";
    
    self.citySearchVc.view.hidden = true;
}
#pragma mark textChange
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length > 0){
        self.citySearchVc.view.hidden = false;
        self.citySearchVc.searchText = searchText;
    }else{
        self.citySearchVc.view.hidden = true;
    }
}
#pragma mark  取消按钮点击
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //放弃了第一响应者, 就等于结束编辑, 就会调用结束编辑的方式
    [searchBar resignFirstResponder];
}
#pragma mark 遮盖按钮点击
- (IBAction)coverButtonClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma  mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.cityGroupArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XDLCityGroupModel * cityGroupModel = self.cityGroupArray[section];
    return cityGroupModel.cities.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    XDLCityGroupModel * cityGroupName = self.cityGroupArray[section];
    return cityGroupName.title;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //1. 先获取模型数据
    XDLCityGroupModel *cityGroupModel = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = cityGroupModel.cities[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XDLCityGroupModel * cityGroupModel = self.cityGroupArray[indexPath.section];
    [XDLNotificationCenter postNotificationName:XDLCityDidChangeNotifacation object:nil userInfo:@{XDLCityNameKey:cityGroupModel.cities[indexPath.row]}];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 设置分组的索引标题
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //使用For循环, 获取每个分组的标题, 最后返回Array
    
    //这句话相当于去查询数据, 返回就是Array
    return [self.cityGroupArray valueForKey:@"title"];
}

-(XDLSearchTableViewController *) citySearchVc{
    
    if(_citySearchVc == nil){
        
        XDLSearchTableViewController * sVC = [XDLSearchTableViewController new];
        [self addChildViewController:sVC];
        [self.view addSubview:sVC.view];
        [sVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.coverButton);
        }];
        _citySearchVc = sVC;
    }
    return _citySearchVc;

}


-(NSArray *)cityGroupArray{
    if(!_cityGroupArray){
        _cityGroupArray = [NSArray array];
    }
    return _cityGroupArray;
}
@end
