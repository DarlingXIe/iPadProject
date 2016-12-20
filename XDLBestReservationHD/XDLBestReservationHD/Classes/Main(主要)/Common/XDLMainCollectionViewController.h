//
//  XDLMainCollectionViewController.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPAPI.h"
#import "XDLConst.h"
#import "XDLDealModel.h"
#import "MJExtension.h"
#import "XDLHomeCollectionViewCell.h"
#import "XDLDetailViewController.h"

@interface XDLMainCollectionViewController : UICollectionViewController

- (void)setupParams:(NSMutableDictionary *)params;

@end
