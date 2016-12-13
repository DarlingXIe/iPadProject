//
//  XDLSortViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/11.
//  Copyright © 2016年 itcast. All rights reserved.
//
#import "XDLSortViewController.h"
#import "XDLSortModel.h"
#import "XDLConst.h"
@interface XDLSortViewController ()

@property(nonatomic, strong) NSArray * dataArray;

@end

@implementation XDLSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [self loadData];
    [self setupUI];
}
-(void)setupUI{
    
    NSInteger count = self.dataArray.count;
    CGFloat width = 100;
    CGFloat height = 30;
    CGFloat margin = 15;
    
    for(int i = 0; i < count; i ++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        XDLSortModel * model = self.dataArray[i];
        [button setTitle:model.label forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_highlighted"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
        button.width = width;
        button.height = height;
        button.x = margin;
        button.y = margin + (button.height + margin) * i;
        [self.view addSubview:button];
    }
    CGFloat contentwidth = 2 * margin + width;
    CGFloat contentheight = (margin + height) * count + margin;
    self.preferredContentSize = CGSizeMake(contentwidth, contentheight);
}

-(void)clickbutton:(UIButton *)button{
    NSLog(@"clickSortButton");
    [XDLNotificationCenter postNotificationName:XDLSortDidChangeNotifacation object:nil userInfo:@{XDLSortModelKey :self.dataArray[button.tag]}];
}

-(NSArray *)loadData{
   NSArray * arrayData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil]];
   NSArray * arrayModel = [NSArray yy_modelArrayWithClass:NSClassFromString(@"XDLSortModel") json:arrayData];
    return arrayModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
