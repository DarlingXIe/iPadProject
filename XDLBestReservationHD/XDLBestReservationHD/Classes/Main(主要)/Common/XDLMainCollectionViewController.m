//
//  XDLMainCollectionViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLMainCollectionViewController.h"

@interface XDLMainCollectionViewController ()<DPRequestDelegate>

//Awesome Button X
@property (nonatomic, assign) CGFloat inset;
@property (nonatomic) NSInteger currentPage;
//loadDataArray.
@property (nonatomic, strong) NSMutableArray * dealArray;

@property (nonatomic, strong) UIImageView * noDataImageView;

@property (nonatomic, strong) DPRequest * lastRequest;

@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation XDLMainCollectionViewController

-(void)setupParams:(NSMutableDictionary *)params{
    
}

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(XDLCellWidth, XDLCellWidth);
        self = [self initWithCollectionViewLayout:layout];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewWillTransitionToSize:[UIScreen mainScreen].bounds.size withTransitionCoordinator:self.transitionCoordinator];
    
    self.collectionView.backgroundColor = XDLColor(230, 230, 230);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XDLHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupRefresh];
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
#pragma mark- setupRefresh
-(void)setupRefresh{
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //[self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.collectionView.mj_footer.hidden = true;
}
#pragma mark-loadData 分类请求数据
-(void)loadData{
    
    DPAPI * apI = [DPAPI new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //请求参数
    [self setupParams:params];
    // 每页的条数
    params[@"limit"] = @20;
    // 页码
    params[@"page"] = @(self.currentPage);
    
    self.lastRequest = [apI requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
-(void)loadNewData{
    self.currentPage = 1;
    [self loadData];
}
-(void)loadMoreData{
    self.currentPage++;
    [self loadData];
}
#pragma mark-requestDataDelegate
#pragma mark-请求成功
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"reslut: %@", result[@"deals"]);
    
    if(self.lastRequest != request){
        return;
    }
    if(self.currentPage == 1){
        [self.dealArray removeAllObjects];
    }
    [result writeToFile:@"/Users/DalinXie/Desktop/iPadProject/DarlinR.plist"
             atomically:true];
    self.dealArray = [XDLDealModel mj_objectArrayWithKeyValuesArray:result[@"deals"]];
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    //判断是否加载完整的首页的数据,隐藏,mj_footer
    self.totalCount = [result[@"total_count"] integerValue];
    [self.collectionView reloadData];
    
}
#pragma mark-请求失败
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
    if(self.lastRequest != request){
        return;
    }
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"connect error"]];
    if(self.currentPage != 1){
        self.currentPage--;
    }
}
#pragma mark UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    self.collectionView.mj_footer.hidden = self.totalCount == self.dealArray.count ;
    self.noDataImageView.hidden = self.dealArray.count != 0;
    return self.dealArray.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XDLDetailViewController * detailVC = [XDLDetailViewController new];
    detailVC.dealModel = self.dealArray[indexPath.row];
    [self presentViewController:detailVC animated:true completion:nil];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XDLHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dealModel = self.dealArray[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
#pragma mark- dealWithDealArray
-(NSMutableArray *)dealArray{
    
    if(!_dealArray){
        _dealArray = [[NSMutableArray alloc] init];
    }
    return _dealArray;
}
@end
