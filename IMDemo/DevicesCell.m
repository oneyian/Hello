//
//  DevicesCell.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/27.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "DevicesCell.h"

@implementation DevicesCell
+(instancetype)cellWithTableView:(UITableView*)tableView dataWithString:(NSString*)string{
    CGSize size=[self SizeWithString:string];
    DevicesCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"devicesCell"];
    if (!Cell) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:@"DevicesCell" owner:self options:nil] firstObject];
    }
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Cell.device.frame=CGRectMake(20, 20, size.width, size.height);
    Cell.device.text=string;
    return Cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(CGSize)SizeWithString:(NSString*)string{
    CGSize size=[string boundingRectWithSize:CGSizeMake(130, 70) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    return size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
