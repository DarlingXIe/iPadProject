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
//#import "XDLConst.h"
#import "HMCategoryModel.h"
//#import "XDLHomeCollectionViewCell.h"
//#import "XDLDetailViewController.h"
#import "AwesomeMenu.h"
#import "Masonry.h"
//#import "DPAPI.h"
//#import "XDLDealModel.h"
//#import "MJExtension.h"
//static NSString * const cellId = @"cellId";
#import "XDLMainCollectionViewController.h"
#import "XDLSearchCollectionViewController.h"
#import "HMNavigateController.h"
#import "XDLCollectCollectionViewController.h"
#import "XDLRecentCollectionViewController.h"


@interface HMHomeViewController ()<AwesomeMenuDelegate>

@property(nonatomic,strong) NSString * selectCategoryName;
@property(nonatomic,strong) NSString * selectDistrictName;
@property(nonatomic, strong) NSNumber * saveSortNumber;

@property (nonatomic, strong) NSArray * citiesArray;
@property (nonatomic, copy) NSString *selectCityName;
@property (nonatomic, strong) NSNumber *selectSortValue;

@property (nonatomic, weak) HomeNavView *categoryNavView;
@property (nonatomic, weak) HomeNavView *districtNavView;
@property (nonatomic, weak) HomeNavView *sortNavView;

@property (nonatomic, strong) HMCategoryViewController *CategoryViewController;
@property (nonatomic, strong) XDLDistrictViewController * districtViewController;
@property (nonatomic, strong) XDLSortViewController * sortViewController;

//Awesome Button X
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic) NSInteger currentPage;
//loadDataArray.
@property (nonatomic, strong) NSMutableArray * dealArray;

@property (nonatomic, strong) UIImageView * noDataImageView;

//@property (nonatomic, strong) DPRequest * lastRequest;

@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation HMHomeViewController

static NSString * const dealCellID = @"dealCellID";

#pragma mark : iOS8出现的屏幕旋转方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //保证第一次运行view能够适配屏幕的尺寸
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    self.collectionView.backgroundColor = XDLColor(230, 230, 230);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDLHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:dealCellID];
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
    //排序通知
    [XDLNotificationCenter addObserver:self selector:@selector(districtDisChangeNotifaction:) name:XDLDistrictDidChangeNotifacation object:nil];
    
    [self setupAwesomeMenu];
    [self.collectionView.mj_header beginRefreshing];
    
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
    //[self loadData];
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:true completion:nil];
    
}
#pragma mark - 城市选择通知
-(void)cityVCDidChangeNotificaiton:(NSNotification *)notification{

    self.selectCityName = notification.userInfo[XDLCityNameKey];
    
    [self.districtNavView setTitle:[NSString stringWithFormat:@"%@-全部",self.selectCityName]];
    [self.districtNavView setSubtitle:@""];
    //加载数据。
    //[self loadData];
    [self.collectionView.mj_header beginRefreshing];
    
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
    //[self loadData];
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 排序选择通知
-(void)sortDidChangeNotification:(NSNotification *)noti{
    
    XDLSortModel * sortModel = noti.userInfo[XDLSortModelKey];
    
    [self.sortNavView setSubtitle:sortModel.label];
    
    self.saveSortNumber = sortModel.value;
    //load data
    //[self loadData];
    [self.collectionView.mj_header beginRefreshing];
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
    if(self.selectCityName){
        XDLSearchCollectionViewController * searchCollectionView = [[XDLSearchCollectionViewController alloc] init];
        searchCollectionView.cityName = self.selectCityName;
        HMNavigateController * nav = [[HMNavigateController alloc] initWithRootViewController:searchCollectionView];
        [self presentViewController:nav animated:true completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择城市后在搜索"];
    }
    
}
#pragma mark 地图按钮点击方法
- (void)mapItemClick
{
    NSLog(@"地图");
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
#pragma mark lazy setupUI
-(XDLDistrictViewController *)districtViewController{
    if(_districtViewController == nil){
        XDLDistrictViewController * DisVc = [XDLDistrictViewController new];
        _districtViewController = DisVc;
    }
    return _districtViewController;
}
#pragma mark-setupAwesomeMenu
-(void)setupAwesomeMenu{
    //1. 中间的startItem
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]
                                  initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                  highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                  ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                  highlightedContentImage:nil];
    //2. 添加其他几个按钮
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]
                              initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                              highlightedImage:nil
                              ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"]
                              highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0, item1, item2, item3];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:items];
    [self.view addSubview:menu];
    
    menu.rotateAddButton = true;
//调整角度可以把rototeAngle和wholeAngle一起调整
//    menu.menuWholeAngle = -M_PI;
//    menu.rotateAngle = M_PI_2;
    menu.menuWholeAngle = M_PI_2;
    menu.startPoint = CGPointMake(20, 0);
    //menu.nearRadius = 5;
    menu.endRadius = 100;
    menu.farRadius = 50;
    menu.delegate = self;
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(self.inset);
        make.bottom.offset(-self.inset);
    }];
    menu.alpha = 0.5;
}
#pragma mark 必须实现的方法
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
            NSLog(@"1");
            break;
        case 1:
        {
            HMNavigateController * nav = [[HMNavigateController alloc] initWithRootViewController:[[XDLCollectCollectionViewController alloc] init]];
            [self presentViewController:nav animated:true completion:nil];
            break;
        }
        case 2:{
            HMNavigateController * nav = [[HMNavigateController alloc] initWithRootViewController:[[XDLRecentCollectionViewController alloc] init]];
            [self presentViewController:nav animated:true completion:nil];
            break;
        }
        case 3:
            NSLog(@"4");
            break;
        default:
            break;
    }
}
#pragma mark- AwesomeMenu 代理方法
-(void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    [UIView animateWithDuration:0.25 animations:^{
        menu.alpha = 1;
    }];

}
-(void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    [UIView animateWithDuration:0.25 animations:^{
        menu.alpha = 0.5;
    }];
}

#pragma mark- 实现父类的方法
-(void)setupParams:(NSMutableDictionary *)params{
    
    params[@"city"] = self.selectCityName == nil? @"北京" : self.selectCityName;
    
    if (self.selectCategoryName) {
        params[@"category"] = self.selectCategoryName;
    }
    // 区域
    if (self.selectDistrictName) {
        params[@"region"] = self.selectDistrictName;
    }
    // 排序
    if (self.saveSortNumber) {
        params[@"sort"] = self.saveSortNumber;
    }
}
#pragma mark- dealWithNoImage
-(UIImageView *)noDataImageView{
    
    if(!_noDataImageView){
        _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.collectionView addSubview:_noDataImageView];
        [_noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.collectionView);
        }];
    }
    return _noDataImageView;
}
@end
