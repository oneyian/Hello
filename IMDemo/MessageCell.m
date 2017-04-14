//
//  MessageCell.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

+(instancetype)cellWithTableView:(UITableView*)tableView cellWithType:(MessageType)type{
    if (type==0) {
        MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"myself"];
        if (!Cell) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
        }
        return Cell;
    }else if(type==1){
        MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"other"];
        if (!Cell) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:1];
        }
        return Cell;
    }else{
        return nil;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
