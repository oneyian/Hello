//
//  MessageCell.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/14.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther   // 别人发的
} MessageType;

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *myself;
@property (weak, nonatomic) IBOutlet UILabel *other;

+(instancetype)cellWithTableView:(UITableView*)tableView cellWithType:(MessageType)type;
@end
