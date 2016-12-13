//
//  HMHomeViewController.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//

#import "HMHomeViewController.h"
#import "HomeNavView.h"
#import "HMCategoryViewController.h"
#import "XDLDistrictViewController.h"
#import "XDLSortViewController.h"
#import "YYModel.h"
#import "XDLDistrictModel.h"
#import "XDLSortModel.h"
#import "XDLCityModel.h"
#import "XDLConst.h"
#import "HMCategoryModel.h"

@interface HMHomeViewController ()

@property(nonatomic,strong) NSString * selectCategoryName;

@property(nonatomic,strong) NSString * selectDistrictName;

@property (nonatomic, strong) NSArray * citiesArray;
@property (nonatomic, copy) NSString *selectCityName;
@property (nonatomic, strong) NSNumber *selectSortValue;

@property (nonatomic, weak) HomeNavView *categoryNavView;
@property (nonatomic, weak) HomeNavView *districtNavView;
@property (nonatomic, weak) HomeNavView *sortNavView;

@property (nonatomic, strong) HMCategoryViewController *CategoryViewController;
@property (nonatomic, strong) XDLDistrictViewController * districtViewController;
@property (nonatomic, strong) XDLSortViewController * sortViewController;



@end

@implementation HMHomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = XDLColor(230, 230, 230);
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // 设置左边导航栏按钮
    [self setupLeftNav];
    // 设置右边导航栏按钮
    [self setupRightNav];
    // 分类通知
    [XDLNotificationCenter addObserver:self selector:@selector(categoryDidChangeNotificaiton:) name:XDLCategoryDidChangeNotifacation object:nil];
    //
    [XDLNotificationCenter addObserver:self selector:@selector(cityVCDidChangeNotificaiton:) name:XDLCityDidChangeNotifacation object:nil];
    //排序的通知
    [XDLNotificationCenter addObserver:self selector:@selector(sortDidChangeNotification:) name:XDLSortDidChangeNotifacation object:nil];
    [XDLNotificationCenter addObserver:self selector:@selector(districtDisChangeNotifaction:) name:XDLDistrictDidChangeNotifacation object:nil];
}
#pragma mark - 通知
#pragma mark - 分类选择通知
-(void)categoryDidChangeNotificaiton:(NSNotification *)notification{
    
    HMCategoryModel * model = notification.userInfo[XDLCategoryModelKey];
    
    NSString * subtitle = notification.userInfo[XDLCategorySubtitleKey];
    
    [self.categoryNavView setTitle:model.name];
    
    [self.categoryNavView setSubtitle:subtitle];
    
    [self.categoryNavView setIcon:model.icon hightlightIcon:model.highlighted_icon];
    
    //分情况记录请求的参数
    if([model.name isEqualToString:@"全部分类"]){
        self.selectCategoryName = nil;
    }else if(model.subcategories.count == 0 || [subtitle isEqualToString:@"全部"]){
        self.selectCategoryName = model.name;
    }else{
        self.selectCategoryName = subtitle;
    }
    
    //loadData;
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
#pragma mark - 城市选择通知
-(void)cityVCDidChangeNotificaiton:(NSNotification *)notification{

    self.selectCityName = notification.userInfo[XDLCityNameKey];
    
    [self.districtNavView setTitle:[NSString stringWithFormat:@"%@-全部",self.selectCityName]];
    [self.districtNavView setSubtitle:@""];
    //加载数据。
    
    
}
#pragma mark - 区域的选择
-(void)districtDisChangeNotifaction:(NSNotification *)noti{
    
    XDLDistrictModel * districtModel = noti.userInfo[XDLDistrictModelKey];
    
    NSString * subDis = noti.userInfo[XDLDistrictSubtitleKey];
    
    [self.districtNavView setTitle:[NSString stringWithFormat:@"%@-%@", self.selectCityName, districtModel.name]];
    
    [self.districtNavView setSubtitle:subDis];
    
    if([districtModel.name isEqualToString:@"全部"]){
        self.selectDistrictName = nil;
    }else if(districtModel.subdistricts.count == 0 || [subDis isEqualToString:@"全部"]){
        self.selectDistrictName = districtModel.name;
    }else{
        self.selectDistrictName = subDis;
    }
    //loadData
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 排序选择通知
-(void)sortDidChangeNotification:(NSNotification *)noti{
    
    XDLSortModel * sortModel = noti.userInfo[XDLSortModelKey];
    
    [self.sortNavView setSubtitle:sortModel.label];
    
    //load data
    
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark -  移除通知
- (void)dealloc
{
    [XDLNotificationCenter removeObserver:self];
}
#pragma mark - 导航栏设置

#pragma mark 设置左边导航栏按钮
- (void)setupLeftNav {
    //1. Logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_meituan_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
    //使用Enabled就可以取消交互
    //如果是普通UI控件, 我们可以使用userInteractionEnabled来禁止交互
    logoItem.enabled = NO;
    //2. 分类
    HomeNavView *categoryNavView = [HomeNavView homeNavView];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryNavView];
    // 添加导航栏View的点击wssw事件 继承了UIControl, 就会有下面的方法
    // 这句代码有点类似于注册通知
    [categoryNavView setTitle:@"全部分类"];
    [categoryNavView setSubtitle:@""];
    [categoryNavView setIcon:@"icon_category_-1"  hightlightIcon:@"icon_category_highlighted_-1"];
    [categoryNavView addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
    self.categoryNavView = categoryNavView;
    //3. 区域
    HomeNavView *districtNavView = [HomeNavView homeNavView];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtNavView];
    [districtNavView setTitle:@"北京－全部"];
    [districtNavView setSubtitle:@""];
    [districtNavView setTarget:self action:@selector(districtClick)];
    self.districtNavView = districtNavView;
    //4. 排序
    HomeNavView *sortNavView = [HomeNavView homeNavView];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortNavView];
    [sortNavView setTitle:@"排序"];
    [sortNavView setSubtitle:@"默认排序"];
    [sortNavView setIcon:@"icon_sort" hightlightIcon:@"icon_sort_highlighted"];
    [sortNavView setTarget:self action:@selector(sortClick)];
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
    self.sortNavView = sortNavView;
}
#pragma mark 设置右边导航栏按钮
- (void)setupRightNav {
    
    //1. 添加地图按钮
    UIBarButtonItem *mapItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(mapItemClick) icon:@"icon_map" highlighticon:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    //2. 添加搜索按钮
    UIBarButtonItem *searchItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(searchItemClick) icon:@"icon_search" highlighticon:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    // 设置右边导航栏按钮时, 谁先写, 谁靠右
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}
#pragma mark 分类按钮点击方法
- (void)categoryClick
{
    if(self.CategoryViewController == nil){
        //1. 创建控制器
        HMCategoryViewController *categoryVC = [HMCategoryViewController new];
        //2. 设置以popover方式弹出
        categoryVC.modalPresentationStyle = UIModalPresentationPopover;
     
        self.CategoryViewController = categoryVC;
    }
    //3. 获取Popover
    UIPopoverPresentationController * popoverC = self.CategoryViewController.popoverPresentationController;
    //4. 设置BarButtonItem属性
    popoverC.barButtonItem = self.navigationItem.leftBarButtonItems[1];
    //5. 模态弹出
    [self presentViewController:self.CategoryViewController animated:YES completion:nil];
    
}
#pragma mark -区域按钮点击方法
-(void)districtClick{
    NSLog(@"区域");
    //1. 创建控制器
    XDLDistrictViewController *districtVC = [XDLDistrictViewController new];
        //2. 设置以popover方式弹出
    districtVC.modalPresentationStyle = UIModalPresentationPopover;
        //districtVC.modalPresentationStyle = UIModalPresentationPopover;
    for (XDLCityModel * cityModel in self.citiesArray){
        if([self.selectCityName isEqualToString:cityModel.name]){
            districtVC.districtModel = cityModel.districts;
        }
    }
    //3. 获取Popover
    UIPopoverPresentationController *popoverC = districtVC.popoverPresentationController;
    //4. 设置BarButtonItem属性
    popoverC.barButtonItem = self.navigationItem.leftBarButtonItems[2];
    //5. 模态弹出
    [self presentViewController:districtVC animated:YES completion:nil];
    
     self.selectCityName = self.selectCityName == nil? @"北京" : self.selectCityName;
}
#pragma mark - 排序按钮点击方法
-(void)sortClick{
    NSLog(@"排序");
    //1. 创建控制器
    if(self.sortViewController == nil){
        XDLSortViewController *SortVC = [XDLSortViewController new];
    //2. 设置以popover方式弹出
        SortVC.modalPresentationStyle = UIModalPresentationPopover;
        self.sortViewController = SortVC;
    }
    //3. 获取Popover
    UIPopoverPresentationController *popoverC = self.sortViewController.popoverPresentationController;
    //4. 设置BarButtonItem属性
    popoverC.barButtonItem = self.navigationItem.leftBarButtonItems[3];
    //5. 模态弹出
    [self presentViewController:self.sortViewController animated:YES completion:nil];
}

#pragma mark 搜索按钮点击方法
- (void)searchItemClick
{
    NSLog(@"搜索");
}
#pragma mark 地图按钮点击方法
- (void)mapItemClick
{
    NSLog(@"地图");
}
#pragma mark <UICollectionViewDataSource>
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of items
//    return 0;
//}
//
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
    return cell;
}
#pragma mark 城市数据懒加载
- (NSArray *)citiesArray
{
    if (_citiesArray == nil) {
        // 获取总的城市数据
        NSArray *citiesPlist = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"cities.plist" ofType:nil]];
        _citiesArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"XDLCityModel") json:citiesPlist];
    }
    return _citiesArray;
}

#pragma mark lazy
-(XDLDistrictViewController *)districtViewController{
    if(_districtViewController == nil){
        XDLDistrictViewController * DisVc = [XDLDistrictViewController new];
        _districtViewController = DisVc;
    }
    return _districtViewController;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*//*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
@end
