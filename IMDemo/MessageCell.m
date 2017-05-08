//
//  MessageCell.m
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import "Utility.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@implementation MessageCell

+(instancetype)cellWithTableView:(UITableView*)tableView dataWithModel:(MessageModel*)model{
    CGSize size= [self sizeLabelToFit:[Utility emotionStrWithString:model.message]];
    if (model.type==MessageTypeMe) {
        if ([model.dataType isEqualToString:@"text"]) {
            MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"myself"];
            if (!Cell) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeMe];
            }
            [Cell setBackgroundColor:tableView.backgroundColor];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Cell.myself.frame=CGRectMake(Width-size.width-70, 45, size.width, size.height);
            Cell.mymessage.frame=CGRectMake(Width-size.width-90, 25, size.width+40, size.height+40);
            
            Cell.mymessage.image=[self imageWithimage:[UIImage imageNamed:@"chat_send_dim"]];
            Cell.myname.text=model.name;
            
            Cell.myself.attributedText=[Utility emotionStrWithString:model.message];
            
            NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *Path = [PreferencePath stringByAppendingPathComponent:@"header.png"];
            Cell.header.image=[UIImage imageWithContentsOfFile:Path];
            [Cell.header.layer setCornerRadius:20];
            [Cell.header setClipsToBounds:YES];
            return Cell;
        }else{
            MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"myself"];
            if (!Cell) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeMe];
            }
            [Cell setBackgroundColor:tableView.backgroundColor];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Cell.myname.text=model.name;
            
            NSData *data=[[NSData alloc]initWithBase64EncodedString:model.message options:NSDataBase64DecodingIgnoreUnknownCharacters];
            Cell.photo.image=[UIImage imageWithData:data];
            
            NSString *PreferencePath = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject;
            NSString *Path = [PreferencePath stringByAppendingPathComponent:@"header.png"];
            Cell.header.image=[UIImage imageWithContentsOfFile:Path];
            [Cell.header.layer setCornerRadius:20];
            [Cell.header setClipsToBounds:YES];
            return Cell;
        }
    }else{
        if ([model.dataType isEqualToString:@"text"]) {
            MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"other"];
            if (!Cell) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeOther];
            }
            [Cell setBackgroundColor:tableView.backgroundColor];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Cell.other.frame=CGRectMake(70, 45, size.width, size.height);
            Cell.othermessage.frame=CGRectMake(50, 25, size.width+40, size.height+40);
            
            Cell.othermessage.image = [self imageWithimage:[UIImage imageNamed:@"chat_recive_nor"]];
            Cell.othername.text=model.name;
            Cell.other.attributedText=[Utility emotionStrWithString:model.message];
            Cell.headers.image=[UIImage imageNamed:model.image];
            [Cell.headers.layer setCornerRadius:20];
            [Cell.headers setClipsToBounds:YES];
            return Cell;
        }else{
            MessageCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"other"];
            if (!Cell) {
                Cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:MessageTypeOther];
            }
            [Cell setBackgroundColor:tableView.backgroundColor];
            Cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            Cell.othername.text=model.name;
            
            NSData *data=[[NSData alloc]initWithBase64EncodedString:model.message options:NSDataBase64DecodingIgnoreUnknownCharacters];
            Cell.image.image=[UIImage imageWithData:data];
            
            Cell.headers.image=[UIImage imageNamed:model.image];
            [Cell.headers.layer setCornerRadius:20];
            [Cell.headers setClipsToBounds:YES];
            
            return Cell;
        }
    }
}
#pragma mark ##### 计算Size #####
+ (CGSize)sizeLabelToFit:(NSMutableAttributedString *)String{
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width-123, Height)];
    tempLabel.attributedText = String;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    size = CGSizeMake(size.width, size.height);
    return size;
}
#pragma mark ##### 拉伸图片 #####
+(UIImage*)imageWithimage:(UIImage*)image{
    image=[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
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
