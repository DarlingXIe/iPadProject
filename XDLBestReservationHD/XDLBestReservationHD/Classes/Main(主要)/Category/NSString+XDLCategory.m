//
//  NSString+XDLCategory.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/12/15.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "NSString+XDLCategory.h"

@implementation NSString (XDLCategory)

-(instancetype)dealPriceString{
    
    NSString * currentStr = self;
    //查找小数点
    NSInteger currentPriceLoaction = [currentStr rangeOfString:@"."].location;
    //判断小数点是否找到小数点
    if(currentPriceLoaction != NSNotFound){
        if(currentStr.length - currentPriceLoaction > 3){
            //判断小数点超常 --> 保留两位小数
            currentStr = [currentStr substringToIndex:currentPriceLoaction + 3];
            if([currentStr hasSuffix:@"0"]){
                currentStr = [currentStr substringToIndex:currentStr.length -1];
            }
            //判断是否是8，如果是把8替换掉
            if([currentStr hasSuffix:@"8"]){
                currentStr = [currentStr stringByReplacingCharactersInRange:NSMakeRange(currentStr.length - 1, 1) withString:@"9"];
            }
        }
    }
    //没有小数点直接返回
    return currentStr;
}
- (NSString *)URLEncodedString{
    
    NSString *encodedString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}

@end
