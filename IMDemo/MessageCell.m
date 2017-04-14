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
    NSString *identifier=[NSString new];
    NSInteger index;
    if (type==MessageTypeMe) {
        identifier=@"myself";
        index=MessageTypeMe;
    }else{
        identifier=@"other";
        index=MessageTypeOther;
    }
    MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!Cell) {
        Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:index];
    }
    return Cell;
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
