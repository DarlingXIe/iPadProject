//
//  XDLHomeCollectionViewCell.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/13.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDLDealModel, XDLHomeCollectionViewCell;
@protocol XDLHomeCollectionViewCellDelegate <NSObject>

@optional

- (void)dealCellCheckingStateDidChange:(XDLHomeCollectionViewCell *)cell;

@end


@interface XDLHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) XDLDealModel * dealModel;

@property (nonatomic,strong) id<XDLHomeCollectionViewCellDelegate>delegate;

@end
