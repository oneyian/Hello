//
//  DevicesCell.h
//  IMDemo
//
//  Created by 王毅安 on 17/4/27.
//  Copyright © 2017年 王毅安. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *device;


+(instancetype)cellWithTableView:(UITableView*)tableView dataWithString:(NSString*)string;
+(CGSize)SizeWithString:(NSString*)string;

@end
