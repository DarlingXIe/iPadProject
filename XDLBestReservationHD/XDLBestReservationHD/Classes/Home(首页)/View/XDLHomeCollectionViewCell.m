//
//  XDLHomeCollectionViewCell.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "XDLHomeCollectionViewCell.h"
@interface XDLHomeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
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

@end
