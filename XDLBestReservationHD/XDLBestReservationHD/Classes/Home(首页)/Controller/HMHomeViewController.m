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
#import "YYModel.h"
#import "XDLDistrictModel.h"
#import "XDLCityModel.h"
#import "XDLConst.h"
@interface HMHomeViewController ()

@property (nonatomic, copy) NSString *selectCityName;

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
    
    [XDLNotificationCenter addObserver:self selector:@selector(cityVCDidChangeNotificaiton:) name:XDLCityDidChangeNotifacation object:nil];
    
}
#pragma mark - 通知
#pragma mark - 城市选择通知
-(void) cityVCDidChangeNotificaiton:(NSNotification *)notification{
    
    self.selectCityName = notification.userInfo[XDLCityNameKey];
    
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
    [categoryNavView addTarget:self action:@selector(categoryClick) forControlEvents:UIControlEventTouchUpInside];
    //3. 区域
    HomeNavView *districtNavView = [HomeNavView homeNavView];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtNavView];
    [districtNavView addTarget:self action:@selector(districtClick) forControlEvents:UIControlEventTouchUpInside];
    //4. 排序
    HomeNavView *sortNavView = [HomeNavView homeNavView];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortNavView];
    //[categoryNavView addTarget:self action:@selector(sortClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
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
    //1. 创建控制器
    HMCategoryViewController *categoryVC = [HMCategoryViewController new];
    
    //2. 设置以popover方式弹出
    categoryVC.modalPresentationStyle = UIModalPresentationPopover;
    
    //3. 获取Popover
    UIPopoverPresentationController *popoverC = categoryVC.popoverPresentationController;
    
    //4. 设置BarButtonItem属性
    popoverC.barButtonItem = self.navigationItem.leftBarButtonItems[1];
    
    //5. 模态弹出
    [self presentViewController:categoryVC animated:YES completion:nil];
    
}
#pragma mark -区域按钮点击方法
-(void)districtClick{
    NSLog(@"区域");
    //1. 创建控制器
    XDLDistrictViewController *districtVC = [XDLDistrictViewController new];
    NSArray * districtVc = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil]];
    NSArray * cityArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"XDLCityModel") json:districtVc];
    for (XDLCityModel * cityModel in cityArray){
        if([self.selectCityName isEqualToString:cityModel.name]){
            districtVC.districtModel = cityModel.districts;
        }
    }
    //2. 设置以popover方式弹出
    districtVC.modalPresentationStyle = UIModalPresentationPopover;
    //3. 获取Popover
    UIPopoverPresentationController *popoverC = districtVC.popoverPresentationController;
    //4. 设置BarButtonItem属性
    popoverC.barButtonItem = self.navigationItem.leftBarButtonItems[2];
    //5. 模态弹出
    [self presentViewController:districtVC animated:YES completion:nil];
    
}
#pragma mark - 排序按钮点击方法
-(void)sortClick{
    NSLog(@"排序");
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
*/

/*
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
