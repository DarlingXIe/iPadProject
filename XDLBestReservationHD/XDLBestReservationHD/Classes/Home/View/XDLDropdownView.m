//
//  XDLDropdownView.m
//  XDLBestReservationHD
//
//  Created by DalinXie on 16/10/21.
//  Copyright © 2016年 itcast. All rights reserved.
//
#import "XDLDropdownView.h"

@interface XDLDropdownView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@end

static NSString * leftCellId = @"leftCellId";
static NSString * rightCellId = @"rightCellId";

@implementation XDLDropdownView

+(instancetype)dropdownView{
    
    UINib * nib = [UINib nibWithNibName:@"XDLDropdownView" bundle:nil];
    return [nib instantiateWithOwner:nil options:nil][0];

}


#pragma tableViewData

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.leftTableView){
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftCellId forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor redColor];
        
        return cell;
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rightCellId forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor greenColor];
        
        return cell;
    
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
