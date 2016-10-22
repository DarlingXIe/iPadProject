//
//  XDLHomeCollectionViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLHomeCollectionViewController.h"
#import "XDLCategoryViewController.h"
#import "XDLHomeNavView.h"

@interface XDLHomeCollectionViewController ()

@end

@implementation XDLHomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


-(instancetype)init{
    
    self = [super initWithCollectionViewLayout:[[UICollectionViewLayout alloc] init]];
    
    if(self){
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    //self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    
    [self setupRightNav];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
}
#pragma mark - setupLeftNavItems

-(void)setupLeftNav{
    
    //1. add logoItem
    UIBarButtonItem * logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"]style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //close userInteration
    logoItem.enabled = NO;
    
    //2. add categoryNavView
    //customView for leftButton
    XDLHomeNavView * catergoryNavView = [XDLHomeNavView XDLHomeNavView];
    
    UIBarButtonItem * catergoryItem = [[UIBarButtonItem alloc] initWithCustomView:catergoryNavView];
    
    [catergoryNavView addTarget:self action:@selector(categoryItemClick) forControlEvents:UIControlEventTouchUpInside];
    //3. add loction func
    XDLHomeNavView * districtNavView = [XDLHomeNavView XDLHomeNavView];
    
    UIBarButtonItem * districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtNavView];
    
    //4. add sorted func
    XDLHomeNavView * sortNavView = [XDLHomeNavView XDLHomeNavView];
    
    UIBarButtonItem * sortNavItem = [[UIBarButtonItem alloc] initWithCustomView:sortNavView];
    
    self.navigationItem.leftBarButtonItems = @[logoItem, catergoryItem, districtItem, sortNavItem];

}

#pragma mark - setupRightNavItems

-(void)setupRightNav{
    
    UIBarButtonItem * mapItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(mapItemClick) Icon:@"icon_map" highlightedIcon:@"icon_map_highlighted"];
    
    mapItem.customView.width = 60;
    
    
    UIBarButtonItem * searchItem = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(searchItemClick) Icon:@"icon_search" highlightedIcon:@"icon_search_highlighted"];
    
    searchItem.customView.width = 60;
    
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - clickCategoryButtonItem
-(void)categoryItemClick{
    NSLog(@"click categoryItem");
    
    //1.pop controller
    XDLCategoryViewController * categoryVC = [[XDLCategoryViewController alloc] init];
    //2.pop present method
    categoryVC.modalPresentationStyle = UIModalPresentationPopover;
    //3.setting popover
    UIPopoverPresentationController * popoverController = categoryVC.popoverPresentationController;
    //4.setting popover attributes
    popoverController.barButtonItem = self.navigationItem.leftBarButtonItems[1];
    //5.
    [self presentViewController:categoryVC animated:YES completion:^{
        NSLog(@"categoryVC success");
    }];
}
#pragma mark - clickMapButtonItem
-(void)mapItemClick{
    
    NSLog(@"map");
}
#pragma mark - clickSearchButtonItem
-(void)searchItemClick{
    
    NSLog(@"search")
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

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
