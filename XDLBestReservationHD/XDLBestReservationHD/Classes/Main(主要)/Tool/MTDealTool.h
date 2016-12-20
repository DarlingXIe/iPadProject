//
//  MTDealTool.h
//  美团HD
//
//  Created by apple on 14/11/27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XDLDealModel;

@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;

+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(XDLDealModel *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(XDLDealModel *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(XDLDealModel *)deal;
/****************************************************************************
 ***************************************************************************/
//recent database
+ (NSArray *)RecentDeals:(int)page;

+ (int)RecentDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addRecentDeal:(XDLDealModel *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeRecentDeal:(XDLDealModel *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isRecent:(XDLDealModel *)deal;

@end
