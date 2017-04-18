//
//  MessageCell.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@implementation MessageCell

+(instancetype)cellWithTableView:(UITableView*)tableView dataWithModel:(MessageModel*)model{
    CGSize size= [self sizeWithString:model.message];
    UIImage *image=[UIImage new];
    
    if (model.type==MessageTypeMe) {
        MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"myself"];
        if (!Cell) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeMe];
        }
        [Cell setBackgroundColor:tableView.backgroundColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        image=[UIImage imageNamed:@"chat_send_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        
        Cell.mymessage.frame=CGRectMake(Width-size.width-70, 20, size.width+40, size.height+40);
        Cell.myself.frame=CGRectMake(Width-size.width-50, 40, size.width, size.height);
        
        Cell.mymessage.image=image;
        Cell.myname.text=model.name;
        Cell.myself.text=model.message;
        return Cell;
    }else{
        MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"other"];
        if (!Cell) {
            Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeOther];
        }
        [Cell setBackgroundColor:tableView.backgroundColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        image=[UIImage imageNamed:@"chat_recive_nor"];
        image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];

        Cell.othermessage.frame=CGRectMake(30, 20, size.width+40, size.height+40);
        Cell.other.frame=CGRectMake(50, 40, size.width, size.height);
        
        Cell.othermessage.image =image;
        Cell.othername.text=model.name;
        Cell.other.text=model.message;
        return Cell;
    }
}
#pragma mark ##### 计算Size #####
+(CGSize)sizeWithString:(NSString*)string{
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width-100, Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    return size;
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
