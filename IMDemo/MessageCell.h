//
//  MessageCell.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;

typedef enum {
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther   // 别人发的
} MessageType;

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *myname;
@property (weak, nonatomic) IBOutlet UIImageView *mymessage;
@property (weak, nonatomic) IBOutlet UILabel *myself;




@property (weak, nonatomic) IBOutlet UIImageView *headers;
@property (weak, nonatomic) IBOutlet UILabel *othername;
@property (weak, nonatomic) IBOutlet UIImageView *othermessage;
@property (weak, nonatomic) IBOutlet UILabel *other;

+(instancetype)cellWithTableView:(UITableView*)tableView dataWithModel:(MessageModel*)model;

+(UIImage*)imageWithimage:(UIImage*)image;
+ (CGSize)sizeLabelToFit:(NSMutableAttributedString *)String;

@end
