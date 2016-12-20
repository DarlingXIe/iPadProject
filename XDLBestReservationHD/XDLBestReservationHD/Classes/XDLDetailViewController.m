//
//  XDLDetailViewController.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/15.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLDetailViewController.h"
#import "XDLCollectCollectionViewController.h"
#import "DPAPI.h"
#import "XDLReturnDealModel.h"
#import "XDLDealModel.h"
#import "MJExtension.h"
#import "MTDealTool.h"
#import "XDLConst.h"

@interface XDLDetailViewController ()<DPRequestDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *IndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescLabel;
@property (weak, nonatomic) IBOutlet UILabel *CurrentPriceLabel;
//lastPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PurchasePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *BuyquicklyButton;

@property (weak, nonatomic) IBOutlet UIButton *refundabelButton;
@property (weak, nonatomic) IBOutlet UIButton *expiredRefundableButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, copy) NSString * webString;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, copy) NSString * recentDeal_id;

@end

@implementation XDLDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    [self requestData];
}
#pragma mark- setupUI
-(void)setupUI{
    
    self.webView.hidden = true;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dealModel.deal_h5_url]]];
    [self.infoImage sd_setImageWithURL:[NSURL URLWithString:self.dealModel.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    self.titleLabel.text = self.dealModel.title;
    
    self.DescLabel.text = self.dealModel.desc;
    
    self.CurrentPriceLabel.text = [NSString stringWithFormat:@"$ %@", self.dealModel.current_price];
    //原价详情
    NSDate * nowData = [NSDate new];
    
    NSDateFormatter * fmt = [NSDateFormatter new];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate * deadDate = [fmt dateFromString:self.dealModel.purchase_deadline];
    
    NSLog(@"---%@",self.dealModel.purchase_deadline);
    
    deadDate = [deadDate dateByAddingTimeInterval: 60 * 60 * 24];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:unit fromDate:nowData toDate:deadDate options:0];
    if(cmps.day > 365){
        [self.timeButton setTitle:@"一年之内不过期" forState:UIControlStateNormal];
        
    }else{
        [self.timeButton setTitle:[NSString stringWithFormat:@"%zd天%zd小时%zd分钟", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    self.collectButton.selected = [MTDealTool isCollected:self.dealModel];
    //dealwithrecentData
    [self recentData];
    
}
-(void)recentData{
    
    NSMutableDictionary * dealDic = [NSMutableDictionary dictionary];
    dealDic[MTRecentDealKey] = @[self.dealModel];
    if([MTDealTool isRecent:self.dealModel]){
        [MTDealTool removeRecentDeal:self.dealModel];
    }
    [MTDealTool addRecentDeal:self.dealModel];
    dealDic[MTIsRecentKey] = @YES;
    [XDLNotificationCenter postNotificationName:MTRecentStateDidChangeNotification object:nil userInfo:dealDic];
}


#pragma mark- 数据请求
-(void)requestData{
    
    DPAPI * apI = [DPAPI new];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //请求参数
    params[@"deal_id"] = self.dealModel.deal_id;
    
    [apI requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
}
#pragma mark- 数据请求模型处理
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSLog(@"%@",result);
    NSArray * dealArray = result[@"deals"];
    
    self.dealModel = [XDLDealModel yy_modelWithJSON:[dealArray lastObject]];
    
    self.refundabelButton.selected = self.dealModel.restrictions.is_refundable;
    
    self.expiredRefundableButton.selected = self.dealModel.restrictions.is_refundable;
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"error connect"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if([webView.request.URL.absoluteString isEqualToString:self.dealModel.deal_h5_url]){
        
        NSString * ID = [self.dealModel.deal_id substringFromIndex:[self.dealModel.deal_id rangeOfString:@"-"].location + 1];
        
        NSString *urlstr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", ID];
        
        self.webString = urlstr;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
        
    }else{
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        // 利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        // 获得页面
        //  NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
        // 显示webView
        webView.hidden = false;
        // 隐藏正在加载
    }
    [self.IndicatorView stopAnimating];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", request.URL);
    
    return true;
}
//点击事件buy
- (IBAction)buttonAction:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}
#pragma mark- buyQuicklyAction
- (IBAction)BuyQuicklyAction:(id)sender{
    
    self.webView.hidden = true;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dealModel.deal_h5_url]]];
    
    NSString * ID = [self.dealModel.deal_id substringFromIndex:[self.dealModel.deal_id rangeOfString:@"-"].location + 1];
    
    NSString *urlstr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/buy/%@", ID];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    
}
#pragma mark- collection
- (IBAction)collectFunction:(id)sender {
    
    NSMutableDictionary * dealDic = [NSMutableDictionary dictionary];
    dealDic[MTCollectDealKey] = @[self.dealModel];
    if(self.collectButton.isSelected){
        [MTDealTool removeCollectDeal:self.dealModel];
        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        dealDic[MTIsCollectKey] = @NO;
    }else{
        [MTDealTool addCollectDeal:self.dealModel];
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
        dealDic[MTIsCollectKey] = @YES;
    }
    self.collectButton.selected = !self.collectButton.isSelected;
    
    [XDLNotificationCenter postNotificationName:MTCollectStateDidChangeNotification object:nil userInfo:dealDic];

}
//5859c38d3eae2571df00028f iPhone
//5859be224544cb4e8e00168e iPad
- (IBAction)shareFunction:(id)sender {
        
}
#pragma mark 支持的屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
