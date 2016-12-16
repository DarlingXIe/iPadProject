//
//  XDLDealModel.h
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/14.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDLReturnDealModel.h"

@interface XDLDealModel : NSObject
/** 团购单ID */
@property (copy, nonatomic) NSString *deal_id;

/** 团购标题 */
@property (copy, nonatomic) NSString *title;

//不能使用description
/** 团购描述 */
@property (copy, nonatomic) NSString *desc;
//要想保持服务器的价格, NSString  NSNumber
//NSDecimalNumber --> 专门表示价格的一个类
/** 团购包含商品原价值 */
@property (nonatomic, copy) NSString *list_price;

/** 团购价格 */
@property (nonatomic, copy) NSString *current_price;

/** 团购当前已购买数 */
@property (assign, nonatomic) NSInteger purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (copy, nonatomic) NSString *image_url;

/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (copy, nonatomic) NSString *s_image_url;

/** 团购发布上线日期*/
@property (copy, nonatomic) NSString *publish_date;

/** 团购HTML5页面链接，适用于移动应用和联网车载应用*/
@property (copy, nonatomic) NSString *deal_h5_url;

/** 团购单的截止购买日期*/
@property (copy, nonatomic) NSString *purchase_deadline;

/** 首页商品数据和详情数据, 只有个别字段不一样. 因此公用一个模型*/
/**
 字典直接嵌套字典的情况, 不需要额外转换.
 字典嵌套数组, 数组里面又是字典, 此时需要额外转换
 */
@property (copy,nonatomic) XDLReturnDealModel * restrictions;

@end
