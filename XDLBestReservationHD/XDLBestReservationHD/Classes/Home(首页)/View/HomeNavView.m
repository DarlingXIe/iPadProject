//
//  HomeNavView.m
//  HMMeiTuanHD19
//
//  Created by heima on 16/9/14.
//  Copyright © 2016年 heima. All rights reserved.
//
#import "HomeNavView.h"

@interface HomeNavView()
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
@implementation HomeNavView

/** 提供类方法, 快速创建View*/
+ (instancetype)homeNavView
{
    return [[NSBundle mainBundle] loadNibNamed:@"HomeNavView" owner:nil options:nil].firstObject;
}
//在内部实现按钮点击方法
- (IBAction)buttonClick:(id)sender {
    //当点击这个按钮时, 发出按钮被点击的事件
    //这里相当于, 点击了按钮之后, 发出了通知
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)setTarget:(id)target action:(SEL)action{
    [self.coverButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)setTitle:(NSString *)title{
    self.mainTitleLable.text = title;
}
-(void)setSubtitle:(NSString *)subtitle{
    self.subTitleLabel.text = subtitle;
}
-(void)setIcon:(NSString *)icon hightlightIcon:(NSString *)hightIcon{
    
    [self.coverButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    [self.coverButton setImage:[UIImage imageNamed:hightIcon] forState:UIControlStateHighlighted];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //view默认的autoresizingMask是有值得. 因此, 当发生压缩/放大时, 视图也会发生响应的效果
    //关闭这个属性, 就可以保证不变
    self.autoresizingMask = UIViewAutoresizingNone;
}
@end
