//
//  XDLHomeCollectionViewCell.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLHomeCollectionViewCell.h"
@interface XDLHomeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *InfoImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *LastPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *CurrentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *PurchaseCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *NewShopImage;

@end

@implementation XDLHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)setDealModel:(XDLDealModel *)dealModel{
    
    _dealModel = dealModel;
    
    [self.InfoImageView sd_setImageWithURL:[NSURL URLWithString:dealModel.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.titleLabel.text = dealModel.title;
    //self.titleLabel.text = @"textLabel";
    self.DescInfoLabel.text = dealModel.desc;
    //self.DescInfoLabel.text = @"textLabel";
    
    self.CurrentPriceLabel.text = [NSString stringWithFormat:@"$ %@", dealModel.current_price];
    
    self.LastPriceLabel.text = [NSString stringWithFormat:@"$ %@", dealModel.list_price];
    
    self.PurchaseCountLabel.text = [NSString stringWithFormat:@"已出售: %zd", dealModel.purchase_count];

    //根据时间去判断是否有新shop；
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter * dateFmt = [NSDateFormatter new];
    
    dateFmt.dateFormat = @"MM-dd-yyyy";
    
    NSString * nowDateStr = [dateFmt stringFromDate:nowDate];
    
    self.NewShopImage.hidden = [nowDateStr compare:dealModel.publish_date] == NSOrderedDescending ? YES : NO;
}


@end
