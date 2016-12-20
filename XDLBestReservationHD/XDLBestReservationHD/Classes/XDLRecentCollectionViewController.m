//
//  XDLCollectCollectionViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLRecentCollectionViewController.h"
#import "DPAPI.h"
#import "MTDealTool.h"
#import "XDLDetailViewController.h"
#import "XDLHomeCollectionViewCell.h"
#import "XDLConst.h"
#import "XDLDealModel.h"
//NSString *const MTDone = @"完成";
//NSString *const MTEdit = @"编辑";

#define MTString(str) [NSString stringWithFormat:@" %@ ", str]

@interface XDLRecentCollectionViewController ()<DPRequestDelegate,XDLHomeCollectionViewCellDelegate>

@property (nonatomic, strong) UIImageView * noDataImageView;

@property (nonatomic, strong) NSMutableArray *deals;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) UIBarButtonItem * backItem;

@property (nonatomic, strong) UIBarButtonItem * selectAllItem;

@property (nonatomic, strong) UIBarButtonItem * unselectAllItem;

@property (nonatomic, strong) UIBarButtonItem * removeItem;

@property (nonatomic, assign) CGFloat inset;

@end

@implementation XDLRecentCollectionViewController

#pragma mark- dealWithNoImage
-(UIImageView *)noDataImageView{
    
    if(!_noDataImageView){
        _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_latestBrowse_empty"]];
        [self.collectionView addSubview:_noDataImageView];
        [_noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.collectionView);
        }];
    }
    return _noDataImageView;
}

-(NSMutableArray *)deals{
    if(!_deals){
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

-(UIBarButtonItem *)backItem{
    if(!_backItem){
        _backItem = [UIBarButtonItem barBuutonItemWithTarget:self action:@selector(backAction) icon:@"icon_back" highlighticon:@"icon_back_highlighted"];
    }
    return _backItem;
}

-(UIBarButtonItem *)selectAllItem{
    if(!_selectAllItem){
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"selectAll") style:UIBarButtonItemStyleDone target:self action:@selector(selectAllItemAction)];
    }
    return _selectAllItem;
}

-(UIBarButtonItem *)unselectAllItem{
    
    if(!_unselectAllItem){
        _unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"unselectAll") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAllItemAction)];
    }
    return _unselectAllItem;
}

-(UIBarButtonItem *)removeItem{
    if(!_removeItem){
        _removeItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"removeAll") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
    }
    return _removeItem;
}

#pragma mark- navDealItem
-(void)selectAllItemAction{
    
    for(XDLDealModel *deal in self.deals){
        deal.checking = true;
    }
    [self.collectionView reloadData];
    self.removeItem.enabled = true;
}

-(void)unselectAllItemAction{
    
    for(XDLDealModel * deal in self.deals){
        deal.checking = false;
    }
    [self.collectionView reloadData];
    
    self.removeItem.enabled = false;
}

-(void)remove{
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for(XDLDealModel *deal in self.deals){
        if(deal.checking){
            [MTDealTool removeRecentDeal:deal];
            [tempArray addObject:deal];
        }
    }
    [self.deals removeObjectsInArray:tempArray];
    
    [self.collectionView reloadData];
    
}

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(305, 305);
    
    return [self initWithCollectionViewLayout:layout];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"浏览记录";
    
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDLHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    self.collectionView.backgroundColor = XDLColor(230, 230, 230);
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editItemAction:)];
    
    self.navigationItem.rightBarButtonItem.enabled = (self.deals.count != 0);
    
    [XDLNotificationCenter addObserver:self selector:@selector(RecentStateChange:) name:MTRecentStateDidChangeNotification object:nil];
    
    [self loadMoreData];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark- collectStateChange
-(void)RecentStateChange:(NSNotification *)info{
    
    if ([info.userInfo[MTIsRecentKey] boolValue]) {
        
        [self.deals insertObject:info.userInfo[MTRecentDealKey] atIndex:0];
    }
    [self.collectionView reloadData];
    
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    
    [self loadMoreData];
    
}
#pragma mark- removeNotificaiton
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backAction{
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark- transitionToSize
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    NSInteger col = size.width > size.height ? 3 : 2;
    
    CGFloat inset = (size.width - col*XDLCellWidth) / (col + 1);
    
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    layout.minimumLineSpacing = inset;
    
    self.inset = inset;
}
-(void)editItemAction:(UIBarButtonItem *)item{
    
    
    if([item.title isEqualToString:@"编辑"]){
        item.title = @"完成";
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.removeItem];
        for (XDLDealModel *deal in self.deals) {
            deal.editing = true;
        }
    }else{
        item.title = @"编辑";
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        for (XDLDealModel *deal in self.deals) {
            deal.editing = false;
        }
    }
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadMoreData{
    
    self.currentPage++;
    
    [self.deals addObjectsFromArray:[MTDealTool RecentDeals:self.currentPage]];
    
    [self.collectionView reloadData];
    
    [self.collectionView.mj_footer endRefreshing];
    
    self.navigationItem.rightBarButtonItem.enabled = (self.deals.count != 0);
    
}
#pragma mark UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    self.collectionView.mj_footer.hidden = (self.deals.count == [MTDealTool collectDealsCount]);
    
    self.noDataImageView.hidden = (self.deals.count != 0);
    
    return self.deals.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XDLDetailViewController * detailVC = [XDLDetailViewController new];
    detailVC.dealModel = self.deals[indexPath.row];
    [self presentViewController:detailVC animated:true completion:^{
//        [self.deals insertObject:self.deals[indexPath.row] atIndex:0];
//        [collectionView reloadData];
        NSLog(@"completion present");
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XDLHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dealModel = self.deals[indexPath.row];
    cell.delegate  = self;
    return cell;
}
@end
